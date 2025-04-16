# zsh.nix

{
  programs = {
    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "catppuccin"
        "catppuccin-blur"
        "catppuccin-icons"
      ];
      userSettings = {
        assistant = {
          version = "2";
          default_model = {
            provider = "google";
            model = "gemini-2.0-flash";
          };
          default_width = 400;
        };
        languages = {
          Nix = {
            formatter.external.command = "nixfmt";
          };
        };
        lsp = {
          rust_analyzer.binary.path_lookup = true;
          nix.binary.path_lookup = true;
          nil = {
            initialization_options = {
              nix.flake.autoArchive = true;
            };
          };
        };
        vim_mode = true;
      };
    };
  };
}
