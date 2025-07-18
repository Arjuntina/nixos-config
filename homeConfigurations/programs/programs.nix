{config, pkgs, lib, ...}:

{

	imports = [
		./alacritty/alacritty.nix
        ./anki/anki.nix
        ./hyprlock/hyprlock.nix
        ./mpv/mpv.nix
		./neovim/neovim.nix
        ./retroarch/retroarch.nix
        ./rofi/rofi.nix
        ./starship/starship.nix
        ./tmux/tmux.nix
        ./waybar/waybar.nix
        ./wofi/wofi.nix
        ./yt-dlp/yt-dlp.nix
        ./zathura/zathura.nix
	];

    config = {

        # Enable/disable programs & some options through custom wrappers
        # The options here should be "high level" ones that encompass many changes and be ones I want to change frequently

        alacritty = {
            enable = true;
        };

        anki = {
            enable = true;
        };

        mpv = {
            enable = true;
        };

        neovim = {
            enable = true;

            # Custom option which declares the colorscheme of neovim so that I don't have to go digging around the configuration files
            # Options = catppuccin & tokyonight
            colorscheme = "catppuccin";
        };

        retroarch = {
            enable = true;
        };

        rofi = {
            enable = false;
        };

        starship = {
            enable = true;
        };

        tmux = {
            enable = true;
        };

        wofi = {
            enable = true;
        };

        yt-dlp = {
            enable = true;
        };

        zathura = {
            enable = true;
        };
    };
}
