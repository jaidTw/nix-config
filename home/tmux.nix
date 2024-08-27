# tmux.nix

{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    sensibleOnTop = false;
    extraConfig = ''
      set -as terminal-overrides ",alacritty*:Tc"

      set -g prefix2 C-a
      bind C-a send-prefix -2

      setw -g pane-base-index 1

      setw -g automatic-rename on
      set -g renumber-windows on

      set -sg escape-time 10
      set -g focus-events on

      bind C-c new-session

      bind C-f command-prompt -p find-session 'switch-client -t %%'

      # session navigation
      bind BTab switch-client -l  # move to last session

      # split current window horizontally
      bind - split-window -v
      # split current window vertically
      bind _ split-window -h

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # maximize current pane
      bind + run "cut -c3- '#{TMUX_CONF}' | sh -s _maximize_pane '#{session_name}' '#D'"

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # window navigation
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window

      bind Enter copy-mode # enter copy mode

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line

      set -g status-key vi
      set -g mode-keys vi

      bind b list-buffers     # list paste buffers
      bind p paste-buffer -p  # paste from the top paste buffer
      bind P choose-buffer    # choose which buffer to paste from
    '';
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_right "user host session"
        '';
      }
      yank
    ];
  };
}
