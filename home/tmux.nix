# tmux.nix
{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    sensibleOnTop = false;
    keyMode = "vi";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.rose-pine
    ];
    extraConfig = ''
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

      bind b list-buffers     # list paste buffers
      bind p paste-buffer -p  # paste from the top paste buffer
      bind P choose-buffer    # choose which buffer to paste from
    '';
    terminal = "tmux-256color";
  };
  catppuccin.tmux.extraConfig = ''
set -g @rose_pine_variant 'main' # Options are 'main', 'moon' or 'dawn'
set -g @rose_pine_host 'on' # Enables hostname in the status bar
set -g @rose_pine_date_time '%y/%m/%d %a %R %Z' # It accepts the date UNIX command format (man date for info)
set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
set -g @rose_pine_disable_active_window_menu 'on' # Disables the menu that shows the active window on the left
set -g @rose_pine_left_separator ' > ' # The strings to use as separators are 1-space padded
set -g @rose_pine_right_separator ' < ' # Accepts both normal chars & nerdfont icons
set -g @rose_pine_field_separator ' | ' # Again, 1-space padding, it updates with prefix + I
set -g @rose_pine_window_separator ' - ' # Replaces the default `:` between the window number and name
set -g @rose_pine_session_icon '' # Changes the default icon to the left of the session name
set -g @rose_pine_current_window_icon '' # Changes the default icon to the left of the active window name
set -g @rose_pine_folder_icon '' # Changes the default icon to the left of the current directory folder
set -g @rose_pine_username_icon '' # Changes the default icon to the right of the hostname
set -g @rose_pine_hostname_icon '󰒋' # Changes the default icon to the right of the hostname
set -g @rose_pine_date_time_icon '󰃰' # Changes the default icon to the right of the date module
set -g @rose_pine_window_status_separator "  " # Changes the default icon that appears between window names
  '';
}
