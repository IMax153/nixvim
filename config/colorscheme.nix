{
  colorschemes = {
    catppuccin = {
      enable = true;
      integrations = {
        cmp = true;
        gitsigns = true;
        indent_blankline = {
          enabled = false;
          scope_color = "sapphire";
          colored_indent_levels = false;
        };
        native_lsp = {
          enabled = true;
        };
        symbols_outline = true;
        telescope = true;
        treesitter = true;
        treesitter_context = true;
      };
    };
  };
}
