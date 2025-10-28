
local opts = {noremap=true, silent=true}
vim.api.nvim_set_keymap("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "<ESC>", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
--vim.api.nvim_set_keymap("n", "<q>", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})


vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
