{ lib, pkgs, ... }:
let
  gitWorktreePlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "git-worktree";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "IMax153";
      repo = "git-worktree.nvim";
      rev = "441e7ec7ae7a8f85a1effdae7386042d9ded776a";
      hash = "sha256-d5OGPNCnlbt6MbWNGNxI4EwAfiJaI0Yd1tFsSC/T2Ws=";
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
