# nixos-config

Configuration files for my nixos system

# How to use

Install NixOS on a computer
    Make sure hardware-configuration.nix is properly set up and can be found at /etc/nixos/hardware-configuration.nix

Clone the repo to a folder (ideally .config/nixos-config)

Create the file "device.txt" in the root directory of the repo and specify what device you are working on
    May need to modify some files so that this option is properly configured

Modify appropriate options 
    To extend the configuration to multiple systems, tie any option changes to the device name

Run "nixos-rebuild switch --flake ~/.config/nixos-config/ --impure"
    This command only needs to be run once - after this, just run "nrs"
    --impure flag is only used because each machine will have a different hardware-configuration.nix & for device.txt


