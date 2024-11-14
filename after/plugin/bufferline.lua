-- Load bufferline plugin
require("bufferline").setup {
  options = {
    -- Set options to customize behavior and appearance
    numbers = "none",             -- Display no numbers (you can also use "ordinal" or "buffer_id")
    close_command = "bdelete! %d", -- Close command for buffers
    right_mouse_command = "bdelete! %d", -- Right-click close buffer
    left_mouse_command = "buffer %d",    -- Left-click to navigate to buffer
    middle_mouse_command = nil,          -- Disable middle-click

    -- Additional options
    diagnostics = "nvim_lsp",        -- Show LSP diagnostics in the bufferline
    separator_style = "thin",       -- Style of buffer separators ("slant", "thick", "thin", etc.)
    show_buffer_close_icons = true,  -- Show close icons on buffers
    show_close_icon = false,         -- Show close icon on the bufferline
    show_tab_indicators = true,      -- Show tab indicators


    -- Configure buffer offsets (useful if you have a file tree)
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "center"
      }
    },
  }
}

