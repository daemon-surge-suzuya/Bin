#!/bin/bash
# f : It uses fzf tool for fuzzy finding and based on certain conditions uses appropriate tool to open the selected file

selected_file=$(find . -type f | fzf)

if [ -z "$selected_file" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

file_type=$(file -b --mime-type "$selected_file")

case "$file_type" in
    application/pdf)
        zathura "$selected_file" & 
        ;;
    video/*)
        mpv "$selected_file" & 
        ;;
    text/*)
        if command -v nvim &> /dev/null; then
            nvim "$selected_file"
        elif command -v vim &> /dev/null; then
            vim "$selected_file"
        else
            echo "No text editor (vim or nvim) found. Exiting."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported file type: $file_type. Exiting."
        exit 1
        ;;
esac

