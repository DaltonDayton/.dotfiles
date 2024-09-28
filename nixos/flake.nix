{
  description = "Primary Config";

  outputs =
    inputs@{ self, ... }:
    let
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixos"; # hostname
        profile = "personal"; # select a profile defined from my profiles directory
        timezone = "America/Denver"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        gpuType = "nvidia"; # amd, intel, or nvidia
      };

      userSettings = rec {
        username = "dalton"; # username
        name = "Dalton Dayton"; # name/identifier
        email = "daltondayton1@gmail.com"; # email
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "io"; # Selected theme from themes directory (./themes/)
        wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
        browser = "firefox"; # Default browser; must select one from ./user/app/browser/
        term = "kitty"; # Default terminal command
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
        editor = "neovim"; # Default editor
      };

      # create patched nixpkgs
      nixpkgs-patched =
        (import inputs.nixpkgs {
          system = systemSettings.system;
        }).applyPatches
          {
            name = "nixpkgs-patched";
            src = inputs.nixpkgs;
            patches = [ ];
          };

      # configure pkgs
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      pkgs = (
        # if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab")) then
        #   pkgs-stable
        # else
        (import nixpkgs-patched {
          system = systemSettings.system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        })
      );

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-unstable = import inputs.nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      # configure lib
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      lib = (
        # if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab")) then
        #   inputs.nixpkgs-stable.lib
        # else
        inputs.nixpkgs.lib
      );

      # use home-manager-stable if running a server (homelab or worklab profile)
      # otherwise use home-manager-unstable
      home-manager = (
        #   if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab")) then
        #     inputs.home-manager-stable
        #   else
        inputs.home-manager-unstable
      );

      # Function to generate a set based on supported systems:
      # forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      # nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

    in
    {
      homeConfigurations = {
        dalton = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          ];
          specialArgs = {
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";
  };
}
