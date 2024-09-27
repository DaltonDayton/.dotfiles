{ pkgs, ... }:

{
  # OpenGL
  hardware.graphics.enable = true;

  # TODO: Look into these opengl settings

  # hardware.opengl.extraPackages = with pkgs; [
  #   rocmPackages.clr.icd
  # ];
}
