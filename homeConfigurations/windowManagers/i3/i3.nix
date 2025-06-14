{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		i3.enable = lib.mkEnableOption "enables i3";
	};

	config = lib.mkIf config.i3.enable {
		xsession.windowManager.i3 = {
			enable = true;

			# Can write the entire config here but man why would i???
		};
	};

}
