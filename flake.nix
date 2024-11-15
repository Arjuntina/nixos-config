{
	description = "a NixOS Configuration Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

		home-manager = {
			url = "github:nix-community/home-manager?ref=release-24.05";
			inputs.nixpkgs.follows = "nixpkgs";                              # set the input nixpkgs to home manager be the same as the input to this flake to save some space
		};

		hyprland.url = "github:hyprwm/Hyprland";

	};

	outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
		nixosConfigurations.arjunslaptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix

					home-manager.nixosModules.home-manager  {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.arjuntina = import ./home.nix;
					}

			];
		};
	};
}
