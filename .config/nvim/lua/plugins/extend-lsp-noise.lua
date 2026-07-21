return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          flags = {
            debounce_text_changes = 750,
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}

      vim.list_extend(opts.routes, {
        {
          filter = {
            event = "lsp",
            kind = "progress",
          },
          opts = { skip = true },
        },
        {
          filter = {
            any = {
              { event = "notify", find = "go%.mod:%d+: usage: replace module/path" },
              { event = "notify", find = "go%.mod:%d+: unknown directive: r" },
              { event = "lsp", kind = "message", find = "go%.mod:%d+: usage: replace module/path" },
              { event = "lsp", kind = "message", find = "go%.mod:%d+: unknown directive: r" },
            },
          },
          opts = { skip = true },
        },
      })
    end,
  },
}
