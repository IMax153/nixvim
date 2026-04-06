{
  autoCmd = [
    # Miscellaneous
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback = {
        __raw =
          # lua
          ''
            function()
              vim.highlight.on_yank()
            end
          '';
      };
    }
    {
      desc = "Automatically close quickfix window on selection";
      event = [ "FileType" ];
      pattern = [ "qf" ];
      command = "nnoremap <buffer> <CR> <CR>:cclose<CR>";
    }
    {
      desc = "Improve Spectre diff contrast";
      event = [
        "VimEnter"
        "ColorScheme"
      ];
      callback = {
        __raw =
          # lua
          ''
            function()
              vim.api.nvim_set_hl(0, "SpectreSearch", {
                fg = "#24273a",
                bg = "#8aadf4",
                bold = true,
              })

              vim.api.nvim_set_hl(0, "SpectreReplace", {
                fg = "#24273a",
                bg = "#ed8796",
                bold = true,
              })

              vim.api.nvim_set_hl(0, "SpectreBorder", {
                fg = "#7dc4e4",
                bold = true,
              })

              vim.api.nvim_set_hl(0, "SpectreFile", {
                fg = "#f5a97f",
                bold = true,
              })

              vim.api.nvim_set_hl(0, "SpectreDir", {
                fg = "#a6da95",
              })

              vim.api.nvim_set_hl(0, "SpectreLine", {
                fg = "#c6a0f6",
                bold = true,
              })
            end
          '';
      };
    }
  ];
}
