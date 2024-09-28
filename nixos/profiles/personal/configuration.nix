{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/kernel.nix
    ../../system/hardware/time.nix
    ../../system/hardware/opengl.nix
    ../../system/hardware/nvidia.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/bluetooth.nix
    (../../system/wm + ("/" + userSettings.wm) + ".nix")
  ];

  options = {
    # Example option
    my.arbitrary.option = lib.mkOption {
      type = lib.types.str;
      default = "stuff";
    };
  };

  config = {
    # Ensure nix flakes are enabled
    nix.package = pkgs.nixFlakes;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # wheel group gets trusted access to nix daemon. trusted users can execute nix commands without sudo.
    nix.settings.trusted-users = [ "@wheel" ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # TODO: these are likely not correct?

    # boot.kernelModules = [
    #   "i2c-dev"
    #   "i2c-piix4"
    #   "cpufre_powersave"
    # ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = systemSettings.hostname; # Define your hostname.
    networking.networkmanager.enable = true; # Use networkmanager
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Timezone and locale
    time.timeZone = systemSettings.timezone;
    i18n.defaultLocale = systemSettings.locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = systemSettings.locale;
      LC_IDENTIFICATION = systemSettings.locale;
      LC_MEASUREMENT = systemSettings.locale;
      LC_MONETARY = systemSettings.locale;
      LC_NAME = systemSettings.locale;
      LC_NUMERIC = systemSettings.locale;
      LC_PAPER = systemSettings.locale;
      LC_TELEPHONE = systemSettings.locale;
    };

    # Enable the GNOME Desktop Environment.
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;

    # User Account
    users.users.${userSettings.username} = {
      isNormalUser = true;
      description = userSettings.name;
      extraGroups = [
        "networkmanager" # for network management
        "wheel" # Provides admin privileges. Can execute commands with elevated privileges. On NixOS, grants trusted access to nix daemon.
        "input" # for input devices. e.g. mouse, keyboard
        "video" # for video devices. e.g. GPU, video capture cards, webcam
        "render" # for 3D acceleration. e.g. GPU
      ];
      packages = [ ];
      uid = 1000;
    };

    # System packages
    environment.systemPackages = with pkgs; [
      # Core
      zsh
      kitty
      firefox
      git
      vim
      home-manager
    ];

    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    fonts.fontDir.enable = true;

    hardware.logitech.wireless.enable = true;

    xdg.portal = {
      # enable = true;
      config.common.default = "pkgs.xdg-desktop-portal-hyprland";
      # extraPortals = [
      #   pkgs.xdg-desktop-portal
      #   pkgs.xdg-desktop-portal-gtk
      # ];
    };

    # Leave this unchanged
    system.stateVersion = "24.05";
  };
}
