{ pkgs, ... }:
let
  tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
in
{
  plugins.lsp.servers = {
    astro = {
      enable = true;
      extraOptions = {
        init_options.typescript.tsdk = tsdk;
        before_init = {
          __raw = ''
            function(_, config)
              local local_tsdk = vim.fs.find(
                "node_modules/typescript/lib",
                { path = config.root_dir, upward = true, type = "directory" }
              )[1]

              config.init_options = config.init_options or {}
              config.init_options.typescript = config.init_options.typescript or {}
              config.init_options.typescript.tsdk = local_tsdk or "${tsdk}"
            end
          '';
        };
      };
    };
  };
}
