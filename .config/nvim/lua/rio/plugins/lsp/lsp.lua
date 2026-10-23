return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    -- used to enable autocompletion (assign to every lsp server config)
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- mason 以外で入れている LSP（ocamllsp は opam switch のものを使う）
    for _, server in ipairs({ "ocamllsp" }) do
      local cmd = vim.lsp.config[server] and vim.lsp.config[server].cmd
      if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
        vim.lsp.enable(server)
      end
    end
  end,
}
