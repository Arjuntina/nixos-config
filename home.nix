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

        # Backend document stuff?
        texliveBasic
        pandoc
        quarto

        # Programming?
        # Python
        (pkgs.python3.withPackages (python-pkgs: [
            python312Packages.tkinter
            python312Packages.manim
        ]))

        # Launchers (add dmenu one day maybe)
        rofi-wayland

        # Notifications
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
        mpv
        # manim
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
        nemo
        ## Gaming
        (retroarch.override {
            cores = with libretro; [
                mesen
                bsnes
            ];
        })

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
            '';

            # Ease of use
			autosuggestion.enable = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh = {
				enable = true;
			};
		};
	};

 	home.stateVersion = "23.11";
}
