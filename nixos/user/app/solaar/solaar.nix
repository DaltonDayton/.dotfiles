{ config, pkgs, ... }:

{
  # Installing Solaar
  home.packages = with pkgs; [
    solaar
  ];

  # Managing the config file
  home.file.".config/solaar/rules.yaml".source = ./rules.yaml;
  home.file.".config/solaar/config.yaml".source = ./config.yaml;
}
