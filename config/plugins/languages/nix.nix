{ lib, pkgs, ... }:
{
  extraPackages = with pkgs; [
    nixfmt-rfc-style
  ];

  plugins = {
    nix.enable = true;
    nix-develop.enable = true;

    lsp.servers = {
      nixd = {
        enable = true;
        settings =
          let
            flake = ''builtins.getFlake "github:IMax153/nix-config'';
            flakeNixvim = ''(builtins.getFlake "github:IMax153/nixvim)""'';
          in
          {
            nixpkgs = {
              expr = "import ${flake}.inputs.nixpkgs { }";
            };
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
            options = {
              nixvim.expr = ''${flakeNixvim}.packages.${pkgs.system}.default.options'';
            };
          };
      };
    };
  };
}
