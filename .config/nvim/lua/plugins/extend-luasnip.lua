return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip").config.set_config({
        enable_autosnippets = true, -- Enable autosnippets
        update_events = "TextChanged,TextChangedI", -- Update snippets on text changes
      })
    require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets/"})
  end,
}
