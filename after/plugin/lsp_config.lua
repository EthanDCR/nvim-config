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

-- Java setup (for jdtls)
lspconfig.jdtls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.mockito.Mockito.*"
                },
            },
        },
    },
})

-- Setup clangd for C++
lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 
        "clangd", 
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

-- Add Java-specific snippets
luasnip.add_snippets('java', {
    luasnip.snippet('sysout', {
        luasnip.text_node('System.out.println('),
        luasnip.insert_node(1),
        luasnip.text_node(');'),
    }),
})

-- Null-ls setup for code formatting and linting
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.cpplint,   -- Linter for C++
        null_ls.builtins.formatting.clang_format, -- Formatter for C++
        -- Add more sources here as needed, such as `prettier` for JS, `black` for Python, etc.
    },
    on_attach = on_attach,
})

-- Diagnostic signs (icons)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

