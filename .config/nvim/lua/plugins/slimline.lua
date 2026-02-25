return {
  "sschleemilch/slimline.nvim",
  opts = {
    style = "fg",
    bold = true,
    configs = {
      path = {
        hl = {
          primary = "Label",
        },
      },
      git = {
        hl = {
          primary = "Function",
        },
      },
      filetype_lsp = {
        hl = {
          primary = "String",
        },
      },
      mode = {
        format = {
          ["n"] = { short = "NOR" },
          ["v"] = { short = "VIS" },
          ["V"] = { short = "V-L" },
          ["\22"] = { short = "V-B" },
          ["s"] = { short = "SEL" },
          ["S"] = { short = "S-L" },
          ["\19"] = { short = "S-B" },
          ["i"] = { short = "INS" },
          ["R"] = { short = "REP" },
          ["c"] = { short = "CMD" },
          ["r"] = { short = "PRO" },
          ["!"] = { short = "SHE" },
          ["t"] = { short = "TER" },
          ["U"] = { short = "UNK" },
        },
      },
    },
  },
}
