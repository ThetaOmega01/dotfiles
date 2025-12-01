return {
  "m4xshen/smartcolumn.nvim",
  opts = {
    -- Custom colorcolumn per filetype
    custom_colorcolumn = {
      python = "120",
      cpp = "80",
      c = "80",
      rust = "100",
      javascript = "80",
      typescript = "80",
      lua = "120",
    },
    disabled_filetypes = {
      "help",
      "text",
      "markdown",
      "alpha",
      "snacks_dashboard",
      "lazy",
      "mason",
      "checkhealth",
      "lspinfo",
      "noice",
      "Trouble",
      "typst",
      "go",
    },
    -- Only check the current file for line length
    scope = "file",
  },
}
