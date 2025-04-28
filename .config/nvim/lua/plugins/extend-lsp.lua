return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Server-specific configurations
      servers = {
        -- Configure Pyright
        pyright = {
          settings = {
            pyright = {
              disableTaggedHints = true,
              disableOrganizeImports = true, -- Let Ruff handle this via <leader>co
            },
            python = {
              analysis = {
                typeCheckingMode = "basic", -- or "strict"
                diagnosticSeverityOverrides = {
                  -- Rules Ruff handles well are set to "none" in Pyright
                  reportUnusedImport = "none", -- Ruff: F401
                  reportUnusedVariable = "none", -- Ruff: F841
                  reportUnusedFunction = "none", -- Ruff handles this
                  reportUndefinedVariable = "none", -- Ruff: F821
                  reportGeneralTypeIssues = "warning", -- Keep Pyright's type checking diagnostics
                },
              },
            },
          },
        },
      },

      -- Setup function to fine-tune capabilities after attach
      setup = {
        ruff_lsp = function(client)
          -- Disable Ruff's hover provider to prefer Pyright's richer type info
          client.server_capabilities.hoverProvider = false
        end,
      },
    },
  },
}
