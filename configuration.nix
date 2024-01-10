{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = false; # want to boot with GRUB
  boot.loader.grub.device = nodev;
  boot.loader.grub.efiSupport = true;

  networking.networkmanager.enable = true; # for wifi
  networking.hostName = "arjunslaptop";
  users.users.arjuntina.extraGroups = [ "networkmanager" ];

  # Upgrading nix
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true; # is this necessary? Does it reboot randomly? hm hm
  

  # Note: setting fileSystems is generally not
  # necessary, since nixos-generate-config figures them out
  # automatically in hardware-configuration.nix.
  #fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Enable the OpenSSH server.
  services.sshd.enable = true;
  # Maybe this as well?
  services.openssh.enable = true;
}
