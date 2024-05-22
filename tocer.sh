#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <file.md>"
    exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

# Function to generate TOC
generate_toc() {
    grep -E '^#{1,6} ' "$FILE" | sed -E 's/^(#{1,6}) /\1 /' | while read -r line; do
        level=$(echo "$line" | grep -o '^#' | wc -c)
        title=$(echo "$line" | sed 's/^#* //')
        anchor=$(echo "$title" | tr -cd '[:alnum:] ' | tr ' ' '-')
        printf "%*s- [%s](#%s)\n" $((level-1)) '' "$title" "$anchor"
    done
}

# Generate TOC
TOC=$(generate_toc)

# Insert TOC at the top of the file
{
    echo -e "$TOC\n"
    cat "$FILE"
} > temp.md && mv temp.md "$FILE"

echo "TOC inserted into $FILE"
