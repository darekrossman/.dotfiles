return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<C-space>"] = {}, -- freed for tmux prefix
      ["<C-\\>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = {
        -- 1. Accept copilot.lua suggestion if visible
        function()
          local ok, suggestion = pcall(require, "copilot.suggestion")
          if ok and suggestion.is_visible() then
            suggestion.accept()
            return true
          end
        end,
        -- 2. Jump forward in snippet
        "snippet_forward",
        -- 3. Normal tab
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "fallback",
      },
    },
  },
}
