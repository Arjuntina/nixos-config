{config, pkgs, lib, ...}:

{
	imports = [
		./alacritty/alacrittyConfig.nix
        ./mpv/mpvConfig.nix
		./neovim/neovimConfig.nix
        ./rofi/rofi.nix
        ./waybar/waybar.nix
        ./yt-dlp/yt-dlp.nix
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
        enable = true;
    };

    waybar = {
        enable = true;
    };

    yt-dlp = {
        enable = true;
    };
}
