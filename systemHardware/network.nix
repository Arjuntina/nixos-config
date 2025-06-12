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

    # For managing network with GUI on window managers
    environment.systemPackages = [ 
        pkgs.networkmanagerapplet
    ];

    # For saving WIFI passwords (and others) to the GNOME keyring (can move to main configuration later - but am really only/mainly using for wifi rn)
    services.gnome.gnome-keyring.enable = true;
    # Integrates gnome keyring with the lightdm login manager! -- This setting makes PAM unlock gnome keyring when lightdm is used to login
    security.pam.services.lightdm.enableGnomeKeyring = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
