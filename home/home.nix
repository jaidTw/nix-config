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
    size = 24;
  };
  theme = {
    name = "Fluent-grey-Dark";
    package = (pkgs.fluent-gtk-theme.override { themeVariants = [ "grey" ]; });
  };
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./nixvim.nix
    ./zed.nix
    ./shell.nix
    ./tmux.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      google-chrome = prev.google-chrome.override {
        commandLineArgs = [
          "--enable-features=TouchpadOverscrollHistoryNavigation"
        ];
      };
    })
  ];

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      acpi
      devenv
      evince
      google-chrome
      nemo
      nil
      nixd
      nomacs
      obs-studio
      qpdfview
      slack
      telegram-desktop
      tig
      youtube-music
      zoom-us
      gnomeExtensions.kimpanel
      iconTheme.package
      theme.package
      cursorTheme.package
      parsec-bin
    ];
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
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
    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
        window.decorations = "None";
        font.normal.family = "MesloLGS Nerd Font";
        font.size = 14;
      };
    };
    firefox.enable = true;
    fd.enable = true;
    mpv.enable = true;
    wlogout.enable = true;
  };
  services = {
    easyeffects = {
      enable = false;
      preset = "Gracefus+Edits";
    };
    udiskie = {
      enable = true;
      notify = true;
      automount = false;
    };
  };
}
