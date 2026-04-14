return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "moon", -- auto, main, moon, or dawn
        dark_variant = "moon", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },

        before_highlight = function(group, highlight, palette)
          if highlight.italic then
            highlight.italic = false
          end
          if highlight.bold then
            highlight.bold = false
          end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      })

      -- vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine-dawn")
      pcall(vim.cmd.colorscheme, "rose-pine-moon")

      -- Force redraw to update all UI elements
      vim.cmd("redraw!")

      local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

      -- Reload transparency settings
      if vim.fn.filereadable(transparency_file) == 1 then
        vim.defer_fn(function()
          vim.cmd.source(transparency_file)

          -- Trigger UI updates for various plugins
          vim.cmd("doautocmd ColorScheme")
          vim.cmd("doautocmd VimEnter")

          -- Final redraw
          vim.cmd("redraw!")
        end, 5)
      end
    end,
  },
}
