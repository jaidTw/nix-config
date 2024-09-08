# home.nix

{ pkgs, inputs, ... }:
let

  iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
  };
  cursorTheme = {
    name = "catppuccin-frappe-lavender-cursors";
    package = pkgs.catppuccin-cursors.frappeLavender;
    size = 40;
  };
  theme = {
    name = "Fluent-grey-Dark";
    package = (pkgs.fluent-gtk-theme.override { themeVariants = [ "grey" ]; });
  };
in
{
  imports = [
    ./desktop/hyprland.nix
    ./desktop/hyprlock.nix
    ./desktop/rofi.nix
    ./nixvim.nix
    ./shell.nix
    ./tmux.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.ags.homeManagerModules.default
  ];

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      acpi
      google-chrome
      nemo
      networkmanager_dmenu
      nomacs
      obs-studio
      playerctl
      slack
      telegram-desktop
      tig
      youtube-music
      zed-editor
      iconTheme.package
      theme.package
      cursorTheme.package
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
    };
  };
  catppuccin.enable = true;
  catppuccin.accent = "mauve";
  catppuccin.flavor = "macchiato";

  gtk = {
    inherit iconTheme theme cursorTheme;
    enable = true;
    font.name = "Noto Sans CJK TC Regular";
    font.size = 11;
    gtk3.extraCss = ''
      headerbar, .titlebar,
      .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
    gtk4.extraCss = ''
      window.messagedialog .response-area > button,
      window.dialog.message .dialog-action-area > button,
      .background.csd{
        border-radius: 0;
      }
    '';
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
        font.normal.family = "MesloLGS Nerd Font";
        font.size = 14;
      };
    };
    firefox.enable = true;
    fd.enable = true;
    mpv.enable = true;
    thunderbird = {
      enable = true;
      profiles = {
        "jaid" = {
          isDefault = true;
        };
      };
    };
    wlogout.enable = true;
  };
  services = {
    easyeffects.enable = true;
    easyeffects.preset = "Gracefus+Edits";
    udiskie = {
      enable = true;
      notify = true;
      automount = false;
    };
  };
}
