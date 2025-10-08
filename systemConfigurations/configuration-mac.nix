{ config, lib, pkgs, inputs, ... }:

{
	imports = [ # Include the results of the hardware scan.
        ./hardware-configuration-mac.nix
        ./systemHardware/graphics.nix
        ./systemHardware/network.nix
	];

	config = {
        
        # Wifi Stuff (>:((((( ) -- i have to troubleshoot this
        # see why it's insecure and what I can do about it
        # I think just wait for the package/driver to eventually be updated (what I get for being on unstable ig)
        # Delete this code block later
        nixpkgs.config.permittedInsecurePackages = [
             "broadcom-sta-6.30.223.271-57-6.12.50"
        ];
        boot.extraModulePackages = [ pkgs.linuxPackages.broadcom_sta ];
        networking.networkmanager.enable = true;

		# NIX STUFF
		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		# HARDWARE STUFF
		# Ofc not real hardware (that is in hardware-configuration) but this is for the input devices configuration information

        # To enable all firmware? idk
        # It's part of my attempt to get network working on mac
        hardware.enableAllFirmware = true;

		# Enable CUPS to print documents.
		# services.printing.enable = true;

		# Modifying the sound servers.
        # Necessary background info:
        # Pulseaudio & Pipewire are intermediary programs between apps (eg. firefox) and ALSA - Advanced Linux Sound Architecture, which talks directly to sound cards
        # Is necessary because ALSA is a very low level program and does not support mixing or multi-app support
        # PulseAudio was the old default, also JACK? (which worked alongside pulseaudio i think? but idk)
        # Pipewire is the new default for modern systems
        # Most modern desktop environments now use Pipewire
        # For compatibility reasons, pipewire can emulate a pulseaudio server (which is shown below with the pulse.enable option)
        # Sound options:
		# hardware.pulseaudio.enable = true;
		# OR
		services.pipewire = {
		    enable = true;
			pulse.enable = true;
		};
        # For lower level control of sound, see ALSA (I think that's just something end users don't really touch)
        # For higher level control of sound, can use gui programs like pavucontrol

		# Enable touchpad support (enabled default in most desktopManager).
		services.libinput.enable = true;

		# Configure keymap in X11
		services.xserver.xkb.layout = "us"; # add latam as a keyboard variant?
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

		# Apple webcam (only enabled for mac)
		hardware.facetimehd.enable = true;

        # graphics stuff?
        myGraphics = "nouveau";

		# BACKGROUND PROCESSES STUFF
		# lower level things that form the "base" of the system

		# Use the systemd-boot EFI boot loader.
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

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
		services.displayManager.ly = {
			enable = true;
		};
        # Differeny lock screens
		programs.hyprlock.enable = true;

		# Desktop environment
		# services.xserver.desktopManager.gnome.enable = true;
		services.desktopManager.plasma6.enable = true;
        # environment.plasma6.excludePackages = with pkgs.kdePackages; [
            # kwallet
            # kwalletmanager
        # k];

		# X-org window managers
		services.xserver.windowManager = {
			# Qtile
			qtile.enable = false;
			# DWM
			dwm.enable = false;
			# I3
			i3.enable = false;
			i3.configFile = ./windowManagers/i3/config;
		};
		# HYPRLAND
		programs.hyprland = {
			enable = true;
			xwayland.enable = true;
		};



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

        boot.blacklistedKernelModules = [ "kvm_intel" ]; # Disable kvm virtualization on this intel CPU - this allows virtualbox to use the virtualization features of the CPU

		# Enables command line control of screen brightness
		programs.light.enable = true;


		# Root user packages & configuration options
		environment.systemPackages = [ #had to get rid of the with pkgs; line unfortunately :(
			pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
			pkgs.wget
		];

		# Not sure where these should go so they're just chilling here for now
		nixpkgs.config.allowUnfree = true;
		nixpkgs.config.nvidia.acceptLicense = true;

		programs.zsh.enable = true;
		users.defaultUserShell = pkgs.zsh;

		fonts.packages = with pkgs; [
			font-awesome                    # for fun icons!
            nerd-fonts.fira-code
            nerd-fonts.iosevka
            nerd-fonts.jetbrains-mono
		];

        services.flatpak.enable = true;
        systemd.services.flatpak-repo = {
            wantedBy = [ "multi-user.target" ];
            path = [ pkgs.flatpak ];
            script = ''
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            '';
        };

        # Getting rid of old/unused packages & generations (that are more than 14 days old)
        nix.gc = {
            automatic = true;                           # Automatically runs garbage collect w/ systemd timer
            persistent = true;                          # Runs garbage collect on boot if computer was asleep
            dates = "weekly";                           # Runs the garbage collection every week
            options = "--delete-older-than 14d -d";     # Deletes generations older than 14d, then garbage collects those generations
        };




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

