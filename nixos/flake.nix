{
  description = "Primary Config";

  # your built and working system config
  outputs =
    input@{ self, ... }:
    let
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixos"; # hostname
        profile = "personal"; # select a profile defined from my profiles directory
        timezone = "America/Denver"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        # gpuType = "amd"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
      };

      userSettings = rec {
        username = "dalton"; # username
        name = "Dalton Dayton"; # name/identifier
        email = "daltondayton1@gmail.com"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "io"; # selcted theme from my themes directory (./themes/)
        wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
        browser = "firefox"; # Default browser; must select one from ./user/app/browser/
        # spawnBrowser =
        #   if ((browser == "qutebrowser") && (wm == "hyprland")) then
        #     "qutebrowser-hyprprofile"
        #   else
        #     (
        #       if (browser == "qutebrowser") then
        #         "qutebrowser --qt-flag enable-gpu-rasterization --qt-flag enable-native-gpu-memory-buffers --qt-flag num-raster-threads=4"
        #       else
        #         browser
        #     ); # Browser spawn command must be specail for qb, since it doesn't gpu accelerate by default (why?)
        # defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
        term = "kitty"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
        editor = "neovim"; # Default editor;
      };

      # TODO: This is where I left off. Look at the pkg stuff in phoenix flake.nix

    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system; # inherit passes the var in as an arg
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
        dalton = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];

        };
      };
    };

  # git repos - nixpkgs for example
  inputs = {
    # nixpkgs = {
    #   url = "github:NixOS/nixpkgs/nixos-24.05";
    # };

    #Shorter version of the above
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
