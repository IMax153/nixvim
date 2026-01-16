{ lib, pkgs, ... }:
let
  gitWorktreePlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "git-worktree";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "IMax153";
      repo = "git-worktree.nvim";
      rev = "f2d5d4632512738fd7224e69bf37b1b63797f573";
      hash = "sha256-pMkgq+E+rGQ56IRnsvpgcE4NnFe5FHVVUyMoMRidUUE=";
    };
    doCheck = false;
    meta = with lib; {
      homepage = "https://github.com/IMax153/git-worktree.nvim/";
      license = licenses.mit;
    };
  };
in
{
  extraPlugins = [ gitWorktreePlugin ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>gwn";
      action = ''<cmd>lua require("git-worktree.snacks").create_worktree()<cr>'';
      options = {
        desc = "[G]it [W]orktree [N]ew";
      };
    }
    {
      mode = "n";
      key = "<leader>gws";
      action = ''<cmd>lua require("git-worktree.snacks").switch_worktree()<cr>'';
      options = {
        desc = "[G]it [W]orktree [S]witch";
      };
    }
    {
      mode = "n";
      key = "<leader>gwd";
      action = ''<cmd>lua require("git-worktree.snacks").delete_worktree()<cr>'';
      options = {
        desc = "[G]it [W]orktree [S]witch";
      };
    }
  ];
}
