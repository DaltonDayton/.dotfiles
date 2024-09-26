{ config, pkgs, ... }:
{
  # Symlink your existing nvim configuration
  home.file.".config/nvim" = {
    source = ./nvim; # Path to your nvim config directory
    recursive = true;
  };

  # Optionally, manage Neovim plugins and settings
  programs.neovim = {
    enable = true;
    # Additional configurations can go here
  };
}
