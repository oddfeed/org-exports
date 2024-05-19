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

# Function to generate TOC with 2 levels
generate_toc() {
    grep -E '^#{1,2} ' "$FILE" | sed -E 's/^(#{1,2}) /\1 /' | while read -r line; do
        level=$(echo "$line" | grep -o '^#' | wc -c)
        title=$(echo "$line" | sed 's/^#* //')
        anchor=$(echo "$title" | tr -cd '[:alnum:] ' | tr ' ' '-')
        indent=$((level - 1))
        printf "%*s- [%s](#%s)\n" $((indent * 4)) '' "$title" "$anchor"
    done
}

# Generate TOC
TOC=$(generate_toc)

# Insert TOC at the top of the file
{
    echo "# Table of Contents"
    echo
    echo "$TOC"
    echo
    cat "$FILE"
} > temp.md && mv temp.md "$FILE"

echo "TOC inserted into $FILE"
