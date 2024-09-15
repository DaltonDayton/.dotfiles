{ config, pkgs, ... }:
let
  myAliases = {
    c = "clear";
    cll = "clear && ll";
    l = "eza -lh --icons=auto"; # Long List
    ls = "eza -1 --icons=auto"; # Short List
    ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # Long list all
  };
in
{
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
  };
}
