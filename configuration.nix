# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  lib,
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "jaid"
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = lib.mkForce false;
    timeout = 1;
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
  networking.firewall = {
    enable = true;
    extraInputRules = ''
      -s 192.168.1.0/24 -j ACCEPT
    '';
    checkReversePath = false;
  };
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
    };
  };

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security = {
    pam.services = {
      greetd.fprintAuth = true;
      polkit-1.fprintAuth = true;
      sudo.fprintAuth = true;
    };
    rtkit.enable = true;
    sudo = {
      enable = true;
      configFile = "Defaults timestamp_timeout=25\n";
    };
  };
  services = {
    accounts-daemon.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
    gvfs.enable = true;
    libinput.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      socketActivation = true;
      wireplumber.enable = true;
    };
    playerctld.enable = true;
    samba-wsdd.enable = true;
    thermald.enable = true;
    tzupdate.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  users.users.jaid = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "docker"
      "libvirtd"
    ];
    shell = pkgs.fish;
  };
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    linuxPackages_latest.perf
    brightnessctl
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
    killall
    llvm
    neofetch
    nfs-utils
    ninja
    nixfmt-rfc-style
    p7zip
    pkg-config
    python3
    rustup
    sbctl
    socat
    unar
    unzip
    wget
    wireguard-tools
    wl-clipboard-rs
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  gtk.iconCache.enable = true;
  programs = {
    dconf.enable = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nm-applet.enable = true;
    seahorse.enable = true;
    trippy.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      cantarell-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      montserrat
      icomoon-feather
      nerd-fonts.daddy-time-mono
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "MesloLGM Nerd Font" ];
        sansSerif = [ "Ubuntu" ];
        serif = [ "Noto Serif CJK TC" ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    trustedInterfaces = [ "lo" "wlan0" ]; # if you know the interface, safer
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 5353 ];
  };

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
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05"; # Did you read the comment?
}
