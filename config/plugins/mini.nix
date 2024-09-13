{
  plugins.mini = {
    enable = true;

    modules = {
      comment.options.customCommentString = ''
        <cmd>lua require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring<cr>
      '';

      cursorword = { };

      indentscope = {
        symbol = "│";
        options = {
          try_as_border = true;
        };
      };
    };
  };
}
