# nixvim.nix

{ inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.transparent_background = true;
      settings.flavour = "frappe";
    };
    opts = {
      autoindent = true;
      expandtab = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      shiftround = true;

      number = true;
      relativenumber = true;
      showmode = false;
      signcolumn = "number";
      updatetime = 200;
    };
    extraConfigLua = ''
      function LspCurFunc()
        return vim.b.lsp_current_function
      end
    '';
    plugins = {
      cmp = {
        enable = true;
        cmdline = {
          "/" = {
            completion = {
              autocomplete = [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ];
              completeopt = "menu,menuone,noselect";
              keyword_pattern = ''[[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]]'';
            };
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            preselect = "cmp.PreselectMode.Item";
            sources = [ { name = "cmp_buffer"; } ];
          };
          ":" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            preselect = "cmp.PreselectMode.Item";
            sources = [
              { name = "cmp_buffer"; }
              { name = "cmp_async_path"; }
              { name = "nvim_lsp"; }
            ];
          };
        };
        settings = {
          mapping = {
            "<C-y>" = "cmp.mapping.confirm({select = false})";
            "<C-e>" = "cmp.mapping.abort()";
            "<Up>" = "cmp.mapping.select_prev_item({behavior = 'select'})";
            "<Down>" = "cmp.mapping.select_next_item({behavior = 'select'})";
            "<C-p>" = ''
              cmp.mapping(function()
                  if cmp.visible() then
                    cmp.select_prev_item({behavior = 'insert'})
                  else
                    cmp.complete()
                  end
                end)
            '';
            "<C-n>" = ''
              cmp.mapping(function()
                  if cmp.visible() then
                    cmp.select_next_item({behavior = 'insert'})
                  else
                    cmp.complete()
                  end
                end)
            '';
          };
          snippet.expand = "function(args) vim.snippet.expand(args.body) end";
          sources = [
            { name = "nvim_lsp"; }
            { name = "cmp_buffer"; }
            { name = "async_path"; }
          ];
        };
      };
      cmp-async-path.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      comment.enable = true;
      guess-indent.enable = true;
      illuminate.enable = true;
      neo-tree.enable = true;
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "asm"
            "bash"
            "c"
            "cmake"
            "cpp"
            "css"
            "disassembly"
            "dockerfile"
            "gitignore"
            "go"
            "html"
            "javascript"
            "jq"
            "lua"
            "make"
            "meson"
            "objdump"
            "python"
            "rust"
            "scss"
            "ssh_config"
            "tablegen"
            "nix"
            "toml"
            "vim"
            "vimdoc"
            "xml"
            "yaml"
          ];
          indent.enable = true;
        };
      };
      lightline = {
        enable = true;
        settings = {
          colorscheme = "catppuccin";
          component = {
            charvaluehex = "0x%B";
          };
          component_function = {
            currentFunction = "v:lua.LspCurFunc";
          };
          active = {
            left = [
              [
                "mode"
                "paste"
              ]
              [
                "readonly"
                "filename"
                "modified"
              ]
            ];
            right = [
              [ "lineinfo" ]
              [ "percent" ]
              [
                "fileformat"
                "fileencoding"
                "filetype"
                "charvaluehex"
              ]
              [ "currentFunction" ]
            ];
          };
        };
      };
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          nixd.enable = true;
          nixd.settings.formatting.command = [ "nixfmt" ];
          pylyzer.enable = true;
          rust-analyzer = {
            installCargo = false;
            installRustc = false;
            enable = true;
          };
        };
      };
      lsp-status.enable = true;
      lsp-lines.enable = true;
      lspkind.enable = true;
    };
    performance = {
      byteCompileLua.enable = false;
      combinePlugins.enable = false;
    };
  };
}
