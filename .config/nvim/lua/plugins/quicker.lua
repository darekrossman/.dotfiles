return {
  "stevearc/quicker.nvim",
  ft = "qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    -- Expand context around quickfix results (great for code review)
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
    -- Keep cursor constrained to actual content
    constrain_cursor = true,
    -- Enable editing quickfix buffer to rename/refactor
    edit = {
      enabled = true,
      autosave = "unmodified",
    },
  },
  keys = {
    -- Toggle quickfix with expanded/collapsed context
    {
      "<leader>xc",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix (quicker)",
    },
    -- Toggle loclist
    {
      "<leader>xL",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Toggle loclist (quicker)",
    },
    -- Toggle expanded context view
    {
      "<leader>xe",
      function()
        require("quicker").toggle_expand({ before = 2, after = 2 })
      end,
      desc = "Toggle quickfix expand",
    },
  },
}
