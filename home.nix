{config, pkgs, ...}: 
{
 	home.username = "arjuntina";
 	home.homeDirectory = "/home/arjuntina";
	programs.home-manager.enable = true;
 	#home.packages = with pkgs; [
 	#];
 	home.stateVersion = "23.11";
}
