return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        -- Follows the active colorscheme
        theme = "auto",
      },
      sections = {
        -- Default lualine_x is { "encoding", "fileformat", "filetype" };
        -- lsp_status and time are the only extras not in the default layout.
        lualine_x = { "lsp_status", "encoding", "fileformat", "filetype", "time" },
      },
    })
  end,
}
