return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- `main` needs the tree-sitter CLI and a different config API
  build = ":TSUpdate",
  -- This must not be lazy-loaded: `opts` (highlight/indent setup) only runs
  -- once the plugin is loaded. Lazy-loading it via `cmd` disables treesitter.
  lazy = false,
  config = function(_, opts)
    require("config.treesitter_compat").setup()
    require("nvim-treesitter.configs").setup(opts)
  end,
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
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby", "c", "cpp" } },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
