
local opts = {noremap=true, silent=true}
vim.api.nvim_set_keymap("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "<ESC>", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
vim.api.nvim_set_keymap("n", "<q>", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})


