local foreground = { display = { mode = "foreground" } }

return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- 全ファイルタイプ向けデフォルト設定
    options = {
      parsers = {
        names = { enable = false },
        hex = { rrggbbaa = true },
        rgb = { enable = true },
        hsl = { enable = true },
      },
      always_update = true,
    },
    filetypes = {
      "*",
      css = vim.tbl_deep_extend("force", foreground, { parsers = { css = true, names = { enable = false } } }),
      scss = vim.tbl_deep_extend("force", foreground, { parsers = { css = true, names = { enable = false } } }),
      sass = vim.tbl_deep_extend("force", foreground, { parsers = { css = true, names = { enable = false } } }),
      html = vim.tbl_deep_extend("force", foreground, { parsers = { css = true, names = { enable = false } } }),
      javascript = vim.tbl_deep_extend("force", foreground, { parsers = { css = true, names = { enable = false } } }),
    },
  },
}
