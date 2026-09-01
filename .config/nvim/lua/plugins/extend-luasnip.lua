return {
  "L3MON4D3/LuaSnip",
  opts = {
    enable_autosnippets = true,
    update_events = "TextChanged,TextChangedI",
  },
  config = function(_, opts)
    require("luasnip").config.setup(opts)
    require("luasnip.loaders.from_lua").load({
      paths = vim.fn.stdpath("config") .. "/lua/snippets",
    })
  end,
}
