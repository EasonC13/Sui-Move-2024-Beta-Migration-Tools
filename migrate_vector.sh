#!/bin/bash

# Check if Move.toml exists in the current directory
if [ ! -f "./Move.toml" ]; then
    echo "Move.toml file not found in the current directory."
    exit 1
fi

# echo "Have you committed all changes and there are no uncommitted changes? (yes/no)"
# read USER_CONFIRMATION

# if [ "$USER_CONFIRMATION" != "yes" ]; then
#     echo "Please commit all changes before running this script."
#     exit 1
# fi

# Process all .move files in the ./source directory
find ./sources -type f -name "*.move" | while read FILENAME; do
    # Perform the replacement using more compatible syntax
    # and ensure no unnecessary spaces are included in the replacement
    sed -i.bak -E 's/vector::([a-zA-Z_]+)\((&mut |&)?([a-zA-Z_]+),\s*(.*)\)/\3.\1(\4)/g' "$FILENAME"
    
    if [ $? -eq 0 ]; then
        echo "Processing completed for $FILENAME."
        # Delete the backup file after successful processing
        rm "${FILENAME}.bak"
    else
        echo "An error occurred during processing $FILENAME. Restoring the original file."
        # Restore the original file from backup and remove the .bak file
        mv "${FILENAME}.bak" "$FILENAME"
        echo "Original file has been restored for $FILENAME. Please check your file for errors."
    fi
done
