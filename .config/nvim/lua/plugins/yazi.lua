return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi (current file)" },
      { "<leader>fY", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
      { "<leader>y", "<cmd>Yazi toggle<cr>", desc = "Yazi (resume)" },
    },
    opts = {
      -- Open yazi instead of netrw for directories
      open_for_directories = false,
      -- Floating window settings
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_border = "rounded",
    },
  },
}
