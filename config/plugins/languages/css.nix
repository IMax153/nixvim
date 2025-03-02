let
  jsPatterns = [
    "clsx%(([^)]+)%)"
    "cn%(([^)]+)%)"
  ];
in
{
  plugins.tailwind-tools = {
    enable = true;
    settings = {
      extension = {
        patterns = {
          javascript = jsPatterns;
          javascriptreact = jsPatterns;
          typescript = jsPatterns;
          typescriptreact = jsPatterns;
        };
      };
    };
  };

  plugins.lsp.servers = {
    tailwindcss.enable = true;
  };
}
