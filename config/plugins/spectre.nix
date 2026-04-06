{
  plugins.spectre = {
    enable = true;
    settings = {
      find_engine = {
        rg = {
          cmd = "rg";
          args = [
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--pcre2"
          ];
          options = {
            "ignore-case" = {
              value = "--ignore-case";
              icon = "[I]";
              desc = "ignore case";
            };
            "hidden" = {
              value = "--hidden";
              desc = "hidden file";
              icon = "[H]";
            };
          };
        };
      };

      default = {
        replace = {
          cmd = "oxi";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>S";
      action = "<cmd>lua require(\"spectre\").toggle()<cr>";
      options = {
        desc = "Toggle Spectre";
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sw";
      action = "<cmd>lua require(\"spectre\").open_visual({ select_word = true })<cr>";
      options = {
        desc = "Search current word";
        nowait = true;
      };
    }
    {
      mode = "v";
      key = "<leader>sw";
      action = "<cmd>lua require(\"spectre\").open_visual()<cr>";
      options = {
        desc = "Search current word";
        nowait = true;
      };
    }
    {
      mode = "v";
      key = "<leader>sp";
      action = "<cmd>lua require(\"spectre\").open_file_search({ select_word = true })<cr>";
      options = {
        desc = "Search current file";
        nowait = true;
      };
    }
  ];
}
