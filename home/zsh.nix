# zsh.nix

{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    initExtraBeforeCompInit = ''
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with lsd when completing cd
      zstyle ':fzf-tab:*' popup-min-size 120 16
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
      zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
      	fzf-preview 'echo ''${(P)word}'
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'
      # use tmux popup
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    '';
    initExtra = ''
      enable-fzf-tab
    '';
    envExtra = ''
      export VISUAL=nvim
    '';
    prezto = {
      enable = true;
      pmodules = [
        "archive"
        "completion"
        "fzf-tab"
        "fast-syntax-highlighting"
        "autosuggestions"
      ];
      pmoduleDirs = [ "${config.home.homeDirectory}/.zprezto-contrib" ];
    };
    shellAliases = {
      btm = "btm --battery";
      df = "duf";
      du = "dust";
      htop = "btm";
      ping = "trip";
      traceroute = "trip";
      mtr = "trip";
      nixos-update = "sudo nixos-rebuild switch";
      cat = "bat -p";
    };
    sessionVariables = {
      MANROFFOPT = "-c";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };
}
