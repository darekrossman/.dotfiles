-- Run biome lint --write after save to apply lint fixes (including Tailwind sorting)
return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
        callback = function(args)
          local file = args.file
          -- Run biome lint --write on the saved file
          vim.fn.jobstart({ "npx", "biome", "lint", "--write", file }, {
            on_exit = function(_, code)
              if code == 0 then
                -- Reload the buffer to show the changes
                vim.schedule(function()
                  vim.cmd("checktime")
                end)
              end
            end,
          })
        end,
        desc = "Run biome lint --write after save",
      })
    end,
  },
}
