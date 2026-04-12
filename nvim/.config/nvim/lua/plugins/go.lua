return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not opts.servers then
        opts.servers = {}
      end
      opts.servers.gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
            gofumpt = true,
          },
        },
      }
      return opts
    end,
  },
}
