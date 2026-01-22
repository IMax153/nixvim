{ lib, pkgs, ... }:
let
  gitWorktreePlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "git-worktree";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "IMax153";
      repo = "git-worktree.nvim";
      rev = "d71df5062996021b8b34cd73bf189f91a36809be";
      sha256 = "sha256-wemtbbd7Qc+tpjx/EVJY/456j2DJYqdOyJ3QDW8BQnw=";
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
      key = "<leader>gw";
      action = ''<cmd>lua require("git-worktree.snacks").worktrees()<cr>'';
      options = {
        desc = "List [G]it [W]orktrees (Picker)";
      };
    }
    {
      mode = "n";
      key = "<leader>gwc";
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
