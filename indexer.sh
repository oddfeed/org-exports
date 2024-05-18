#!/bin/bash

rm index.md
output_file="index.md"

echo "<head>" >> "$output_file"
echo '<script async src="https://analytics.goinghome.earth/script.js" data-website-id="519b085c-73db-408b-bf40-6cb4d158dfbc"></script>' >> "$output_file"
echo "</head>" >> "$output_file"
echo "# Masterlist"  >> "$output_file"
echo "This index was automatically generated and is sorted by year created"  >> "$output_file"
echo "---" >> "$output_file"
echo "[main site](https://alienate.earth/)" >> "$output_file"

files_by_year=()
dirs_by_year=()

# Function to add an entry to the appropriate year in the array
add_entry() {
    local year=$1
    local entry=$2
    local type=$3

    if [[ "$type" == "file" ]]; then
        files_by_year+=("$year:$entry")
    elif [[ "$type" == "dir" ]]; then
        dirs_by_year+=("$year:$entry")
    fi
}

# Iterate over files with specific extensions
for file in *.{html,md,pdf}; do
    if [ "$file" == "README.md" ] || [ "$file" == "index.md" ] || [ ! -e "$file" ]; then
        continue
    fi

    year=$(stat -f "%Sm" -t "%Y" "$file")
    if [[ "$file" == *.pdf ]]; then
        entry="- [$file](https://org.alienate.earth/${file%.*}.pdf)"
    else
        entry="- [$file](https://org.alienate.earth/${file%.*}.html)"
    fi

    add_entry "$year" "$entry" "file"
done

# Iterate over directories
for dir in */; do
    dir=${dir%/}
    year=$(stat -f "%Sm" -t "%Y" "$dir")
    entry="- [/$dir](https://org.alienate.earth/$dir/index.html)"

    add_entry "$year" "$entry" "dir"
done

# Combine the entries from both arrays and sort them by year
all_entries=("${files_by_year[@]}" "${dirs_by_year[@]}")
sorted_entries=$(printf "%s\n" "${all_entries[@]}" | sort)

# Write the sorted entries to the output file
current_year=""
while IFS= read -r entry; do
    year="${entry%%:*}"
    content="${entry#*:}"
    if [ "$year" != "$current_year" ]; then
        current_year="$year"
        echo "# $year" >> "$output_file"
    fi
    echo -e "$content" >> "$output_file"
done <<< "$sorted_entries"
