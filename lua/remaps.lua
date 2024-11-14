vim.g.mapleader = " " 
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)


-- Navigate buffers using `Shift + h` and `Shift + l`
vim.api.nvim_set_keymap("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

 






