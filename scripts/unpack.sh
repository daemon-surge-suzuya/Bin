#!/bin/sh

# unpack: Unpacks stuff

usage() {
    >&2 printf '%s\n' "Usage: ${0##*/} [-c copy_path] file"
    exit 1
}

decompress() {
    case ${1##*.} in
        gz|tgz)   gunzip -qdc "$1" ;;
        xz|txz)   xz -qdcT 0 "$1"  ;;
        bz2|tbz)  bunzip2 -qdc "$1" ;;
        zst|zstd) zstd -dqc "$1" ;;
        lz4)      lz4 -dqc "$1" ;;
    esac
}

run() {
    case $1 in
        *tar.*|*.tgz|*.txz|*.tbz)
            files=$(decompress "$1" | tar -tf -)
            if [ -n "$files" ]; then
                echo "Unpacking:"
                decompress "$1" | tar -C "${COPY_PATH:-$PWD}" -xpf -
                echo "$files"
            else
                >&2 echo "No files to unpack in $1"
            fi
            ;;
        *.xz|*.gz|*.bz2|.zstd|.zst|.lz4)
            decompressed_file="${COPY_PATH:-$PWD}/${1%.*}"
            decompress "$1" > "$decompressed_file"
            echo "Unpacked: $decompressed_file"
            ;;
        *.zip)
            unzip -q "$1" -d "${COPY_PATH:-$PWD}"
            echo "Unpacked: $1"
            ;;
        *.rar)
            unrar x "$1" "${COPY_PATH:-$PWD}"
            echo "Unpacked: $1"
            ;;
        *.7z)
            7z x "$1" -o"${COPY_PATH:-$PWD}"
            echo "Unpacked: $1"
            ;;
        *.tar)
            files=$(tar -tf "$1")
            if [ -n "$files" ]; then
                tar -C "${COPY_PATH:-$PWD}" -xpf "$1"
                echo "Unpacking:"
                echo "$files"
            else
                >&2 echo "No files to unpack in $1"
            fi
            ;;
        *)
            >&2 echo "Unrecognized compression format: ${1##*.}"
            ;;
    esac
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    usage
fi

while [ "$1" ] ; do
    case $1 in
        -h|h)
            usage
            ;;
        -C|-c)
            COPY_PATH=$2
            shift
            ;;
        *)
            run "$1"
            ;;
    esac
    shift
done

