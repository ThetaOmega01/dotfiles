return {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_syntax_conceal_disable = 1
    vim.g.vimtex_compiler_tectonic = {
      options = { "--keep-logs", "--synctex" },
    }
  end,
}
