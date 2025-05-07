{config, pkgs, lib, ...}:

{
	imports = [
		./alacritty/alacritty.nix
        ./hyprlock/hyprlock.nix
        ./mpv/mpv.nix
		./neovim/neovim.nix
        ./rofi/rofi.nix
        ./starship/starship.nix
        ./tmux/tmux.nix
        ./waybar/waybar.nix
        ./wofi/wofi.nix
        ./yt-dlp/yt-dlp.nix
        ./zathura/zathura.nix
	];

	# Enable/disable programs & some options through custom wrappers
	# The options here should be "high level" ones that encompass many changes and be ones I want to change frequently

	alacritty = {
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

    rofi = {
        enable = false;
    };

    starship = {
        enable = true;
    };

    tmux = {
        enable = true;
    };

    yt-dlp = {
        enable = true;
    };

    zathura = {
        enable = true;
    };
}
