{ pkgs, lib, ... }:

let 
_ = lib.getExe;
in

pkgs.writeShellScriptBin "f" ''

selected_file=$(find . -type f | ${_ pkgs.fzf})

if [ -z "$selected_file" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

file_type=$(${_ pkgs.file} -b --mime-type "$selected_file")

case "$file_type" in
    application/pdf)
        ${_ pkgs.zathura} "$selected_file" &
        ;;
    image/*)
        ${_ pkgs.sxiv} "$selected_file" &
        ;;
    video/*)
        ${_ pkgs.mpv} "$selected_file" &
        ;;
    text/*)
        if command -v nvim &> /dev/null; then
            ${_ pkgs.neovide} "$selected_file"
        elif command -v vim &> /dev/null; then
            neovim "$selected_file"
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
