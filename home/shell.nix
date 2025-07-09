# zsh.nix

{ config, lib, pkgs, ... }:

{ 
  home = {
    packages = [
      pkgs.fishPlugins.fzf-fish
    ];
  };
  programs = {
    bat.enable = true;
    bottom.enable = true;
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
      changeDirWidgetOptions = [ "--preview 'lsd --icon=always --color=always --tree {} | head -200'" ];
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
    lsd = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    man.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        format = ''
          [╭─](white) ($shell)on $os$direnv$directory$git_branch$git_state$git_status$status
          [╰─](white)[❯](bold green) 
        '';
        right_format = ''$java$lua$julia$go$nodejs$ruby$rust$go$python$c$cpp$cmd_duration'';
        add_newline = false;
        directory.style = "bold fg:105";
        directory.truncate_to_repo = false;
        direnv.disabled = false;
        git_branch.style = "bold pink";
        os = {
          disabled = false;
          style = "bold fg:45";
          symbols.NixOS = " ";
          symbols.Macos = " ";
        };
        python.symbol = " ";
        rust.symbol = " ";
        shell = {
          disabled = false;
          bash_indicator = "bash";
          fish_indicator = "fish";
          zsh_indicator = "zsh";
          nu_indicator = "nu";
          style = "cyan bold";
        };
        status.disabled = false;
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      initContent =
        let
          zshConfigEarlyInit = lib.mkOrder 550 ''
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
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --icon=always --color=always $realpath'
            zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
            zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
                    fzf-preview 'echo ''${(P)word}'
            # switch group using `<` and `>`
            zstyle ':fzf-tab:*' switch-group '<' '>'
            # use tmux popup
            zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
          '';
          zshConfig = lib.mkOrder 1000 ''
            enable-fzf-tab
          '';
        in
          lib.mkMerge [
            zshConfigEarlyInit
            zshConfig
          ];
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
    fish = {
      enable = true;
      generateCompletions = true;
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
      shellInit = ''
    set --export fzf_preview_dir_cmd lsd -A --color=always --icon=always
    set --export fzf_fd_opts --follow --hidden --exclude .git
      '';
      shellInitLast = ''
    set -e FZF_DEFAULT_OPTS
    set -e FZF_CTRL_T_OPTS
    set -e FZF_CTRL_R_OPTS
    set -e FZF_ALT_C_OPTS
    set -e FZF_CTRL_T_COMMAND
    set -e FZF_ALT_C_COMMAND
    bind -e ctrl-t
    bind -e -M insert ctrl-t
    fzf_configure_bindings --directory=\ct --processes=\cp
      '';
    };
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
