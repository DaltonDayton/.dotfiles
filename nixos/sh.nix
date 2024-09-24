{ config, pkgs, ... }:
let
  myAliases = {
    c = "clear";
    cll = "clear && ll";
    l = "eza -lh --icons=auto"; # Long List
    ls = "eza -1 --icons=auto"; # Short List
    ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # Long list all
    ld = "eza -lhD --icons=auto"; # long list dirs
    lt = "eza --icons=auto --tree"; # list folder as tree
    githist = "git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=short --date-order";
    githistall = "git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --all --date=short --date-order";
    ff = "fzf --preview 'bat {-1} --color=always'";
    sz = "source ~/.zshrc";

    poetryactivate = "source $(poetry env info --path)/bin/activate";
    pa = "poetryactivate";
    pd = "deactivate";

    # Handy change dir shortcuts
    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";

    # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
    mkdir = "mkdir -p";
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
