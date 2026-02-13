return {
  -- Disable LazyVim's default lazygit
  { "kdheepak/lazygit.nvim", enabled = false },

  -- Neogit with fzf-lua integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    opts = {
      -- Use fzf-lua for selection menus
      integrations = {
        fzf_lua = true,
        diffview = true,
      },
      -- Open in a new tab by default (can also use "split", "vsplit", "floating")
      kind = "floating",
      -- Disable hint at the top of the status buffer
      disable_hint = false,
      -- Remember popup settings between sessions
      remember_settings = true,
      -- Start in insert mode when opening commit message
      disable_insert_on_commit = false,
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (status)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Neogit pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit push" },
    },
  },
}
