{ pkgs, lib, ... }:
let
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
  extraPackages = with pkgs; [
    nodejs_24
  ];

  plugins.lsp.servers = {
    biome = {
      enable = true;
    };

    dprint = {
      enable = true;
    };

    eslint = {
      enable = true;
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

  plugins.typescript-tools = {
    enable = true;
    settings = {
      separate_diagnostic_server = true;
      publish_diagnostic_on = "insert_leave";
      complete_function_calls = true;
      include_completions_with_insert_text = true;
      code_lens = "off";
      disable_member_code_lens = true;
      jsx_close_tag = {
        enable = true;
        filetypes = [
          "javascriptreact"
          "typescriptreact"
        ];
      };

      # Tsserver Settings
      tsserver_max_memory = 12288;
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "literals";
        includeInlayParameterNameHintsWhenArgumentMatchesName = false;
        includeInlayVariableTypeHints = false;
        includeInlayVariableTypeHintsWhenTypeMatchesName = false;
        includeInlayPropertyDeclarationTypeHints = false;
        includeInlayFunctionParameterTypeHints = false;
        includeInlayEnumMemberValueHints = false;
        includeInlayFunctionLikeReturnTypeHints = false;
      };
      tsserver_format_options = {
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true;
        semicolons = "ignore";
      };

      # Disable auto-formatting through the Typescript LSP
      on_attach = {
        __raw =
          # lua
          ''
            function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          '';
      };
    };
  };
}
