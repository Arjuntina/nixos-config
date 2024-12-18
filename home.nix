{config, pkgs, lib, ...}: 

{
    home.username = "arjuntina";
    home.homeDirectory = "/home/arjuntina";
    programs.home-manager.enable = true;

	home.packages = with pkgs;
    let
        RStudio-with-my-packages = rstudioWrapper.override{
            packages = with rPackages; [
                devtools
                curl
                knitr
                markdown
                tidyverse
                tidymodels
                gt
                ggthemes
                shinylive
                quarto
                here
                tidycensus
                broom
                viridis
                patchwork
                reshape2
                shiny
                readr
                sf
                maps
                DT
                leaflet
                terra
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
	    ripgrep   # For nvim telescope
	    gdb
        file      # delete later
        # For yt-dlp
        ffmpeg_7

        # Backend document stuff?
        texliveBasic
        pandoc
        quarto

        # Programming
        # Python
        (pkgs.python3.withPackages (python-pkgs: [
            # Don't really want to include any packages here bc I would rather use a nix-shell
            # Unless there happens to be a really "universal" package
        ]))

        # Desktop stuff
        ## App Launchers (maybe make my own one day?)
        sirula
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
        zathura
        imagej
        ## Video
        vlc
        kdePackages.kdenlive
        ## Coding
        RStudio-with-my-packages
        vscodium
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
        ## Gaming
        (retroarch.override {
            cores = with libretro; [
                mesen
                bsnes
            ];
        })
        ## Chess
        scid-vs-pc
    ];

	imports = [
		./programs/programs.nix
		./windowManagers/windowManagers.nix
	];

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
		settings = builtins.fromTOML (builtins.readFile ./programs/starship/starshipConfig.toml);
	};

	programs = {
		zsh = {
			enable = true;

            # Extra Configuration
            initExtra = ''
                # ALIAS commands:
                # for nixos-rebuild switch
                alias nrs='sudo nixos-rebuild switch --flake ~/.config/nixos-config/'
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
