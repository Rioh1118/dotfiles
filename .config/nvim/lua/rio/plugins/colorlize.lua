return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      css = {
        mode = "foreground",
        css = true, -- CSS用パーサーを有効化
        names = false,
        rgb_fn = true,
        hsl_fn = true,
      },
      scss = {
        mode = "foreground",
        css = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        exclude = { -- SCSS変数を除外
          "scssVariable",
          "scssVariableAssignment",
          "scssFunction",
        },
      },
      sass = {
        mode = "foreground",
        css = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        exclude = { -- Sass変数を除外
          "sassVariable",
          "sassFunction",
          "sassVariableAssignment",
        },
      },
      html = {
        mode = "foreground",
        names = false,
        css = true,
      },
      javascript = {
        mode = "foreground",
        names = false,
        css = true,
      },
      ["*"] = { -- 全ファイルタイプ向けデフォルト設定
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css_fn = true,
        always_update = true,
      },
    })
  end,
}
