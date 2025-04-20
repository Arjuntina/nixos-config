{
	description = "a NixOS Configuration Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

		home-manager = {
			url = "github:nix-community/home-manager?ref=release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";                             # ensures that home-manager uses the same nixpkgs source as nixpkgs so that no duplication occurs -- may slightly break home manager but shouldn't really 
		};

		hyprland.url = "github:hyprwm/Hyprland";

        # This was only experimentally used for experimenting with hardware macbook modules - should probably delete soon
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

	};

	outputs = { self, nixpkgs, home-manager, hyprland, nixos-hardware, ... }@inputs: {
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

				# nixos-hardware.nixosModules.apple-macbook-pro-11-5 # not even fully correct but maybe hopefully good enough?

			];
		};
	};
}
