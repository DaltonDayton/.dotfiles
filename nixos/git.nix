{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Dalton Dayton";
    userEmail = "50755420+DaltonDayton@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "vim";
        autocrlf = false;
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebased = true;
      };
    };
  };

  # # This is Git's per-user configuration file.
  # [user]
  # 	name = Dalton Dayton
  # 	email = 50755420+DaltonDayton@users.noreply.github.com
  # [init]
  # 	defaultBranch = main
  # [core]
  # 	editor = vim
  # 	autocrlf = false
  # [push]
  # 	autoSetupRemote = true
  # [pull]
  # 	rebase = true
}
