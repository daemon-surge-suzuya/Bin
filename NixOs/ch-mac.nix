{ pkgs, lib, ... }:

let
_ = lib.getExe;
in

pkgs.writeShellScriptBin "ch-mac" ''

#!/bin/bash

usage() {
  echo "Usage: $0 [-i <interface>] [-m <new_mac>]"
  echo
  echo "Options:"
  echo "  -i <interface>   Specify the network interface (default: wlp3s0)"
  echo "  -m <new_mac>     Specify the new MAC address"
  echo "  --help           Display this help message"
}

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

interface="wlp3s0"
new_mac=""

options=$(getopt -o i:m: --long help -n "$0" -- "$@")
if [ $? -ne 0 ]; then
  echo "Invalid option" >&2
  usage
  exit 1
fi

eval set -- "$options"

while true; do
  case "$1" in
    -i)
      interface="$2"
      shift 2
      ;;
    -m)
      new_mac="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
  esac
done

if [ -z "$new_mac" ]; then
  new_mac="02:$(${_ pkgs.openssl} rand -hex 5 | sed 's/\(..\)/\1:/g; s/.$//')"
fi

ip link set dev "$interface" down

ip link set dev "$interface" address "$new_mac"

ip link set dev "$interface" up

echo "Changed MAC address of $interface to $new_mac"

''
