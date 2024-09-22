{
  description = "Primary Config";

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

  # your built and working system config
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
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
}
