# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, nixos-hardware, ... }:
let primaryDisk = "/dev/nvme0n1"; in {

  imports = [
    # https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x390
    nixos-hardware.nixosModules.lenovo-thinkpad-x390
  ];

  services.throttled.enable = false;

  services.fwupd.enable = true;

  disko.devices.disk.main = {
    type = "disk";
    device = primaryDisk;
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "boot";
          start = "0";
          end = "1M";
          flags = [ "bios_grub" ];
        }
        {
          name = "ESP";
          start = "1M";
          end = "512M";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "nixos";
          start = "512M";
          end = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Bootloader
  boot.loader = {
    grub = {
      devices = [ primaryDisk ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    timeout = 10;
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = config.nixpkgs.config.allowUnfree;
}
