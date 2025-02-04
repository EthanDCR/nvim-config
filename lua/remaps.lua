vim.g.mapleader = " "

-- Keymap to open the file explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Navigate buffers using `Shift + h` and `Shift + l`
vim.api.nvim_set_keymap("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

-- Open terminal in the current directory of the active file
vim.api.nvim_set_keymap('n', '<leader>t', ':lua OpenTerminalInCurrentDir()<CR>', { noremap = true, silent = true })

-- Lua function to open terminal in the current file's directory
function OpenTerminalInCurrentDir()
  local dir = vim.fn.expand('%:p:h')
  if dir ~= "" then
    vim.cmd('lcd ' .. dir) -- Change to the current file's directory
  end
  vim.cmd('terminal') -- Open the terminal
  vim.cmd('startinsert') -- Enter insert mode in the terminal
end

-- Use Esc to enter Normal mode in the terminal
vim.cmd [[
  augroup TerminalMode
    autocmd!
    autocmd TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
  augroup END
]]

