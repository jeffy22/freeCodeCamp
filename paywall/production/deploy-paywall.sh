#!/bin/bash
# https://chatgpt.com/c/66f45955-0f90-8001-b3a1-7547d960b43c
# https://chatgpt.com/c/66f45592-0000-8001-9b8b-5a14052d7ee8

# Define an array of source and destination directory pairs
directories=(
    "~/j/at-gfx/paywall/production/Season1Halloween" "~/j/freeCodeCamp/config/i/p/s1"
    "~/j/at-gfx/paywall/production/Season2Christmas" "~/j/freeCodeCamp/config/i/p/s2"
    "~/j/at-gfx/paywall/production/Season3Valentine" "~/j/freeCodeCamp/config/i/p/s3"
    "~/j/at-gfx/paywall/production/Season4Summer"    "~/j/freeCodeCamp/config/i/p/s4"
    "~/j/at-gfx/paywall/production/"                "~/j/freeCodeCamp/config/i/p/"
)

# Loop through each source and destination pair
for ((i=0; i<${#directories[@]}; i+=2)); do
    src_dir="${directories[i]}"
    dest_dir="${directories[i+1]}"

    # Expand the tilde ~ using parameter expansion
    expanded_src_dir="${src_dir/#\~/$HOME}"
    expanded_dest_dir="${dest_dir/#\~/$HOME}"

    # Check if source directory exists
    if [ ! -d "$expanded_src_dir" ]; then
        echo "Source directory $expanded_src_dir does not exist. Skipping..."
        continue
    fi

    # Create the destination directory if it doesn't exist
    mkdir -p "$expanded_dest_dir"

    # Copy files from source to destination, removing the file extensions
    shopt -s nullglob # Enable to handle no files case
    for file in "$expanded_src_dir"/*.webp; do
        # Get the base name without the extension
        base_name=$(basename "$file" .webp)
        # Copy the file to the destination without the extension
        cp "$file" "$expanded_dest_dir/$base_name"
    done
    shopt -u nullglob # Disable nullglob after use
done

# Change to the repository directory
cd ~/j/freeCodeCamp || exit

# Add all changes, commit with the message "fmt", and push to origin master
git add *
git commit -a -m "fmt"

git push origin master