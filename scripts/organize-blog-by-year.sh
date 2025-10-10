#!/bin/bash

# Script to organize blog posts by year based on filename prefix (YYMMDD)
# Run this at the start of each new year to move posts from content/blog/ to content/blog/YYYY/

set -e

BLOG_DIR="content/blog"

echo "Organizing blog posts by year..."

# Create year directories if they don't exist
for year in 2023 2024 2025 2026 2027 2028 2029 2030; do
    mkdir -p "$BLOG_DIR/$year"
done

# Move posts based on YY prefix in filename
for file in "$BLOG_DIR"/*.md; do
    # Skip _index.md and other non-post files
    if [[ "$(basename "$file")" == "_index.md" ]]; then
        continue
    fi
    
    filename=$(basename "$file")
    
    # Extract year from YYMMDD prefix
    if [[ $filename =~ ^([0-9]{2})([0-9]{2})([0-9]{2}) ]]; then
        yy=${BASH_REMATCH[1]}
        year="20$yy"
        
        # Only move if year directory exists
        if [[ -d "$BLOG_DIR/$year" ]]; then
            echo "Moving $filename to $year/"
            mv "$file" "$BLOG_DIR/$year/"
        else
            echo "Warning: No directory for year $year, skipping $filename"
        fi
    else
        echo "Warning: $filename doesn't match YYMMDD pattern, skipping"
    fi
done

echo "Done organizing blog posts by year!"
echo ""
echo "Next steps:"
echo "1. Review the moved files"
echo "2. Update any hardcoded paths in templates if needed"
echo "3. Test the site build"
