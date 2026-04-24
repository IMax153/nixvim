{
  plugins.lsp.servers = {
    rust_analyzer = {
      enable = true;
      packageFallback = true;
      cmd = [ "rust-analyzer" ];
      settings = {
        cargo = {
          target = "x86_64-unknown-linux-musl";
          targetDir = true;
        };
        check = {
          command = "check";
          allTargets = false;
          targets = [ "x86_64-unknown-linux-musl" ];
        };
      };

      installCargo = false;
      installRustc = false;
    };
  };
}
