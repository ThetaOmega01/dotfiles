return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jedi_language_server = {},
      ruff = {
        init_options = {
          settings = {
            lint = {
              enable = false,
            },
          },
        },
      },
    },
    setup = {
      pyright = function()
        require("lazyvim.util").lsp.on_attach(function(client, _)
          if client.name == "pyright" then
            -- disable hover in favor of jedi-language-server
            client.server_capabilities.hoverProvider = false
          end
        end)
      end,
    },
  },
}
