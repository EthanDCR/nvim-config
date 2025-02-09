-- ... (imports, mason setup, capabilities - same as before)

local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, bufopts)

    -- C Diagnostic Suppression (Only for .c files)
    if vim.bo.filetype == "c" then
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end
        buf_set_option('diagnostic.severity_sort', { 'error', 'warning' }) -- Corrected typo here!
        buf_set_option('diagnostic.disable', {
           'clang-diagnostic-trailing-whitespace',
           'clang-diagnostic-missing-space',
           'clang-diagnostic-extra-semi',
           'clang-diagnostic-unused-variable',
           -- ... (All other C diagnostic disables) ...
        })
    end
end

-- ... (clangd setup, other LSP setups, rest of config - same as before)
