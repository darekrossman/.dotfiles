return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = function(_, opts)
    -- Clean flat look: remove all separators (triangles)
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    })

    -- Remove duplicate AI icons by checking actual rendered output
    local seen_icons = {}
    local ai_icons = { "", "", "󰚩", "󱙺", "" } -- common AI plugin icons
    opts.sections.lualine_x = vim.tbl_filter(function(component)
      if type(component) == "table" and type(component[1]) == "function" then
        -- Try to get the icon this component renders
        local ok, icon = pcall(component[1])
        if ok and type(icon) == "string" then
          -- Check if it's an AI-related icon
          local base_icon = icon:gsub("%s*%d*$", ""):gsub("%s+", "") -- strip trailing numbers/spaces
          for _, ai_icon in ipairs(ai_icons) do
            if base_icon:find(ai_icon, 1, true) then
              if seen_icons[ai_icon] then
                return false -- duplicate, filter it out
              end
              seen_icons[ai_icon] = true
              break
            end
          end
        end
      end
      return true
    end, opts.sections.lualine_x or {})
  end,
}
