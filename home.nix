{config, pkgs, lib, ...}: 

{
    imports = [
        ./programs/programs.nix
        ./windowManagers/windowManagers.nix
    ];

    options = {
        # High level options to include (eg. device)
        device = lib.mkOption {
            type = lib.types.enum [ "macbook15" "surfacepro" ];
            default = "macbook15";
            description = "Device being used -- macbook15, surfacepro";
        };
    };

    config = lib.mkMerge [
    {
        # Have to add extra code to strip a "\n" because \n is automatically added to the end of every file in vim
        device = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./device.txt);

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
            killall
            tree      # For vieweing directory trees
            ripgrep   # For nvim telescope
            # file      # for guessing what file type a particular document is
            # For yt-dlp
            ffmpeg_7

            # Backend document stuff?
            ## Latex
            texliveFull
            texlab
            pandoc # (for converting documents between diff types - eg. inserting latex into markdown)

            # Programming
            # Python
            (pkgs.python3.withPackages (python-pkgs: [
                # Don't really want to include any packages here bc I would rather use a nix-shell
                # Unless there happens to be a really "universal" package
            ]))
            # Java
            # jdk8

            # Desktop stuff
            ## Notifications
            swaynotificationcenter
            libnotify

            # GUI Programs
            ## Web browsers
            firefox
            qutebrowser
            ## Communication
            # thunderbird
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
            # kdePackages.kdenlive
            ## Coding
            # RStudio-with-my-packages
            vscodium
            # android-studio
            ## Sciency
            stellarium
            ## Virtual Machine
            # virtualbox
            # wineWowPackages.waylandFull
            # winetricks
            # dosbox-staging
            ## Utility
            flameshot
            # qbittorrent
            ## Gaming
            (retroarch.withCores
                (cores: with cores; [
                    mesen
                    bsnes
                ])
            )
            # lunar-client
            ## Chess
            # scid-vs-pc

            ## Classify Later
            # for gui flatpak
            # gnome-software
            # For managing keyring
            seahorse
            papirus-icon-theme #?? Didn't do much ok

            # Screenshots (explanation of what they do is in the screenshot script I have)
            grim
            slurp
            swappy

            # Command line control of clipboard
            wl-clipboard
        ];

        # Importing configurations of other programs

        programs = {
            zsh = {
                enable = true;

                # Extra Configuration
                initContent = ''
                    # ALIAS commands:
                    # NIX ALIASES
                    # for nixos-rebuild switch
                    # --impure flag added because I want to use a symlink to a computer's hardware configuration in /etc/nixos/hardware-configuration.nix
                    # Can maybe change/revise later (but idk if I'll need to?)
                    alias nrs='sudo nixos-rebuild switch --flake ~/.config/nixos-config/ --impure'
                    # for nix shells (need to add nix-develop)
                    alias nix-shell='nix-shell --command zsh'

                    # OTHER PROGRAM ALIASES
                    # for launching vim (neovim)
                    alias v='vim'
                    # for using yt-dlp (tho need to figure out more and maybe set some params bc I don't use this at all)
                    alias y='yt-dlp'
                    # Tmux
                    tm() {
                        case "$1" in
                            s)
                                if [ -n "$2" ]; then
                                    ~/.local/bin/customScripts/tmuxSessionLaunch.sh "$2"
                                else
                                    echo "Usage: tm s <session-name>"
                                fi
                                ;;
                            ls)
                                tmux ls
                                ;;
                            Q)
                                tmux kill-server
                                ;;
                            *)
                                command tmux "$@"
                                ;;
                        esac
                    }
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
       

        # LEARN ABOUT THE SCALING AND CURSOR STUFF BELOW BECAUSE THERE IS A LOT THAT IS BLINDLY COPIED AND PASTED AND I DON"T UNDERSTAND AT ALL
        # Some session variables to set at login to make X11 apps scale better? Idk copied from ChatGPT and need to look into more thoroughly
        home.sessionVariables = {
            XWAYLAND_SCALE = "1";
            GDK_SCALE = "1";
            GDK_DPI_SCALE = "1";
            QT_SCALE_FACTOR = "1";
            QT_AUTO_SCREEN_SCALE_FACTOR = "0";
            XCURSOR_THEME = "Banana";            # Should be set with home.pointerCursor below but set here just in case (fallback)
            XCURSOR_SIZE = "18";                                # Should be set with home.pointerCursor below but set here just in case (fallback)
            WLR_NO_HARDWARE_CURSORS = "1";                      # Forces the cursor to be rendered in software, reducing visual bugs such as offset (prob can delete but maybe play around w it first?)
            # Electron apps - force them to use wayland
            ELECTRON_ENABLE_WAYLAND = "1";      # What I think needs to be enabled for normal distros but doesn't work for me on hyprland
            NIXOS_OZONE_WL = "1";               # The setting which worked for me on nixos specifically
            
        };
        # Cursor stuff
        home.pointerCursor = {
            name = "Banana";
            package = pkgs.banana-cursor;
            size = 18;
        };
        dconf.settings = {
            "org/gnome/desktop/interface" = {
                cursor-blink = false;       # Otherwise the blinking is really bad on programs like firefox
            };
        };

        gtk.iconTheme.name = "Papirus-Dark";


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
       home.file.".local/bin/customScripts/screenshot.sh" = {
            source = ./scripts/screenshot.sh;
            executable = true;
       };
       home.file.".local/bin/customScripts/tmuxSessionLaunch.sh" = {
            source = ./scripts/tmuxSessionLaunch.sh;
            executable = true;
       };

       # This determines the home-manager release a configuration is compatible with, which helps avoid breakage when system-incompatible changes are introduced
       # Should not have to necessarily touch it but can periodically update it to ensure configuration syntax is "up to date"
       home.stateVersion = "23.11";
    }

    ];
}
