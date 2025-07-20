# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/configuration.nix
      # inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ];

    
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      insmod search_fs_uuid
      insmod chain
      search --fs-uuid --set=root $FS_UUID
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

  services.fwupd.enable = true;
  hardware.framework.amd-7040.preventWakeOnAC = true;

  boot.extraModulePackages = [
    pkgs.linuxKernel.packages.linux_6_6.apfs
  ];

  # boot.loader.systemd-boot.configurationLimit = 20;

  # fix time always being incorrect when booting to windows
  time.hardwareClockInLocalTime = true;
}
