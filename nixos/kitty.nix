{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Fira Code Nerd Font";
      size = 11;
    };
  };
}
