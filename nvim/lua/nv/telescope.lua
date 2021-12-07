local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<C-a>"] = actions.select_vertical
      },
      n = {
        ["<C-a>"] = actions.select_vertical
      }
    },
  }
}
