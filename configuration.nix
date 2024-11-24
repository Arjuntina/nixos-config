{ config, lib, pkgs, inputs, ... }:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	options = {
		# What high level options to include
		# Toggle on/off window managers/display managers maybe
	};

	config = {
		# NIX STUFF
		nix.settings.experimental-features = [ "nix-command" "flakes" ];



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
        # Configure keybinds with keyd
        services.keyd = {
            enable = true;
            keyboards = {
                # The name is just the name of the configuration file, it does not really matter
                default = {
                    ids = [ "*" ]; # what goes into the [id] section -- here we select all keyboards
                    settings = {
                        main = {
                            # Move capslock to escape when pressed & control when held
                            capslock = "overload(control, esc)";
                            # Remaps the escape key to capslock
                            esc = "capslock";
                        };
                    };
                };
            };
        };

		# Apple webcam
		hardware.facetimehd.enable = true;

		# NVIDIA
		hardware.graphics = {
			enable = true;
		};
		# Load nvidia driver for Xorg and Wayland
		#services.xserver.videoDrivers = ["nvidia"];
		#hardware.nvidia = {
			# Modesetting is required.
			#modesetting.enable = true;
			# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
			# Enable this if you have graphical corruption issues or application crashes after waking
			# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
			# of just the bare essentials.
			#powerManagement.enable = false;
			# Fine-grained power management. Turns off GPU when not in use.
			# Experimental and only works on modern Nvidia GPUs (Turing or newer).
			#powerManagement.finegrained = false;
			# Use the NVidia open source kernel module (not to be confused with the
			# independent third-party "nouveau" open source driver).
			# Support is limited to the Turing and later architectures. Full list of 
			# supported GPUs is at: 
			# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
			# Only available from driver 515.43.04+
			# Currently alpha-quality/buggy, so false is currently the recommended setting.
			#open = false;
			# Enable the Nvidia settings menu,
			# accessible via `nvidia-settings`.
			#nvidiaSettings = true;
			# Optionally, you may need to select the appropriate driver version for your specific GPU.
			#package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
		#};



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
		
		# enables autofill for zsh commands
		environment.pathsToLink = [ "/share/zsh" ];



		# DISPLAY + VISUAL STUFF

		# Enable the X11 windowing system.
		services.xserver.enable = true;

		# Enable display/login manager
		# services.displayManager.sddm.enable = true;
		# Is this one too?
		# programs.hyprlock.enable = true;
		# security.pam.services.hyprlock = true;
		services.displayManager.ly = {
			enable = true;
		};

		# idk what this does but apparently is needed for sway?
		security.polkit.enable = true;

		# Desktop environment
		# services.xserver.desktopManager.gnome.enable = true;
		services.desktopManager.plasma6.enable = true;

		# X-org window managers
		services.xserver.windowManager = {
			# Qtile
			qtile.enable = true;
			# DWM
			dwm.enable = true;
			# I3
			i3.enable = true;
			i3.configFile = ./windowManagers/i3/config;
		};
		# HYPRLAND
		programs.hyprland = {
			enable = true;
			xwayland.enable = true;
		};
		# programs.waybar = {
		#	enable = true;
		#};



		# USER ACCOUNT AND PACKAGES
		# Define a user account. Don't forget to set a password with ‘passwd’.
		users.users.arjuntina = {
			isNormalUser = true;
			initialPassword = "123";
			extraGroups = [ 
				"wheel"   # Enable ‘sudo’ for the user.
				"video"   # Enable user to control screen brightness + whatnot
			];

			# Packages for download
			# Packages here have since been moved to home manager
			packages = with pkgs; [
			];

			shell = pkgs.zsh;
		};
		# More program configuration? hm hm hm
		programs.steam.enable = true;
		programs.steam.gamescopeSession.enable = true;
		programs.gamemode.enable = true;

		# Virtual machines? hm hm hm
		virtualisation.virtualbox.host.enable = true;
		users.extraGroups.vboxusers.members = ["arjuntina"];
		virtualisation.virtualbox.guest.enable = true;
		#virtualisation.virtualbox.guest.dragAndDrop = true;

		# Enables command line control of screen brightness
		programs.light.enable = true;

		# Root user packages & configuration options
		environment.systemPackages = [ #had to get rid of the with pkgs; line unfortunately :(
			pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
			pkgs.wget
			pkgs.git
		];

		# Not sure where these should go so they're just chilling here for now
		nixpkgs.config.allowUnfree = true;
		nixpkgs.config.nvidia.acceptLicense = true;

		programs.zsh.enable = true;
		users.defaultUserShell = pkgs.zsh;

		fonts.packages = with pkgs; [
			font-awesome
			fira
			(nerdfonts.override { 
				fonts = [ "FiraCode" "CodeNewRoman" "Iosevka"]; 
			})
		];




		# OTHER STUFF THAT I DON'T REALLY UNDERSTAND AND NEED/WANT TO FIGURE OUT


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
	};
}

