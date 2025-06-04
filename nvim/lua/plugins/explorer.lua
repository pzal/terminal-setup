return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          diagnostics = false,
          hidden = true,
          ignored = true,
          exclude = { ".git", "**/.DS_Store" },
        },
      },
    },
  },
}
