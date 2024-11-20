-- key remaps.
require("remaps")
-- packer plugins.
require("plugins")
require("options")

-- Gruvbox specific settings
vim.g.gruvbox_contrast_dark = 'hard'  -- Makes background darker
vim.g.gruvbox_transparent_bg = 1      -- Enable transparency support
vim.g.gruvbox_italic = 1              -- Enable italics
vim.g.gruvbox_bold = 1                -- Enable bold
vim.g.gruvbox_underline = 1           -- Enable underline

-- set colorscheme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- Enhanced transparency settings
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Additional highlight groups for better transparency
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

-- Optional: if you want to keep some UI elements visible
vim.api.nvim_set_hl(0, "LineNr", { fg = "#928374", bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bg = "none" })


-- Highlight yanked text for a brief moment
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

