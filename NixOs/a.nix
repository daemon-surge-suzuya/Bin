{ pkgs, lib, ... }:

let
_ = lib.getExe;
in 

pkgs.writeShellScriptBin "a" ''
usage() {
    echo "Usage: $0 [OPTIONS] <input_file> [output_file]"
    echo "Options:"
    echo "  -e, --extra-audio   Extract audio from video"
    echo "  -c, --comp-vid      Compress video"
    echo "  -a, --comp-aud      Compress audio"
    echo "  -h, --help          Display this help message"
    exit 1
}

OUTPUT_FILE="output.mp3"

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--extra-audio)
            EXTRA_AUDIO=true
            shift
            ;;
        -c|--comp-vid)
            COMPRESS_VIDEO=true
            shift
            ;;
        -a|--comp-aud)
            COMPRESS_AUDIO=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -lt 1 ]]; then
    echo "Error: Input file not specified."
    usage
fi

INPUT_FILE="$1"

if [[ $# -eq 2 ]]; then
    OUTPUT_FILE="$2"
fi

if [ "$EXTRA_AUDIO" = true ]; then
    ${_ pkgs.ffmpeg} -i "$INPUT_FILE" -vn -acodec mp3 -ab 256k "$OUTPUT_FILE"
    echo "Audio extracted successfully to $OUTPUT_FILE"
fi

if [ "$COMPRESS_VIDEO" = true ]; then
    ${_ pkgs.ffmpeg} -i "$INPUT_FILE" -vcodec libx264 -crf 23 "$OUTPUT_FILE"
    echo "Video compressed successfully to $OUTPUT_FILE"
fi

if [ "$COMPRESS_AUDIO" = true ]; then
    ${_ pkgs.ffmpeg} -i "$INPUT_FILE" -acodec libmp3lame -ab 128k "$OUTPUT_FILE"
    echo "Audio compressed successfully to $OUTPUT_FILE"
fi

exit 0

''
