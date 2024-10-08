# rofi.nix

{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    catppuccin.enable = false;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-emoji-wayland ]; };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          font = "Montserrat 18";

          bg0 = mkLiteral "#242424D6";
          bg1 = mkLiteral "#7E7E7E70";
          bg2 = mkLiteral "#0860f2D6";

          fg0 = mkLiteral "#DEDEDE";
          fg1 = mkLiteral "#FFFFFF";
          fg2 = mkLiteral "#DEDEDE80";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        window = {
          background-color = mkLiteral "@bg0";

          location = mkLiteral "center";
          width = 640;
          border-radius = 8;
          transparency = "real";
        };

        "#inputbar" = {
          font = "Montserrat 20";
          padding = mkLiteral "12px";
          spacing = mkLiteral "12px";
          children = map mkLiteral [
            "icon-search"
            "entry"
          ];
        };

        "#icon-search" = {
          expand = false;
          filename = "search";
          size = mkLiteral "28px";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        "#entry" = {
          font = mkLiteral "inherit";
          placeholder = "Search";
          placeholder-color = mkLiteral "@fg2";
        };

        "#message" = {
          border = mkLiteral "2px 0 0";
          border-color = mkLiteral "@bg1";
          background-color = mkLiteral "@bg1";
        };

        "#textbox" = {
          padding = mkLiteral "8px 24px";
        };

        "#listview" = {
          lines = 10;
          columns = 1;

          fixed-height = false;
          border = mkLiteral "1px 0 0";
          border-color = mkLiteral "@bg1";
        };

        "#element" = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "16px";
          background-color = mkLiteral "transparent";
        };

        "element normal active" = {
          text-color = mkLiteral "@bg2";
        };

        "element alternate active" = {
          text-color = mkLiteral "@bg2";
        };

        "element selected normal, element selected active" = {
          background-color = mkLiteral "@bg2";
          text-color = mkLiteral "@fg1";
        };

        "#element-icon" = {
          size = mkLiteral "1em";
        };

        "#element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
  };
}
