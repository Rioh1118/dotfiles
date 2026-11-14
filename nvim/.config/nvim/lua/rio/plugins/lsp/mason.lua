return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- rust_analyzer は rustaceanvim が起動し、stylua は conform で使うので LSP としては起動しない
      automatic_enable = {
        exclude = { "rust_analyzer", "stylua" },
      },
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "ruff",
        "eslint",
        "rust_analyzer",
        "ruby_lsp",
        "rubocop",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "goimports",
        "gofumpt",
        "rubocop",
        "erb-formatter",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
