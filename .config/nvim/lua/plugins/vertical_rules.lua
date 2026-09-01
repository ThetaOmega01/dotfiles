return {
  "m4xshen/smartcolumn.nvim",
  opts = {
    -- Custom colorcolumn per filetype
    custom_colorcolumn = {
      python = "120",
      rust = "100",
      lua = "120",
    },
    disabled_filetypes = {
      "help",
      "text",
      "markdown",
      "snacks_dashboard",
      "lazy",
      "mason",
      "checkhealth",
      "lspinfo",
      "noice",
      "trouble",
      "typst",
      "go",
    },
  },
}
