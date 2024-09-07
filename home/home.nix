# home.nix

{ pkgs, inputs, ... }:

{
  imports = [
    ./desktop/hyprland.nix
    ./desktop/hyprlock.nix
    ./desktop/rofi.nix
    ./nixvim.nix
    ./zsh.nix
    ./tmux.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.ags.homeManagerModules.default
  ];

  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    acpi
    google-chrome
    nemo
    networkmanager_dmenu
    nomacs
    nwg-look
    nwg-displays
    overskride
    slack
    telegram-desktop
    tig
    udiskie
    youtube-music
    zed-editor
    zoom-us
    hicolor-icon-theme
    gnome-icon-theme
    adwaita-icon-theme
  ];
  catppuccin.enable = true;
  catppuccin.accent = "mauve";
  catppuccin.flavor = "macchiato";

  gtk = with pkgs; {
    enable = true;
    font.name = "Noto Sans CJK TC Regular";
    iconTheme = {
      name = "Dracula";
      package = dracula-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-frappe-lavender-cursors";
      package = catppuccin-cursors.frappeLavender;
      size = 40;
    };
    theme = {
      name = "Fluent-grey-Dark";
      package = (fluent-gtk-theme.override { themeVariants = [ "grey" ]; });
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  programs = {
    ags = {
      enable = true;
      configDir = ./desktop/ags;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.8;
        font.normal.family = "FiraCode Nerd Font Mono";
        font.size = 14;
      };
    };
    firefox.enable = true;
    fd.enable = true;
    mpv.enable = true;
    wlogout.enable = true;
  };
  services = {
    easyeffects.enable = true;
    easyeffects.preset = "Gracefu's Edits";
    mako = {
      enable = true;
      defaultTimeout = 15000;
      font = "Noto Sans CJK TC 14";
      icons = true;
      # FIXME: don't use hard-coded path
      iconPath = "/etc/profiles/per-user/jaid/share/icons/Dracula:/etc/profiles/per-user/jaid/share/icons/Adwaita:/etc/profiles/per-user/jaid/share/icons/hicolor:/etc/profiles/per-user/jaid/share/pixmaps";
      height = 110;
      width = 300;
      borderRadius = 6;
      margin = "10";
      padding = "5,5,20,10";
    };
    ssh-agent.enable = true;
    udiskie = {
      enable = true;
      notify = true;
      automount = false;
    };
  };
}
