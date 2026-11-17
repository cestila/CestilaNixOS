{
  pkgs,
  lib,
  ...
}: {
  # Auto-install TPM (Tmux Plugin Manager) on activation
  home.activation.installTpm = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d ~/.tmux/plugins/tpm ]; then
      echo "Installing TPM (Tmux Plugin Manager)..."
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
  '';

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = false;

    extraConfig = ''
      # ==============================================================================
      #                                TPM PLUGINS
      # ==============================================================================
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-yank'
      set -g @plugin 'christoomey/vim-tmux-navigator'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'alexwforsythe/tmux-which-key'

      # Kanagawa Theme Plugin (Active by default)
      set -g @plugin 'Nybkox/tmux-kanagawa'
      set -g @kanagawa-theme 'Kanagawa'
      set -g @kanagawa-plugins "git cpu-usage ram-usage"
      set -g @kanagawa-ignore-window-colors true

      # ==============================================================================
      #                           TERMINAL & KEY HANDLING
      # ==============================================================================
      set -ga terminal-overrides ",*:RGB"
      set -as terminal-features ",*:RGB"
      set -as terminal-features ",*:usstyle"
      set -as terminal-features ",*:hyperlinks"

      set -s extended-keys on
      set -s extended-keys-format csi-u
      set -as terminal-features 'xterm*:extkeys'
      set -sg escape-time 10
      set-option -g history-limit 5000
      set -g renumber-windows on
      set -g set-clipboard on
      set -g status-position top
      set -gq allow-passthrough on

      # ==============================================================================
      #                                KEYBINDINGS
      # ==============================================================================
      unbind C-b
      bind-key C-a send-prefix
      unbind %
      unbind '"'

      # Window Splits
      bind v split-window -h -c "#{pane_current_path}"
      bind d split-window -v -c "#{pane_current_path}"
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"

      # VIM Pane Navigation
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Direct Pane Splits (without prefix, matching Ghostty Alt style)
      bind -n M-v split-window -h -c "#{pane_current_path}"
      bind -n M-d split-window -v -c "#{pane_current_path}"

      # Pane Resizing
      bind -r C-j resize-pane -D 15
      bind -r C-k resize-pane -U 15
      bind -r C-h resize-pane -L 15
      bind -r C-l resize-pane -R 15
      bind -n C-S-h resize-pane -L 10
      bind -n C-S-j resize-pane -D 10
      bind -n C-S-k resize-pane -U 10
      bind -n C-S-l resize-pane -R 10
      bind -r m resize-pane -Z

      # Copy Mode (Vim style)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Skip kill-pane prompt
      bind-key x kill-pane

      # Kill all sessions except current
      bind K confirm-before -p "Kill all other sessions? (y/n)" "kill-session -a"

      # Window Navigation
      bind-key -n C-Tab next-window
      bind-key -n C-S-Tab previous-window
      bind-key -n M-Tab new-window

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # General Window Management
      bind-key c new-window
      bind-key n next-window
      bind-key p previous-window
      bind-key t clock-mode
      bind-key q display-panes
      bind-key u refresh-client
      bind-key o select-pane -t :.+

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # ==============================================================================
      #                               DISPLAY POPUPS
      # ==============================================================================
      bind C-y display-popup -d "#{pane_current_path}" -w 80% -h 80% -E "lazygit"
      bind C-r display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "yazi"
      bind C-t display-popup -d "#{pane_current_path}" -w 75% -h 75% -E "bash"

      bind C-n display-popup -E 'bash -i -c "read -p \"Session name: \" name; tmux new-session -d -s \$name && tmux switch-client -t \$name"'
      bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

      # Floating scratchpad session toggle (alt+g)
      bind-key -n M-g if-shell -F '#{==:#{session_name},scratch}' {
        detach-client
      } {
        display-popup -d "#{pane_current_path}" -E -k "tmux new-session -A -s scratch"
      }

      # ==============================================================================
      #                     TOKYONIGHT MOON STYLE (OPTIONAL fallback)
      # ==============================================================================
      # To use manually styled statusbar instead of Kanagawa theme plugin,
      # comment out the Kanagawa section above, and uncomment this section:
      #
      # set -g status "on"
      # set -g status-bg "#222436"
      # set -g status-justify "left"
      # set -g status-left-length "100"
      # set -g status-right-length "100"
      # set -g message-style "fg=#86e1fc,bg=#3a3f5a,align=centre"
      # set -g message-command-style "fg=#86e1fc,bg=#3a3f5a,align=centre"
      # set -g pane-border-style "fg=#3a3f5a"
      # set -g pane-active-border-style "fg=#82aaff"
      # set -g window-status-activity-style "fg=#c8d3f5,bg=#222436,none"
      # set -g window-status-separator ""
      # set -g window-status-style "fg=#c8d3f5,bg=#222436,none"
      # set -g window-status-current-format "#[fg=#82aaff,bg=#222436] #I: #[fg=#c099ff,bg=#222436](✓) #[fg=#86e1fc,bg=#222436]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=#c099ff,bg=#222436]"
      # set -g window-status-format "#[fg=#82aaff,bg=#222436] #I: #[fg=#c8d3f5,bg=#222436]#W"
      # set -g status-right "#[fg=#82aaff,bg=#222436,nobold,nounderscore,noitalics]#[fg=#222436,bg=#82aaff,nobold,nounderscore,noitalics] #[fg=#c8d3f5,bg=#3a3f5a] #W #{?client_prefix,#[fg=#c099ff],#[fg=#86e1fc]}#[bg=#3a3f5a]#{?client_prefix,#[bg=#c099ff],#[bg=#86e1fc]}#[fg=#222436] #[fg=#c8d3f5,bg=#3a3f5a] #S "
      # set -g status-left ""
      # set -g clock-mode-colour "#82aaff"
      # set -g mode-style "fg=#82aaff bg=#444a73 bold"

      # Initialize TPM (Must remain at the very end of the file)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
