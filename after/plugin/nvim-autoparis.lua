-- Check if nvim-autopairs is installed and load it
local status_autopairs, nvim_autopairs = pcall(require, 'nvim-autopairs')
if not status_autopairs then
  vim.notify("nvim-autopairs not found! Please install it with Packer.")
  return
end

-- Basic setup for nvim-autopairs
nvim_autopairs.setup({})

-- If you're using nvim-cmp for autocompletion
local status_cmp, cmp = pcall(require, 'cmp')
if status_cmp then
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

