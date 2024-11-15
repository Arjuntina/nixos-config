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

        # CLI Utilities
        gnumake
        gcc
        killall

        # Backend document stuff?
        texliveBasic
        pandoc
        quarto

        # Terminal
        alacritty

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
        manim
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
                mesen
                bsnes
            ];
        })

        # What is this?
        tree
    ];

	imports = [
		./programs/programs.nix
	];

 	home.stateVersion = "23.11";
}
