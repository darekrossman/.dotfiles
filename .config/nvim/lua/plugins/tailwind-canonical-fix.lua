-- Fix Tailwind canonical class warnings using LSP code actions
return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Helper to apply code actions for a specific diagnostic
      local function apply_code_action_for_diagnostic(bufnr, diagnostic, client)
        local params = {
          textDocument = vim.lsp.util.make_text_document_params(bufnr),
          range = {
            start = { line = diagnostic.lnum, character = diagnostic.col },
            ["end"] = { line = diagnostic.end_lnum, character = diagnostic.end_col },
          },
          context = {
            diagnostics = {
              {
                range = {
                  start = { line = diagnostic.lnum, character = diagnostic.col },
                  ["end"] = { line = diagnostic.end_lnum, character = diagnostic.end_col },
                },
                message = diagnostic.message,
                severity = diagnostic.severity,
                code = diagnostic.code,
                source = diagnostic.source,
              },
            },
            only = { "quickfix" },
          },
        }

        -- Request code actions
        client.request("textDocument/codeAction", params, function(err, result)
          if err or not result or #result == 0 then
            return
          end

          -- Apply the first quickfix action
          for _, action in ipairs(result) do
            if action.kind == "quickfix" and action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
              return
            end
          end
        end, bufnr)
      end

      -- Main function to fix all canonical class warnings
      local function fix_tailwind_canonical_classes()
        local bufnr = vim.api.nvim_get_current_buf()

        -- Find Tailwind LSP client
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "tailwindcss" })
        if #clients == 0 then
          return
        end

        local client = clients[1]

        -- Get all diagnostics
        local diagnostics = vim.diagnostic.get(bufnr)

        -- Filter for canonical class suggestions
        -- Note: source is nil, not "tailwindcss"
        local canonical_warnings = {}
        for _, diag in ipairs(diagnostics) do
          if diag.code == "suggestCanonicalClasses" then
            table.insert(canonical_warnings, diag)
          end
        end

        if #canonical_warnings == 0 then
          return
        end

        -- Sort from bottom to top to avoid position shifts
        table.sort(canonical_warnings, function(a, b)
          return a.lnum > b.lnum or (a.lnum == b.lnum and a.col > b.col)
        end)

        -- Apply fixes with delay to allow LSP to process
        local delay = 0
        for _, diag in ipairs(canonical_warnings) do
          vim.defer_fn(function()
            apply_code_action_for_diagnostic(bufnr, diag, client)
          end, delay)
          delay = delay + 50 -- 50ms between each fix
        end

        -- Sort classes after all fixes are applied
        vim.defer_fn(function()
          vim.lsp.buf.code_action({
            context = { only = { "source.sortTailwindClasses" }, diagnostics = {} },
            apply = true,
          })
        end, delay + 100)
      end

      -- Auto-fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
        callback = function()
          fix_tailwind_canonical_classes()
          -- Small delay to let fixes apply before save
          vim.wait(200)
        end,
        desc = "Fix Tailwind canonical classes on save",
      })

      -- Manual command for testing
      vim.api.nvim_create_user_command("TailwindFix", function()
        fix_tailwind_canonical_classes()
      end, { desc = "Fix Tailwind canonical classes" })
    end,
  },
}
