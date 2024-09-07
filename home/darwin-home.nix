{ inputs, pkgs, ... }:

{
  imports = [
    ./nixvim.nix
    ./shell.nix
    ./tmux.nix
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    tig
  ];

  catppuccin.enable = true;
  catppuccin.accent = "mauve";
  catppuccin.flavor = "macchiato";
}
