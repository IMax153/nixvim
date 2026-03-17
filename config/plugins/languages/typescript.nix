{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  effectTsgo = inputs.effect-tsgo.packages.${pkgs.system}.effect-tsgo;

  oxlintWrapper = pkgs.writeShellScript "oxlint-wrapper" ''
    # Check for local oxlint installation
    LOCAL_OXLINT="$PWD/node_modules/.bin/oxlint"

    if [ -x "$LOCAL_OXLINT" ]; then
      exec "$LOCAL_OXLINT" "$@"
    else
      exec ${lib.getExe pkgs.unstable.oxlint} "$@"
    fi
  '';
in
{
  autoGroups = {
    oxlint_fix = {
      clear = true;
    };
  };

  autoCmd = [
    {
      desc = "Run oxlint --fix on save";
      event = [ "BufWritePost" ];
      group = "oxlint_fix";
      pattern = [
        "*.js"
        "*.jsx"
        "*.ts"
        "*.tsx"
        "*.mjs"
        "*.cjs"
        "*.mts"
        "*.cts"
      ];
      callback = {
        __raw =
          # lua
          ''
            function(args)
              if vim.g.disable_oxlint_fix or vim.b[args.buf].disable_oxlint_fix then
                return
              end

              local filepath = vim.api.nvim_buf_get_name(args.buf)
              if filepath == "" then return end

              vim.fn.jobstart(
                { "${oxlintWrapper}", "--fix", filepath },
                {
                  on_exit = function(_, exit_code)
                    if exit_code == 0 then
                      vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                          vim.api.nvim_buf_call(args.buf, function()
                            vim.cmd("checktime")
                          end)
                        end
                      end)
                    end
                  end,
                }
              )
            end
          '';
      };
    }
  ];

  userCommands = {
    "OxlintFixEnable" = {
      desc = "Enable oxlint fix on save";
      command = {
        __raw =
          # lua
          ''
            function()
              vim.b.disable_oxlint_fix = false
              vim.g.disable_oxlint_fix = false
            end
          '';
      };
    };
    "OxlintFixDisable" = {
      desc = "Disable oxlint fix on save";
      bang = true;
      command = {
        __raw =
          # lua
          ''
            function(args)
              if args.bang then
                vim.b.disable_oxlint_fix = true
              else
                vim.g.disable_oxlint_fix = true
              end
            end
          '';
      };
    };
  };

  extraPackages = with pkgs; [
    nodejs_24
  ];

  plugins.lsp.servers = {
    biome = {
      enable = true;
    };

    dprint = {
      enable = true;
      extraOptions.workspace_required = true;
    };

    eslint = {
      enable = true;
    };

    oxfmt = {
      enable = true;
      package = pkgs.unstable.oxfmt;
    };

    oxlint = {
      enable = true;
      package = pkgs.unstable.oxlint;
      cmd = [
        "${oxlintWrapper}"
        "--lsp"
      ];
    };
  };

  plugins.lsp.servers.tsgo = {
    enable = true;
    package = effectTsgo;
    cmd = [
      "${effectTsgo}/bin/tsgo"
      "--lsp"
      "--stdio"
    ];
    settings = {
      javascript.inlayHints = {
        enumMemberValues.enabled = false;
        functionLikeReturnTypes.enabled = false;
        parameterNames = {
          enabled = "literals";
          suppressWhenArgumentMatchesName = false;
        };
        parameterTypes.enabled = false;
        propertyDeclarationTypes.enabled = false;
        variableTypes = {
          enabled = false;
          suppressWhenTypeMatchesName = false;
        };
      };

      typescript.inlayHints = {
        enumMemberValues.enabled = false;
        functionLikeReturnTypes.enabled = false;
        parameterNames = {
          enabled = "literals";
          suppressWhenArgumentMatchesName = false;
        };
        parameterTypes.enabled = false;
        propertyDeclarationTypes.enabled = false;
        variableTypes = {
          enabled = false;
          suppressWhenTypeMatchesName = false;
        };
      };
    };
    onAttach.function = ''
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    '';
  };
}
