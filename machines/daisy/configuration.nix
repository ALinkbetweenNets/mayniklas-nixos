# TTY: Control + Alt + F1
{ config, pkgs, nixos-hardware, ... }: {

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  home-manager.users."${config.mayniklas.home-manager.username}" = {
    mayniklas.programs = {
      sway.enable = true;
      waybar.enable = true;
    };
    home.packages =
      with pkgs; [
        xournalpp
      ];
  };

  # fingerprint login
  services.fprintd.enable = true;

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  mayniklas = {
    desktop = {
      enable = true;
      home-manager = true;
    };
    # gnome.enable = true;
    wayland.enable = true;
    # xmm7360.enable = true;
  };

  environment.systemPackages = with pkgs; [ ];

  networking = {
    hostName = "daisy";
    networkmanager.enable = true;
  };

  # swapfile
  swapDevices = [{
    device = "/var/swapfile";
    size = (32 * 1024);
  }];

  system.stateVersion = "23.05";

}
