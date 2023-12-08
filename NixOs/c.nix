{ pkgs, lib, ... }:

let 
_ = lib.getExe;
in

pkgs.writeShellScriptBin "c" ''

for file ; do
    if [ -f "$file" ] ; then
        if [ -x "$file" ] ; then
            chmod -x "$file"
        else
            chmod +x "$file"
        fi
    else
        >&2 printf 'Error: %s does not exist.\n' "$file"
    fi
done

''
