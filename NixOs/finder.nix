{ pkgs }:

pkgs.writeShellScriptBin "f" ''

selected_file=$(find . -type f | ${pkgs.fzf})

if [ -z "$selected_file" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

file_type=$(${pkgs.file} -b --mime-type "$selected_file")

case "$file_type" in
    application/pdf)
        ${pkgs.zathura} "$selected_file" &
        ;;
    video/*)
        ${pkgs.mpv} "$selected_file" &
        ;;
    text/*)
        if command -v nvim &> /dev/null; then
            ${pkgs.neovim} "$selected_file"
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

''
