-- Import required modules
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp = require('cmp')
local luasnip = require('luasnip')
local null_ls = require("null-ls")

-- Setup Mason and LSP configurations
mason.setup()
mason_lspconfig.setup({
    ensure_installed = { "clangd", "pyright", "cssls", "gopls", "lua_ls", "jdtls" },
})

-- Capabilities for nvim-cmp integration
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enhanced on_attach function for LSP
local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, bufopts)
end

-- Setup clangd for C++
lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 
        "clangd", 
        "--background-index",  -- Enable background indexing for better performance
        "--all-scopes-completion",  -- Allow completion in all scopes
        "--completion-style=detailed",  -- Enhance completion details
        "--clang-tidy",  -- Enable clang-tidy diagnostics
        "--query-driver=/usr/bin/g++", 
        "-I/usr/include/c++/11", 
        "-I/usr/include/x86_64-linux-gnu", 
        "-I/usr/include" 
    },
    single_file_support = true,  -- Enable support for standalone files
})

-- Setup nvim-cmp with luasnip for autocompletion
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- Null-ls setup for code formatting and linting
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.cpplint,   -- Linter for C++
        null_ls.builtins.formatting.clang_format, -- Formatter for C++
    },
    on_attach = on_attach,
})

-- Configure LuaSnip keymaps for snippet expansion and jumping
vim.keymap.set("i", "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { noremap = true, silent = true })

vim.keymap.set("s", "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { noremap = true, silent = true })

vim.keymap.set("s", "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { noremap = true, silent = true })

-- Add custom C++ snippets
luasnip.add_snippets('cpp', {
    luasnip.snippet('cout', {
        luasnip.text_node('std::cout << '),
        luasnip.insert_node(1, 'expression'),
        luasnip.text_node(' << std::endl;'),
    }),

    luasnip.snippet('for', {
        luasnip.text_node('for (int i = 0; i < '),
        luasnip.insert_node(1, 'n'),
        luasnip.text_node('; i++) {'),
        luasnip.text_node({'', '  '}),
        luasnip.insert_node(2, '/* code */'),
        luasnip.text_node({'', '}'}),
    }),

    luasnip.snippet('include', {
        luasnip.text_node('#include <'),
        luasnip.insert_node(1, 'library'),
        luasnip.text_node('>'),
    }),
})

-- Configure diagnostic signs (icons)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure how diagnostics are shown
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true, -- Show error messages inline
    signs = true,        -- Show signs in the gutter
    underline = true,    -- Underline errors
})

