# zsh.nix

{ config, ... }:

{
  programs = {
    bat.enable = true;
    bottom.enable = true;
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

    zsh = {
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
        cat = "bat -p";
        btm = "btm --battery";
        df = "duf";
        du = "dust";
        htop = "btm";
        less = "bat -p";
        ping = "trip";
        traceroute = "trip";
        mtr = "trip";
      };
      sessionVariables = {
        MANROFFOPT = "-c";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      };
    };
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
  };
}
