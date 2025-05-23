{ config, lib, pkgs, inputs, ... }:
{
		# Networks
		networking.hostName = "arjunslaptop"; # Define your hostname.
		# Pick only one of the below networking options.
		# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
		networking.networkmanager = {
			enable = true;  # Easiest to use and most distros use this by default.
			dns = "default";
			wifi.powersave = false;
		};
        # For managing network on window managers
		environment.systemPackages = [ 
			pkgs.networkmanageroutlet
        ];

		# Configure network proxy if necessary
		# networking.proxy.default = "http://user:password@proxy:port/";
		# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
