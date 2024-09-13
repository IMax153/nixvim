{
  config = {
    # Enable manpages
    enableMan = true;

    # Alias `vi` and `vim` to `nvim`
    viAlias = true;
    vimAlias = true;

    diagnostics = {
      virtual_text = false;
      signs = true;
      underline = true;
      update_in_insert = true;
      severity_sort = true;
      float = {
        border = "rounded";
        source = "always";
        focusable = false;
      };
    };

    filetype = {
      extension = {
        mdx = "mdx";
      };
    };

    globals = {
      # Set the leader key to space
      mapleader = " ";
      maplocalleader = " ";

      floating_window_options = {
        border = "rounded";
        winblend = 10;
      };
    };

    globalOpts = {
      statusline = "%#Normal#";
    };

    opts = {
      # Enable relative line numbers
      number = true;
      relativenumber = true;
      numberwidth = 2;

      # Disable showing the mode below the statusline
      showmode = false;

      # Set tabs to 2 spaces
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;

      # Enable auto-indenting and set it to spaces
      smartindent = true;
      shiftwidth = 2;

      # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
      breakindent = true;

      # Disable text wrap
      wrap = false;

      # Enable incremental searching
      incsearch = true;
      hlsearch = true;

      # Better pane splitting
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";

      # Setup a ruler
      colorcolumn = "80";

      # Enable mouse mode
      mouse = "a";

      # Enable ignorecase + smartcase for better searching
      ignorecase = true;
      smartcase = true;

      # Decrease interval for writing swap file to disk, also used by `gitsigns`
      updatetime = 250;

      # Set completeopt to have a better completion experience
      completeopt = ["menu" "menuone" "noselect"];

      # Enable persistent undo history
      undofile = true;

      # Enable 24-bit colors
      termguicolors = true;

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Enable access to System Clipboard
      clipboard = "unnamedplus";

      # Enable cursor line highlight
      cursorline = true;

      # Keep 10 lines above/below cursor unless at start/end of file
      scrolloff = 10;

      # Time in milliseconds to wait for a mapped sequence to complete
      timeoutlen = 400;
    };
  };
}
