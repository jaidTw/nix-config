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
    bat.enable = true;
    bottom.enable = true;
    fd.enable = true;
    firefox.enable = true;
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'lsd --tree {} | head -200'" ];
      defaultCommand = "fd --type f --follow --hidden --exclude .git";
      fileWidgetCommand = "fd --type f --follow --hidden --exclude .git";
      fileWidgetOptions = [
        "--height 60%"
        "--layout reverse"
        "--info inline"
        "--border"
        "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
        "--color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
      ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
      #tmux.enableShellIntegration = true;
    };
    git = {
      enable = true;
      delta.enable = true;
      extraConfig = {
        color.ui = true;
        core.editor = "nvim";
      };
      userEmail = "jessehuang2222@gmail.com";
      userName = "Jesse Huang";
    };
    jq.enable = true;
    lazygit.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    man.enable = true;
    mpv.enable = true;
    ripgrep.enable = true;
    starship = {
      enable = true;
      settings = {
        format = ''
[╭─](white)$os$direnv$directory$git_branch$git_state$git_status$status
[╰─](white)[❯](bold green) 
        '';
        right_format = ''$rust$cmd_duration'';
        add_newline = false;
        directory.style = "bold fg:105";
        directory.truncate_to_repo = false;
        direnv.disabled = false;
        git_branch.style = "bold pink";
        os.disabled = false;
        status.disabled = false;
      };
    };
    wlogout.enable = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
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
