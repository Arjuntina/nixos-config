# The organization of this document is incomplete -- hopefully I can make it cooler/better in the future!

{ config, lib, pkgs, ... }:

{

  # NIX STUFF
  # tbh i'm still learning this so its kinda messy rn

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];



  # HARDWARE STUFF
  # Ofc not real hardware (that is in hardware-configuration) but this is for the input devices configuration information
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";



  # BACKGROUND PROCESSES STUFF
  # lower level things that form the "base" of the system

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networks
  networking.hostName = "arjunslaptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
  	enable = true;  # Easiest to use and most distros use this by default.
	dns = "default";
	wifi.powersave = false;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Set your time zone.
  time.timeZone = "America/New_York";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  

  # DISPLAY + VISUAL STUFF

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable display/login manager
  services.displayManager.sddm.enable = true;

  # Desktop environment
  # services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  


  # USER ACCOUNT AND PACKAGES

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arjuntina = {
    isNormalUser = true;
    initialPassword = "123";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    # Packages for download
    packages = with pkgs;
    let
      RStudio-with-my-packages = rstudioWrapper.override{
        packages = with rPackages; [ 
	  devtools
	  curl
	  knitr
	  markdown
	  tidyverse
	  gt
	  ggthemes
	  shinylive
	];
      };
    in
    [
      # Text Editor
      neovim

      # CLI programs
      htop

      # Terminal
      (pkgs.python3.withPackages (python-pkgs: [
        python312Packages.tkinter
      ]))
      alacritty

      # Launchers (add dmenu one day maybe)
      rofi-wayland

      # Documents??
      texliveBasic
      pandoc

      # GUI Programs
      ## Web browsers
      firefox
      ## Communication
      thunderbird
      discord
      zoom-us
      ## Documents
      libreoffice-qt
      obsidian
      inkscape
      gimp
      blender
      zathura
      ## Coding
      RStudio-with-my-packages
      vscodium
      ## Learning
      anki-bin
      ## Sciency
      stellarium
      ## Virtual Machine
      virtualbox
      ## Utility
      flameshot
      cinnamon.nemo
      ## Gaming
      (retroarch.override {
        cores = with libretro; [
	  #N
	  mesen
	  bsnes
        ];
      })

      # What is this?
      tree

    ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    fira-code-nerdfont
    font-awesome
  ];


  # OTHER STUFF THAT I DON'T REALLY UNDERSTAND AND NEED/WANT TO FIGURE OUT

  # Sort out bc its getting a little messy rn
  # But this is for apple laptop webcam
  hardware.facetimehd.enable = true;

  # Hyprland
  # gosh I really need to clean up the config
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

