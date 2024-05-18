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

for file in *.{html,md,pdf}; do
    if [ "$file" == "README.md" ] || [ "$file" == "index.md" ]; then
        continue
    fi

    year=$(stat -f "%Sm" -t "%Y" "$file")

    if [[ ! ${files_by_year[$year]+_} ]]; then
        files_by_year[$year]=""
    fi

    if [[ "$file" == *.pdf ]]; then
        files_by_year[$year]+="- [$file](https://org.alienate.earth/${file%.*}.pdf)\n"
    else
        files_by_year[$year]+="- [$file](https://org.alienate.earth/${file%.*}.html)\n"
    fi
done

# Write to the file
for year in "${!files_by_year[@]}"; do
    echo "# $year" >> "$output_file"
    echo -e "${files_by_year[$year]}" >> "$output_file"
done
