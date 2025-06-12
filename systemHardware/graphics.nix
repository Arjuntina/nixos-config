{ config, lib, pkgs, inputs, ... }:
{
    options = {
        # Nouveau or proprietary Nvidia graphics
        myGraphics = lib.mkOption {
            type = lib.types.enum [ "nouveau" "nvidia" ];
            default = "nouveau";
            description = "Graphics drivers to use for the mac - nouveau or nvidia";
        };
    };

    config = lib.mkMerge [

    (lib.mkIf (config.myGraphics == "nvidia") {

        # enable opengl (an important graphics manager that def needs to be enabled)
        hardware.graphics = {
            enable = true;
        };

        # load nvidia driver for xorg and wayland
        services.xserver.videoDrivers = ["nvidia"];

        hardware.nvidia = {

            # modesetting is required.
            # means that nvidia is enabled at boot, which is what we want
            # don't need to think about this too hard 
            modesetting.enable = true;

            # nvidia power management. experimental, and can cause sleep/suspend to fail.
            # enable this if you have graphical corruption issues or application crashes after waking
            # up from sleep. this fixes it by saving the entire vram memory to /tmp/ instead 
            # of just the bare essentials.
            # see if this actually fixes/helps with the problem
            powerManagement.enable = true;

            # fine-grained power management. turns off gpu when not in use.
            # experimental and only works on modern nvidia gpus (turing or newer).
            # means this is not an option for the mac 750m gpu
            powerManagement.finegrained = false;

            # use the nvidia open source kernel module (not to be confused with the
            # independent third-party "nouveau" open source driver).
            # support is limited to the turing and later architectures. full list of 
            # supported gpus is at: 
            # https://github.com/nvidia/open-gpu-kernel-modules#compatible-gpus 
            # only available from driver 515.43.04+
            # currently alpha-quality/buggy, so false is currently the recommended setting.
            # also is not available for the mac 750m gpu
            open = false;

            # enable the nvidia settings menu,
            # accessible via `nvidia-settings`.
            nvidiaSettings = true;

            # optionally, you may need to select the appropriate driver version for your specific gpu.
            # 470 for the 750m mac gpu?
            # package = config.boot.kernelPackages.nvidiaPackages.stable;
            package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

        };

        # disable the open source drivers so that i can use the proprietary ones? 
        # not sure if this is really a good idea
        boot.blacklistedKernelModules = [ "nouveau" ];
    })

    (lib.mkIf (config.myGraphics == "nouveau") {
        # Nothing for now bc nouveau is the default I think but hopefully/maybe switch later to customize my experience
    })

    ];
}
