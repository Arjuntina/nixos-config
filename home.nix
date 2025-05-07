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
        ## Video
        vlc
        kdePackages.kdenlive
        ## Coding
        RStudio-with-my-packages
        vscodium
        android-studio
        ## Learning
        anki-bin
        ## Sciency
        stellarium
        ## Virtual Machine
        virtualbox
        wineWowPackages.waylandFull
        winetricks
        dosbox-staging
        ## Utility
        flameshot
        nemo
        qbittorrent
        ## Gaming
        (retroarch.override {
            cores = with libretro; [
                mesen
                bsnes
            ];
        })
        # lunar-client
        ## Chess
        scid-vs-pc

        ## Classify Later
        # for gui flatpak
        gnome-software
    ];

	imports = [
		./programs/programs.nix
		./windowManagers/windowManagers.nix
	];

	programs = {
		zsh = {
			enable = true;

            # Extra Configuration
            initExtra = ''
                # ALIAS commands:
                # NIX ALIASES
                # for nixos-rebuild switch
                alias nrs='sudo nixos-rebuild switch --flake ~/.config/nixos-config/'
                # for nix shells (need to add nix-develop)
                alias nix-shell='nix-shell --command zsh'

                # OTHER PROGRAM ALIASES
                # for launching vim (neovim)
                alias v='vim'
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



 	home.stateVersion = "23.11";
}
