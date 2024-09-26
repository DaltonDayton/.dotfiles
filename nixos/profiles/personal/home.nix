{
  config,
  pkgs,
  userSettings,
  ...
}:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    (../../system/wm + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
    ../../user/shell/sh.nix
    ../../user/app/nvim/nvim.nix
    ../../user/app/git/git.nix
    ../../user/app/kitty/kitty.nix
    ../../user/app/solaar/solaar.nix
  ];

  system.stateVersion = "24.05";

  home.packages = with pkgs; [
    # Core
    # Already listed in configuration.nix
    # zsh
    # kitty
    # firefox
    # git
    # vim

    # TODO: split these packages out into categories or
    # into separate files where applicable

    neovim
    kitty
    eza
    git
    nodejs
    unzip
    python3Full
    ripgrep
    xclip
    # mostly nvim stuff
    luarocks
    gcc
    rustc
    cargo
    python3Packages.tiktoken
    wget
    go
    php
    # composer
    jdk
    julia
    gh
    tree-sitter
    fd
    nodePackages.neovim
    lua
    lua51Packages.luarocks
    # (pkgs.ruby.withPackages (ps: with ps; [ neovim ]))
    lua-language-server
    lazygit
    stylua
    pyright
    isort
    black
    nixfmt-rfc-style
    nil
    # end mostly nvim stuff
    fzf
    bat
    fira-code-nerdfont
  ];

  # TODO: Look into these options before enabling

  # xdg.enable = true;
  # xdg.userDirs = {
  #   enable = true;
  #   createDirectories = true;
  #   music = "${config.home.homeDirectory}/Media/Music";
  #   videos = "${config.home.homeDirectory}/Media/Videos";
  #   pictures = "${config.home.homeDirectory}/Media/Pictures";
  #   download = "${config.home.homeDirectory}/Downloads";
  #   documents = "${config.home.homeDirectory}/Documents";
  #   desktop = null;
  #   publicShare = null;
  #   extraConfig = {
  #     XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
  #     XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
  #     XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Games Saves";
  #   };
  # };
  # xdg.mime.enable = true;
  # xdg.mimeApps.enable = true;
  # xdg.mimeApps.associations.added = {
  #   # TODO fix mime associations, most of them are totally broken :(
  #   "application/octet-stream" = "flstudio.desktop;";
  # };

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  # idk what this is
  # news.display = "silent";

  # gtk.iconTheme = {
  #   package = pkgs.papirus-icon-theme;
  #   name = if (config.stylix.polarity == "dark") then "Papirus-Dark" else "Papirus-Light";
  # };

  # idk what this is
  # services.pasystray.enable = true;
}
