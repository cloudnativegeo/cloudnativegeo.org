#!/bin/bash
# Move loose blog posts from content/blog/ into content/blog/YYYY/ based on
# their YYMMDD-* filename prefix. Re-runnable; safe at any time.

set -e

BLOG_DIR="content/blog"

shopt -s nullglob
moved=0
for file in "$BLOG_DIR"/*.md; do
    filename=$(basename "$file")
    [[ "$filename" == "_index.md" ]] && continue

    if [[ ! "$filename" =~ ^([0-9]{2})([0-9]{2})([0-9]{2}) ]]; then
        echo "skip (not YYMMDD-*): $filename" >&2
        continue
    fi

    year="20${BASH_REMATCH[1]}"
    mkdir -p "$BLOG_DIR/$year"
    mv "$file" "$BLOG_DIR/$year/"
    echo "moved $filename -> $year/"
    moved=$((moved + 1))
done

echo "$moved post(s) organized."
