#!/bin/bash

rm index.md
output_file="index.md"
echo "<head>" >> "$output_file"
echo '<script async src="https://analytics.goinghome.earth/script.js" data-website-id="519b085c-73db-408b-bf40-6cb4d158dfbc"></script>' >> "$output_file"
echo "</head>" >> "$output_file"
echo "# Masterlist"  >> "$output_file"
echo "This index was automatically generated and is sorted chronologically based on updated time"  >> "$output_file"
echo "---" >> "$output_file"

declare -A files_by_year_month

for file in *.html; do
    if [ "$file" == "README.md" ] || [ "$file" == "index.md" ]; then
        continue
    fi

    year_month=$(date -r "$file" +"%Y-%m")

    files_by_year_month[$year_month]+="- [$file](https://org.alienate.earth/${file%.*}.html)\n"
done

# Sort years and months and write to the file
previous_year=""
for year_month in $(echo ${!files_by_year_month[@]} | tr ' ' '\n' | sort -ur); do
    year=${year_month:0:4}
    month=${year_month:5:2}

    # Check if the year has changed and add a year heading if it has
    if [ "$year" != "$previous_year" ]; then
        echo "# $year" >> "$output_file"
        previous_year=$year
    fi

    # Convert month number to month name
    month_name=$(date -d "$year-$month-01" +"%B")

    echo "## $month_name" >> "$output_file"
    echo -e "${files_by_year_month[$year_month]}" >> "$output_file"
done

