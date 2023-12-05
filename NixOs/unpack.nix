{ pkgs, lib, ... }:

let
_ = lib.getExe;
in

pkgs.writeShellScriptBin "unpack" '' 

usage() {
    >&2 printf '%s\n' "Usage: ''${0##*/} [-c copy_path] file"
    exit 1
}


decompress() {
    case ''${1##*.} in
        gz|tgz)   gunzip -qdc "$1" ;;
        xz|txz)   xz -qdcT 0 "$1"  ;;
        bz2|tbz)  bunzip2 -qdc "$1" ;;
        zst|zstd) zstd -dqc "$1" ;;
        lz4)      ${_ pkgs.lz4} -dqc "$1"
    esac
}

run() {
    case $1 in
        *tar.*|*.tgz|*.txz|*.tbz)
            decompress "$1" | \
            tar -C "''${COPY_PATH:-$PWD}" -xpf -
            ;;
        *.xz|*.gz|*.bz2|.zstd|.zst|.lz4)
            decompress "$1" "''${COPY_PATH:-$PWD}/''${1%.*}"
            ;;
        *.zip)
            ${_ pkgs.unzip} -q "$1" -d "$2"
            ;;
        *.rar)
            ${_ pkgs.unrar} x "$1"
            ;;
        *.7z)
            ''${_ pkgs.7z} x "$1"
            ;;
        *.tar)
            tar -C "''${COPY_PATH:-$PWD}" -xpf "$1"
            ;;
        *)
            >&2 echo "Unrecognized compression format: ''${1##*.}"
    esac

    echo "Finished unpacking $1"
}

while [ "$1" ] ; do
    case $1 in
        -h|h)
            usage
            ;;
        -C|-c)
            COPY_PATH=$1
            ;;
        *)
            run "$@"
    esac
    shift
done

''
