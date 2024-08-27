# hyprlock.nix

{
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = false;
          no_fade_in = false;
        };

        background = [
          {
            path = "~/wallpaper/lock.jpg";
            blur_passes = 0;
            blur_size = 0;
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "400, 80";
            outline_thickness = 2;
            dots_size = 0.4; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = false;
            dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
            outer_color = "rgb(0, 0, 0, 0)";
            inner_color = "rgb(0, 0, 0, 0.2)";
            font_color = "rgb(10, 10, 10)";
            fade_on_empty = true;
            fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
            placeholder_text = "<i>input Password...</i>"; # Text rendered in the input box when it's empty.
            hide_input = false;
            rounding = -1; # -1 means complete rounding (circle/oval)
            check_color = "rgb(204, 136, 34)";
            fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
            fail_timeout = 2000; # milliseconds before fail_text and fail_color disappears
            fail_transition = 300; # transition time in ms between normal outer_color and fail_color
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false; # change color if numlock is off
            swap_font_color = false; # see below

            position = "-800, -120";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          {
            text = "cmd[update:10000] echo \"お帰りなさいませ、$(whoami)さま\"";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 42;
            font_family = "Noto Sans CJK";
            position = "-800, 10";
            halign = "center";
            valign = "center";
          }

          # DATE
          {
            text = "cmd[update:1000] echo \"$(date +\"%B %d, %A\")\"";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 42;
            font_family = "Montserrat";
            position = "-800, 300";
            halign = "center";
            valign = "center";
          }

          # TIME
          {
            text = "cmd[update:1000] echo \"$(date +\"%-R\")\"";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 130;
            font_family = "Motserrat Extrabold";
            position = "-800, 160";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
