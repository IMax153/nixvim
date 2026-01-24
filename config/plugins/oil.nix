{
  plugins.oil = {
    enable = true;

    luaConfig = {
      pre =
        # lua
        ''
          ---------------------------------------------------------------------
          -- Helper Methods 
          ---------------------------------------------------------------------

          -- Helper function to parse process output
          local function parse_output(proc)
            local result = proc:wait()
            local ret = {}
            if result.code == 0 then
              for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
                -- Remove trailing slash
                line = line:gsub("/$", "")
                ret[line] = true
              end
            end
            return ret
          end

          -- Build git status cache
          local function new_git_status()
            return setmetatable({}, {
              __index = function(self, key)
                local ignore_proc = vim.system(
                  { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                  {
                    cwd = key,
                    text = true,
                  }
                )
                local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
                  cwd = key,
                  text = true,
                })
                local ret = {
                  ignored = parse_output(ignore_proc),
                  tracked = parse_output(tracked_proc),
                }

                rawset(self, key, ret)
                return ret
              end,
            })
          end
          local git_status = new_git_status()

          -- Clear git status cache on refresh
          local refresh = require("oil.actions").refresh
          local orig_refresh = refresh.callback
          refresh.callback = function(...)
            git_status = new_git_status()
            orig_refresh(...)
          end

        '';
    };

    settings = {
      use_default_keymaps = false;

      preview = {
        border = "rounded";
      };

      float = {
        padding = 4;
        max_width = 0.6;
        max_height = 0.7;
        border = "rounded";
        win_options = {
          winblend = 0;
        };
      };

      keymaps = {
        "g?" = "actions.show_help";
        "<CR>" = "actions.select";
        "<C-j>" = "actions.select_split";
        "<C-l>" = "actions.select_vsplit";
        "<C-t>" = "actions.select_tab";
        "<C-p>" = "actions.preview";
        "<C-c>" = "actions.close";
        "<C-r>" = "actions.refresh";
        "-" = "actions.parent";
        "_" = "actions.open_cwd";
        "`" = "actions.cd";
        "~" = "actions.tcd";
        "gs" = "actions.change_sort";
        "gx" = "actions.open_external";
        "g." = "actions.toggle_hidden";
        "q" = "actions.close";
      };

      view_options = {
        is_hidden_file =
          # lua
          ''
            function(name, bufnr)
              local dir = require("oil").get_current_dir(bufnr)
              local is_dotfile = vim.startswith(name, ".") and name ~= ".."
              -- if no local directory (e.g. for ssh connections), just hide dotfiles
              if not dir then
                return is_dotfile
              end
              -- dotfiles are considered hidden unless tracked
              if is_dotfile then
                return not git_status[dir].tracked[name]
              else
                -- Check if file is gitignored
                return git_status[dir].ignored[name]
              end
            end
          '';
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ''<cmd>Oil --float<cr>'';
      options = {
        desc = "Open Oil";
      };
    }
  ];
}
