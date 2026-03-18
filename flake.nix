{
  description = "My personal Neovim configuration built with Nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system;
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              inherit inputs;
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
        in
        {
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          devShells.default = pkgs.mkShell {
            name = "nixvim";
            inputsFrom = [ config.treefmt.build.devShell ];
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };

          treefmt = {
            projectRootFile = "flake.nix";

            programs.deadnix.enable = true;
            programs.jsonfmt.enable = true;
            programs.mdformat.enable = true;
            programs.nixfmt.enable = true;
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;
            programs.statix.enable = true;
            programs.stylua.enable = true;

            settings.formatter = {
              yaml =
                let
                  settingsFormat = pkgs.formats.yaml { };
                  conf = settingsFormat.generate "yamlfmt-conf" {
                    formatter = {
                      include_document_start = true;
                      retain_line_breaks = true;
                    };
                  };
                in
                {
                  command = "sh";
                  options = [
                    "-eucx"
                    ''
                      ${pkgs.lib.getExe pkgs.yamlfmt} --conf ${conf} "$@"
                    ''
                  ];
                  includes = [
                    "*.yml"
                    "*.yaml"
                  ];
                };
            };
          };
        };
    };
}
