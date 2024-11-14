



-- key remaps.
require("remaps")


-- packer plugins.
require("plugins")

require("options")


-- set colorscheme.
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
-- set transparent background.
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })




