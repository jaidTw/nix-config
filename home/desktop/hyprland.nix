# hyprland.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprland-workspaces
    hyprpaper
    hypridle
    hyprpicker
    hyprshade
    hyprland-monitor-attached
    grimblast
    kdePackages.qtwayland
    libnotify
    qt5ct
    qt6ct
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = false;
    enable = true;

    plugins = with pkgs; [ hyprlandPlugins.hyprexpo ];

    settings = {
      "$terminal" = "alacritty";
      "$filemanager" = "nemo";
      "$menu" = "rofi";
      "$mod" = "SUPER";
      "$browser" = "firefox";

      input = {
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.8;
        };
      };

      xwayland = {
        force_zero_scaling = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "current"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = true; # laptop touchpad
          gesture_fingers = 3; # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
      };

      exec-once = [
        #"/etc/nixos/home/desktop/migrate-workspaces.sh"
        "hyprpaper"
        "hypridle"
        "hyprctl setcursor catppuccin-frappe-lavender-cursors 36"
        "fcitx5 -d -r"
        "fcitx5-remote -r"
      ];

      env = [
        "HYPRCURSOR_THEME, catppuccin-frappe-lavender-cursors"
        "GDK_SCALE, 2"
        "XCURSOR_SIZE, 40"
        "HYPRCURSOR_SIZE, 36"

        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland "

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      bind =
        [
          "$mod, C, killactive"
          "$mod, E, exec, $filemanager"
          "$mod, F, exec, $browser"
          "$mod, J, togglesplit"
          "$mod, L, exec, wlogout"
          "$mod, M, exit"
          "$mod, P, pseudo"
          "$mod SHIFT, P, pin"
          "$mod, Q, exec, $terminal"
          "$mod, R, exec, $menu -show run"
          "$mod, F11, fullscreen"
          "ALT, F4, closewindow"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod ALT, left, swapwindow, l"
          "$mod ALT, right, swapwindow, r"
          "$mod ALT, up, swapwindow, u"
          "$mod ALT, down, swapwindow, d"

          "$mod CTRL, left, workspace, e-1"
          "$mod CTRL, right, workspace, e+1"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "SUPER_SHIFT, E, exec, rofi -mode emoji -show emoji"
          "ALT, Space, exec, $menu -show-icons -show drun"
          "$mod, V, togglefloating"
          ", Print, exec, grimblast copy area"
          "$mod, grave, hyprexpo:expo, toggle"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          )
        );
      bindm = [ "ALT, mouse:272, movewindow" ];

      binde = [
        "$mod SHIFT, left, resizeactive, -10 0"
        "$mod SHIFT, right, resizeactive, 10 0"
        "$mod SHIFT, up, resizeactive, 0 -10"
        "$mod SHIFT, down, resizeactive, 0 10"
      ];

      bindel = [
        ",XF86MonBrightnessUp, exec, brillo -qA 5"
        ",XF86MonBrightnessDown, exec, brillo -qU 5"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",switch:on:Lid switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:Lid switch, exec, hyprctl keyword monitor \"eDP-1, auto, preferred, 1\""
      ];

      windowrulev2 = [
        "pseudo, class:(fcitx)"
        "suppressevent maximize, class:.*"
      ];

    };
  };
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock --immediate";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 150;
            on-timeout = "brillo -O; brillo -qS 10";
            on-resume = "brillo -I 10";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 340;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "off";
        splash = true;
        splash_offset = 2.0;

        preload = [ "~/wallpaper/wallpaper.png" ];

        wallpaper = [
          "eDP-1,~/wallpaper/wallpaper.png"
          "HDMI-A-1,~/wallpaper/wallpaper.png"
        ];
      };
    };
  };
}
