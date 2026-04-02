return {
  "lervag/vimtex",
  lazy = false,
  --tag = "v2.15",
  init = function()
    --VimTex configuration goes here, e.g.
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "out",
      options = {
        "-pdf",
        "-xelatex",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1
    vim.g.vimtex_complete_enabled = 1
    vim.g.vimtex_syntax_enabled = 1
    vim.g.vimtex_autoclose_delims = 1
  end,
}
