return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          -- Show hidden files (dotfiles) by default
          hidden = true,
          -- Show gitignored files by default
          ignored = true,
        },
      },
    },
  },
}
