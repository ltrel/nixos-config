#!/bin/sh
pushd ~/.config/nixos-config
sudo nixos-rebuild switch -I nixos-config=./configuration.nix
popd
