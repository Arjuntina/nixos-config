{
	description = "a NixOS Configuration Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";

            # ensures that home-manager uses the same nixpkgs source as nixpkgs so that no duplication occurs -- may slightly break home manager but shouldn't really 
			inputs.nixpkgs.follows = "nixpkgs"; 
        };

		hyprland.url = "github:hyprwm/Hyprland";

	};

	outputs = { self, nixpkgs, home-manager, hyprland, nixos-hardware, ... }@inputs: {
		nixosConfigurations.arjunslaptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./systemConfigurations/configuration-mac.nix

                # --- Add this overlay here ---
                # -- delete it later
                {
                    nixpkgs.overlays = [
                        (final: prev: {
                         vimPlugins = prev.vimPlugins // {
                         lualine-nvim = prev.vimUtils.buildVimPluginFrom2Nix {
                         pname = "lualine.nvim";
                         version = "unstable";
                         src = prev.fetchFromGitHub {
                         owner = "nvim-lualine";
                         repo = "lualine.nvim";
                         rev = "HEAD";
                        # This is the correct hash from your error output:
                         sha256 = "OpLZH+sL5cj2rcP5/T+jDOnuxd1QWLHCt2RzloffZOA=";
                         };
                         };
                         };
                         })
                    ];
                }

				home-manager.nixosModules.home-manager  {
                    # Whether to use the nix-pkgs options specified in the configuration.nix OR to use a private pkgs instance specified by home manager
                    # Want it to be true bc unites the whole system & prevents an extra evaluation of Nixpkgs 
                    # Also this configuration is not for multiple users - it should just be for me
					home-manager.useGlobalPkgs = true;
                    # Install packages to /etc/profiles instead of $HOME/.nix-profile
                    # Not sure what that really does (good or bad thing?)
                    # Most people have it enabled though so will do so explicitly here
					home-manager.useUserPackages = true;
					home-manager.users.arjuntina = import ./homeConfigurations/home.nix;
				}

			];
		};
	};
}
