{
  plugins.lsp.servers = {
    rust_analyzer = {
      enable = true;
      packageFallback = true;
      cmd = [ "rust-analyzer" ];
      settings = {
        cargo = {
          target = "x86_64-unknown-linux-gnu";
          targetDir = true;
        };
        check = {
          command = "check";
          allTargets = false;
          targets = [ "x86_64-unknown-linux-gnu" ];
        };
      };

      installCargo = false;
      installRustc = false;
    };
  };
}
