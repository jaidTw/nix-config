# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    timeout = 1;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPatches = [
    {
      name = "Rust Support";
      patch = null;
      features = {
        rust = true;
      };
    }
  ];

  networking.hostName = "FW13-nix"; # Define your hostname.
  networking.firewall.checkReversePath = false;
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
    };
  };

  time.timeZone = "Asia/Taipei";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_TW.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-qt
        fcitx5-rime
        fcitx5-mozc
        rime-data
        fcitx5-chewing
      ];
    };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security = {
    pam.services = {
      greetd.fprintAuth = true;
      hyprlock.fprintAuth = true;
      polkit-1.fprintAuth = true;
      sudo.fprintAuth = true;
    };
    sudo = {
      enable = true;
      configFile = "Defaults timestamp_timeout=25\n";
    };
  };
  # Enable sound.
  services = {
    blueman.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    openssh.enable = true;
    thermald.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "tuigreet --cmd hyprland";
        };
      };
    };
    udisks2.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jaid = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
    ];
    shell = pkgs.zsh;
  };
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmake
    clang
    dust
    duf
    fd
    ffmpeg
    file
    fprintd
    fzf
    gcc14
    binutils
    git
    gnumake
    greetd.tuigreet
    killall
    llvm
    neofetch
    ninja
    nixfmt-rfc-style
    p7zip
    pkg-config
    python3
    rustup
    socat
    unar
    unzip
    wget
    wireguard-go
    wireguard-tools
    wluma
    wl-clipboard-rs
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  gtk.iconCache.enable = true;
  programs = {
    dconf.enable = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    hyprland.enable = true;
    nm-applet.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    trippy.enable = true;
    zsh.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      montserrat
      icomoon-feather
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Meslo"
          "DaddyTimeMono"
          "JetBrainsMono"
        ];
      })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "MesloLGM Nerd Font Mono" ];
        sansSerif = [ "Noto Sans CJK TC" ];
        serif = [ "Noto Serif CJK TC" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>MesloLGM Nerd Font Mono</family>
            <prefer>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          <alias binding="weak">
            <family>monospace</family>
            <prefer>
              <family>emoji</family>
            </prefer>
          </alias>
          <alias binding="weak">
            <family>sans-serif</family>
            <prefer>
              <family>emoji</family>
            </prefer>
          </alias>
          <alias binding="weak">
            <family>serif</family>
            <prefer>
              <family>emoji</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
  };

  hardware = {
    brillo.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
