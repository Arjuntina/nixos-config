{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Kernel settings
  boot.kernel.sysctl = { "vm.swappiness" = 10;}; # slider from 1-100 which determines how "agressively" to use swap (default = 60 on most distros)

  # boot menu!
  boot.loader.systemd-boot.enable = false; # want to boot with GRUB
  boot.loader.grub.device = nodev;
  boot.loader.grub.efiSupport = true;

  # wifi stuff
  networking.networkmanager.enable = true;
  networking.hostName = "arjunslaptop";

  # Upgrading nix
  # What way can I do this manually?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true; # is this necessary? Does it reboot randomly? hm hm
  
  # Note: setting fileSystems is generally not
  # necessary, since nixos-generate-config figures them out
  # automatically in hardware-configuration.nix.
  #fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Enable the OpenSSH server. Not really sure?
  services.sshd.enable = true;
  # Maybe this as well?
  services.openssh.enable = true;

  # global packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Automatic Garbage Collection
  # What way can I do this manually?
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  users.users.arjuntina = {
    isNormalUser = true;
    description = "Arjun personal acct";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      git
      neovim
      firefox
      zoom
    ];
  };
}
