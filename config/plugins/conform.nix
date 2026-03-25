{
  userCommands = {
    "FormatEnable" = {
      desc = "Enable format on save";
      command = {
        __raw =
          # lua
          ''
            function()
              vim.b.disable_autoformat = false
              vim.g.disable_autoformat = false
            end
          '';
      };
    };
    "FormatDisable" = {
      desc = "Disable format on save";
      bang = true;
      command = {
        __raw =
          # lua
          ''
            function(args)
              if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
              else
                vim.g.disable_autoformat = true
              end
            end
          '';
      };
    };
  };

  plugins.conform-nvim = {
    enable = true;
    settings = {
      log_level = "debug";
      notify_on_error = false;
      notify_no_formatters = false;
      format_after_save = {
        __raw =
          # lua
          ''
            function(bufnr)
              -- Disable with a global or buffer-local variable
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return {
                lsp_format = "prefer",
                stop_after_first = true,
                timeout_ms = 500,
                async = true,
              }
            end
          '';
      };
      formatters_by_ft =
        let
          js_common = {
            __unkeyed-1 = "oxfmt";
            __unkeyed-2 = "biome";
            stop_after_first = true;
          };
        in
        {
          javascript = js_common;
          javascriptreact = js_common;
          typescript = js_common;
          typescriptreact = js_common;
        };
    };
  };
}
