{
  config,
  pkgs,
  userSettings,
  ...
}:

{
  programs.kitty = {
    enable = true;

    font = {
      name = userSettings.font;
      size = 11;
    };
  };
}
