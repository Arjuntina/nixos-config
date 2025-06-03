# nixos-config

Configuration files for my nixos system

# How to use

Install NixOS on a computer
    Make sure hardware-configuration.nix is properly set up and can be found at /etc/nixos/hardware-configuration.nix

Clone the repo to a folder (ideally .config/nixos-config)

Modify appropriate options 

Run "nixos-rebuild switch --flake ~/.config/nixos-config/ --impure"
    This command only needs to be run once - after this, just run "nrs"


