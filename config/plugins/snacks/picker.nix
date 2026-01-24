{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    fd
    ripgrep
  ];

  plugins.snacks.settings.picker = {
    enabled = true;
    matcher = {
      frecency = true;
    };
    layout = {
      # The default layout for "telescope-like" pickers (e.g. `files`, `commands`, ...)
      # It will not override non-standard pickers (e.g. `explorer`, `lines`, ...)
      preset = {
        # lua
        __raw = ''
          function()
            return vim.o.columns >= 120 and 'telescope' or 'vertical'
          end
        '';
      };
    };
    layouts = {
      telescope = {
        __raw =
          # lua
          ''
            {
              -- Copy from https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#telescope
              reverse = false,
              layout = {
                box = 'horizontal',
                backdrop = false,
                width = 0.8, -- Change the width
                height = 0.9,
                border = 'none',
                {
                  box = 'vertical',
                  {
                    win = 'input',
                    height = 1,
                    border = 'rounded',
                    title = '{title} {live} {flags}',
                    title_pos = 'center',
                  },
                  { win = 'list', title = ' Results ', title_pos = 'center', border = 'rounded' },
                },
                {
                  win = 'preview',
                  title = '{preview:Preview}',
                  width = 0.51, -- Change the preview width
                  border = 'rounded',
                  title_pos = 'center',
                },
              },
            }
          '';
      };
    };
    sources = {
      files = {
        hidden = true;
      };
      projects = {
        confirm = {
          __raw =
            # lua
            ''
              function(picker, item)
                picker:close()
                if item and item.file then
                  -- Check if the project is already open by checking the cwd of each tab
                  local tabpages = vim.api.nvim_list_tabpages()
                  for _, tabpage in ipairs(tabpages) do
                    local tab_cwd = vim.fn.getcwd(-1, tabpage)
                    if tab_cwd == item.file then
                      -- Change to the tab
                      vim.api.nvim_set_current_tabpage(tabpage)
                      return
                    end
                  end

                  -- If there are already opened buffers, open a new tab
                  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= "" then
                      vim.cmd("tabnew")
                      break
                    end
                  end
                end

                -- Change cwd to the selected project, only for this tab
                vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                Snacks.picker.smart()
              end
            '';
        };
      };
    };
  };

  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      [
        {
          mode = "n";
          key = "<leader>fd";
          action = ''<cmd>lua Snacks.picker.diagnostics_buffer()<cr>'';
          options = {
            desc = "Find buffer diagnostics";
          };
        }
        {
          mode = "n";
          key = "<leader>fD";
          action = ''<cmd>lua Snacks.picker.diagnostics()<cr>'';
          options = {
            desc = "Find workspace diagnostics";
          };
        }
        {
          mode = "n";
          key = "<leader>fh";
          action = ''<cmd>lua Snacks.picker.help()<cr>'';
          options = {
            desc = "Find help tags";
          };
        }
        # NOTE: prefer the UI but is lot slower
        {
          mode = "n";
          key = "<leader>fk";
          action = ''<cmd>lua Snacks.picker.keymaps()<cr>'';
          options = {
            desc = "Find keymaps";
          };
        }
        {
          mode = "n";
          key = "<leader>fp";
          action = ''<cmd>lua Snacks.picker.projects()<cr>'';
          options = {
            desc = "Find projects";
          };
        }
        {
          mode = "n";
          key = "<leader>fr";
          action = ''<cmd>lua Snacks.picker.registers()<cr>'';
          options = {
            desc = "Find registers";
          };
        }
        {
          mode = "n";
          key = "<leader>fs";
          action = ''<cmd>lua Snacks.picker.lsp_symbols()<cr>'';
          options = {
            desc = "Find lsp document symbols";
          };
        }
        {
          mode = "n";
          key = "<leader>fT";
          action = ''<cmd>lua Snacks.picker.colorschemes()<cr>'';
          options = {
            desc = "Find theme";
          };
        }
        {
          mode = "n";
          key = "<leader>fw";
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          options = {
            desc = "Live grep";
          };
        }
        {
          mode = "n";
          key = "<leader>fO";
          action = ''<cmd>lua Snacks.picker.smart()<cr>'';
          options = {
            desc = "Find Smart (Frecency)";
          };
        }
        {
          mode = "n";
          key = "<leader>f?";
          action = ''<cmd>lua Snacks.picker.grep_buffers()<cr>'';
          options = {
            desc = "Fuzzy find in open buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>f'";
          action = ''<cmd>lua Snacks.picker.marks()<cr>'';
          options = {
            desc = "Find marks";
          };
        }
        {
          mode = "n";
          key = "<leader>f/";
          action = ''<cmd>lua Snacks.picker.lines()<cr>'';
          options = {
            desc = "Fuzzy find in current buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>fr";
          action = ''<cmd>lua Snacks.picker.resume()<cr>'';
          options = {
            desc = "Resume find";
          };
        }
        {
          mode = "n";
          key = "<leader>fb";
          action = ''<cmd>lua Snacks.picker.buffers()<cr>'';
          options = {
            desc = "Find buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>ff";
          action = ''<cmd>lua Snacks.picker.files()<cr>'';
          options = {
            desc = "Find files";
          };
        }
        {
          mode = "n";
          key = "<leader><space>";
          action = ''<cmd>lua Snacks.picker.files()<cr>'';
          options = {
            desc = "Find files";
          };
        }
        {
          mode = "n";
          key = "<leader>fm";
          action = ''<cmd>lua Snacks.picker.man()<cr>'';
          options = {
            desc = "Find man pages";
          };
        }
        {
          mode = "n";
          key = "<leader>fo";
          action = ''<cmd>lua Snacks.picker.recent()<cr>'';
          options = {
            desc = "Find old files";
          };
        }
        {
          mode = "n";
          key = "<leader>fq";
          action = ''<cmd>lua Snacks.picker.qflist()<cr>'';
          options = {
            desc = "Find quickfix";
          };
        }
        {
          mode = "n";
          key = "<leader>ld";
          action = ''<cmd>lua Snacks.picker.lsp_definitions()<cr>'';
          options = {
            desc = "Goto Definition";
          };
        }
        {
          mode = "n";
          key = "<leader>li";
          action = ''<cmd>lua Snacks.picker.lsp_implementation()<cr>'';
          options = {
            desc = "Goto Implementation";
          };
        }
        {
          mode = "n";
          key = "<leader>lD";
          action = ''<cmd>lua Snacks.picker.lsp_references()<cr>'';
          options = {
            desc = "Find references";
          };
        }
        {
          mode = "n";
          key = "<leader>lt";
          action = ''<cmd>lua Snacks.picker.lsp_type_definitions()<cr>'';
          options = {
            desc = "Goto Type Definition";
          };
        }
        {
          mode = "n";
          key = "<leader>fS";
          action = ''<cmd>lua Snacks.picker.spell_suggest()<cr>'';
          options = {
            desc = "Find spelling suggestions";
          };
        }
        {
          mode = "n";
          key = "<leader>fH";
          action = ''<cmd>lua Snacks.picker.highlights()<cr>'';
          options = {
            desc = "Find highlights";
          };
        }
        {
          mode = "n";
          key = "<leader>gB";
          action = ''<cmd>lua Snacks.picker.git_branches()<cr>'';
          options = {
            desc = "Find git branches";
          };
        }
        {
          mode = "n";
          key = "<leader>gs";
          action = ''<cmd>lua Snacks.picker.git_status()<cr>'';
          options = {
            desc = "Find git status";
          };
        }
        {
          mode = "n";
          key = "<leader>gS";
          action = ''<cmd>lua Snacks.picker.git_stash()<cr>'';
          options = {
            desc = "Find git stashes";
          };
        }
      ];
}
