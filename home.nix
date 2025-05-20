{config, pkgs, lib, ...}: 

{
    home.username = "arjuntina";
    home.homeDirectory = "/home/arjuntina";
    programs.home-manager.enable = true;

    home.packages = with pkgs;
    let
        RStudio-with-my-packages = rstudioWrapper.override{
            packages = with rPackages; [
                tidyverse
            ];
        };

    in [
        # CLI programs
        htop
        fastfetch

        # CLI Utilities
        starship
        gnumake
        gcc
        killall
        tree      # For vieweing directory trees
        ripgrep   # For nvim telescope
        gdb
        file      # delete later
        # For yt-dlp
        ffmpeg_7

        # Backend document stuff?
        ## Latex
        texliveFull
        texlab
        ## Other (idk what this is)
        pandoc

        # Programming
        # Python
        (pkgs.python3.withPackages (python-pkgs: [
            # Don't really want to include any packages here bc I would rather use a nix-shell
            # Unless there happens to be a really "universal" package
        ]))
        # Java
        jdk8

        # Desktop stuff
        ## Notifications
        swaynotificationcenter
        libnotify

        # GUI Programs
        ## Web browsers
        firefox
        qutebrowser
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
        imagej
        krita
        ## Audio/Video
        pavucontrol
        vlc
        kdePackages.kdenlive
        ## Coding
        RStudio-with-my-packages
        vscodium
        android-studio
        ## Sciency
        stellarium
        ## Virtual Machine
        virtualbox
        wineWowPackages.waylandFull
        winetricks
        dosbox-staging
        ## Utility
        flameshot
        qbittorrent
        ## Gaming
        (retroarch.withCores
            (cores: with cores; [
                mesen
                bsnes
            ])
        )
        # lunar-client
        ## Chess
        scid-vs-pc

        ## Classify Later
        # for gui flatpak
        gnome-software
    ];

    # Importing configurations of other programs
	imports = [
		./programs/programs.nix
		./windowManagers/windowManagers.nix
	];

	programs = {
		zsh = {
			enable = true;

            # Extra Configuration
            initContent = ''
                # ALIAS commands:
                # NIX ALIASES
                # for nixos-rebuild switch
                alias nrs='sudo nixos-rebuild switch --flake ~/.config/nixos-config/'
                # for nix shells (need to add nix-develop)
                alias nix-shell='nix-shell --command zsh'

                # OTHER PROGRAM ALIASES
                # for launching vim (neovim)
                alias v='vim'
                # for using yt-dlp (tho need to figure out more and maybe set some params bc I don't use this at all)
                alias y='yt-dlp'
            '';

            # Ease of use
			autosuggestion.enable = true;
            autocd = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh = {
				enable = true;
			};
		};
	};
    
    # Some session variables to set at login to make X11 apps scale better? Idk copied from ChatGPT and need to look into more thoroughly
    home.sessionVariables = {
        XWAYLAND_SCALE = "1";
        GDK_SCALE = "1";
        GDK_DPI_SCALE = "1";
        QT_SCALE_FACTOR = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "0";
        XCURSOR_SIZE = "24"; # Adjust depending on DPI
    };

   # Writing script files from ./scripts to ~/.local/bin/customScripts
   # Must be done individually because, although "recursive = true" would copy the files, the "executable = true" flag does not apply recursively through a directory
   # (maybe this will be fixed in future update? I hope I hope)
   # To-do: Move to scripts.nix file
   # Brightness Scripts
    home.file.".local/bin/customScripts/showBrightness.sh" = {
        source = ./scripts/showBrightness.sh;
        executable = true;
    };
    home.file.".local/bin/customScripts/brightnessUp.sh" = {
        source = ./scripts/brightnessUp.sh;
        executable = true;
    };
    home.file.".local/bin/customScripts/brightnessSlightUp.sh" = {
        source = ./scripts/brightnessSlightUp.sh;
        executable = true;
    };
    home.file.".local/bin/customScripts/brightnessDown.sh" = {
        source = ./scripts/brightnessDown.sh;
        executable = true;
    };
    home.file.".local/bin/customScripts/brightnessSlightDown.sh" = {
        source = ./scripts/brightnessSlightDown.sh;
        executable = true;
    };

    # This determines the home-manager release a configuration is compatible with, which helps avoid breakage when system-incompatible changes are introduced
    # Should not have to necessarily touch it but can periodically update it to ensure configuration syntax is "up to date"
    home.stateVersion = "23.11";
}
