return {
  --
  -- 	-- NOTE: Plugins can specify dependencies.
  -- 	--
  -- 	-- The dependencies are proper plugin specifications as well - anything
  -- 	-- you do for a plugin at the top level, you can do for a dependency.
  -- 	--
  -- 	-- Use the `dependencies` key to specify the dependencies of a particular plugin
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "j-hui/fidget.nvim", opts = {} },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.c = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
  {
    "williamboman/mason.nvim",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      -- The upstream registry still points kotlin-lsp at a dead CDN host.
      -- The local Lua registry overrides that one package; everything else
      -- still comes from the upstream registry.
      registries = {
        "lua:mason_registry_overrides",
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig.util")

      -- nvim-lspconfig v2: apply the cmp capabilities to every server.
      vim.lsp.config("*", {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities()
        ),
      })

      local servers = {
        bashls = {},
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
            "--header-insertion=iwyu",
          },
        },
        gopls = {},
        templ = {},
        pyright = {},
        sqlls = {},
        gradle_ls = {},
        kotlin_lsp = {
          root_markers = {
            "gradlew",
            ".git",
            "mvnw",
            "settings.gradle",
            "settings.gradle.kts",
            "build.gradle",
            "build.gradle.kts",
          },
        },
        jdtls = {},
        html = {
          filetypes = { "html", "astro" },
        },
        cssls = {},
        tailwindcss = {},
        svelte = {},
        astro = {},
        jsonls = {},
        yamlls = {},
        dockerls = {},
        docker_compose_language_service = {},
        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = 'import (builtins.getFlake "/home/juevigrace/Projects/nixos").inputs.nixpkgs { }',
              },
              formatting = {
                command = { "alejandra" },
              },
              options = {
                nixos = {
                  expr = string.format(
                    '(builtins.getFlake "/home/juevigrace/Projects/nixos").nixosConfigurations.%s.options',
                    vim.fn.hostname()
                  ),
                },
              },
            },
          },
        },
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        ts_ls = {
          filetypes = {
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact",
            "vue", -- if you use Vue with TS
            "astro", -- if you use Astro with TS (requires astro-language-server)
          },
          root_dir = lspconfig.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
        },
        hyprls = {},
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      -- nixd is installed by Nix, so don't ask Mason to install it.
      local ensure_installed = {}
      for name in pairs(servers) do
        if name ~= "nixd" then
          table.insert(ensure_installed, name)
        end
      end
      vim.list_extend(ensure_installed, {
        -- Formatters
        "stylua", -- Used to format Lua code
        "black",
        "prettier",
        "prettierd",
        "google-java-format",
        "goimports",
        "clang-format",
        "sqlfmt",
        "yamlfmt",
        "alejandra",
        "shfmt",

        -- DAPs
        "codelldb",
        -- "bash-debug-adapter",
        -- "kotlin-debug-adapter",
        -- "debugpy",
        -- "js-debug-adapter",
        -- "delve",
        -- "dart-debug-adapter",

        -- Linters
        "shellcheck",
        "gospel",
        "pylint",
        "eslint_d",
        "yamllint",
        "jsonlint",
        "htmlhint",
        "stylelint",
        "hadolint",
        "checkmake",

        -- Formatters/Linters
        "ktlint",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- nvim-lspconfig v2: apply the per-server overrides above and enable
      -- each one. mason-lspconfig's automatic_enable covers anything Mason
      -- installs; nixd comes from Nix and is enabled by this loop.
      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

      require("mason-lspconfig").setup({})
    end,
  },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "j-hui/fidget.nvim",
      -- Useful status updates for LSP.

      -- Allows extra capabilities provided by nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
    end,
  },
}
