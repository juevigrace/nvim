return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- Lock to master for Neovim 0.11/0.13 compatibility
  build = ":TSUpdate",
  cmd = { "TSUpdate", "TSInstall" },
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "rust",
      "diff",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      "regex",
      "toml",
      "yaml",
      "xml",
      "dockerfile",
      "gitignore",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "jsdoc",
      "astro",
      "svelte",
      "json5",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "templ",
      "java",
      "kotlin",
      "make",
      "sql",
      "dart",
      "hyprlang",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby", "markdown" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
