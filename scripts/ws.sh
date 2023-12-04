#!/bin/bash

password="<your password>"
echo "$password" | sudo -S echo
sudo "${@:1}"
unset password
