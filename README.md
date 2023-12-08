# Bin

This repository contains a collection of simple Bash scripts that I use regularly. The scripts have been adapted for use in NixOS, allowing them to be easily imported into the system environment using the `environment.SystemPackages` configuration. To facilitate integration, the scripts are rewritten in the Nix language using the `writeShellScriptBin` function, which creates a derivation that you can add to `environment.systemPackages`.

## How To Import

To incorporate these scripts into your NixOS configuration, you can utilize the [callPackage](https://summer.nixos.org/blog/callpackage-a-tool-for-the-lazy/) function. Below is an example of how to use the `callPackage` function:

```nix
( pkgs.callPackage /path/to/the/script/finder.nix {} )
```

Make sure to replace /home/moon/.config/Bin/NixOs/finder.nix with the actual path to your script.
