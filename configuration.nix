{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = false; # want to boot with GRUB
  boot.loader.grub.device = nodev;
  boot.loader.grub.efiSupport = true;

  networking.networkmanager.enable = true; # for wifi
  users.users.arjuntina.extraGroups = [ "networkmanager" ];
  

  # Note: setting fileSystems is generally not
  # necessary, since nixos-generate-config figures them out
  # automatically in hardware-configuration.nix.
  #fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Enable the OpenSSH server.
  services.sshd.enable = true;
  # Maybe this as well?
  services.openssh.enable = true;
}