-- Catppuccin colorscheme with automatic dark/light switching
return {
  -- Add catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    opts = {
      flavour = "mocha", -- Default flavour (will be overridden by auto-detection)
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = true,
        native_lsp = {
          enabled = true,
        },
      },
    },
  },

  -- dark-notify: Auto-sync theme with macOS system appearance
  {
    "cormacrelf/dark-notify",
    enabled = vim.fn.has("macunix") == 1,
    config = function()
      require("dark_notify").run({
        onchange = function(mode)
          local flavour = mode == "dark" and "mocha" or "latte"
          vim.cmd.colorscheme("catppuccin-" .. flavour)
        end,
      })
    end,
  },

  -- Configure LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
