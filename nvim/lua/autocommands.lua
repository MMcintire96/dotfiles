vim.cmd[[ autocmd BufWritePre *. :%s/\s\+$//e ]]
vim.cmd[[ autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
vim.cmd[[ au ColorScheme * hi Normal ctermbg=none guibg=none ]]
vim.cmd[[ au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red ]]
