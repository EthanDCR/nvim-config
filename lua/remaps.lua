vim.g.mapleader = " " 
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)


-- Navigate buffers using `Shift + h` and `Shift + l`
vim.api.nvim_set_keymap("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

-- Alternatively, you can also use numbers to jump to a specific buffer
vim.api.nvim_set_keymap("n", "<Leader>1", ":BufferLineGoToBuffer 1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>2", ":BufferLineGoToBuffer 2<CR>", { noremap = true, silent = true })
-- ... Add more as needed







