return {
  "saghen/blink.cmp",
  version = "1.*", -- ビルド済みバイナリを使う
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" }, -- useful snippets
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  opts = {
    snippets = { preset = "luasnip" },
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" }, -- previous suggestion
      ["<C-j>"] = { "select_next", "fallback" }, -- next suggestion
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" }, -- show completion suggestions
      ["<C-e>"] = { "hide", "fallback" }, -- close completion window
      ["<CR>"] = { "accept", "fallback" }, -- 選択中の候補がある時だけ確定
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    completion = {
      -- noselect と同じ: 最初の候補を自動で選ばず、選んだ候補は挿入する
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = { max_height = 15 },
    },
    sources = {
      default = { "lazydev", "lsp", "snippets", "buffer", "path" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    -- nvim-cmp の時と同じく : / の補完は使わない
    cmdline = { enabled = false },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
