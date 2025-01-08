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

 
-- Ensure jdtls is installed via Mason
require("mason-lspconfig").setup({
    ensure_installed = { "jdtls" },
})

-- Set up jdtls with Mason
local lspconfig = require("lspconfig")
local mason_registry = require("mason-registry")
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

lspconfig.jdtls.setup({
    cmd = { jdtls_path .. "/bin/jdtls" },
    root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew"),
    settings = {
        java = {
            format = {
                enabled = true,
                settings = {
                    profile = "GoogleStyle", -- Example formatter profile
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end,
})

-- LuaSnip setup
local luasnip = require("luasnip")

-- Add custom snippet for sysout
luasnip.add_snippets("java", {
    luasnip.snippet("sysout", {
        luasnip.text_node("System.out.println("),
        luasnip.insert_node(1, '"Your text here"'),
        luasnip.text_node(");"),
    }),
})

-- Configure LuaSnip keymaps
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







-- Add HTML snippets
luasnip.add_snippets('html', {
    -- HTML Boilerplate (trigger: "!")
    luasnip.snippet('!', {
        luasnip.text_node({
            '<!DOCTYPE html>',
            '<html lang="en">',
            '<head>',
            '  <meta charset="UTF-8">',
            '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
            '  <title>',
        }),
        luasnip.insert_node(1, 'Document'),
        luasnip.text_node({
            '</title>',
            '</head>',
            '<body>',
            '',
            '</body>',
            '</html>',
        }),
    }),

    -- h1 Tag (trigger: "h1")
    luasnip.snippet('h1', {
        luasnip.text_node('<h1>'),
        luasnip.insert_node(1, 'Heading 1'),
        luasnip.text_node('</h1>'),
    }),

    -- h2 Tag (trigger: "h2")
    luasnip.snippet('h2', {
        luasnip.text_node('<h2>'),
        luasnip.insert_node(1, 'Heading 2'),
        luasnip.text_node('</h2>'),
    }),

    -- h3 Tag (trigger: "h3")
    luasnip.snippet('h3', {
        luasnip.text_node('<h3>'),
        luasnip.insert_node(1, 'Heading 3'),
        luasnip.text_node('</h3>'),
    }),

    -- Image Tag (trigger: "img")
    luasnip.snippet('img', {
        luasnip.text_node('<img src="'),
        luasnip.insert_node(1, 'image.jpg'),
        luasnip.text_node('" alt="'),
        luasnip.insert_node(2, 'Description'),
        luasnip.text_node('">'),
    }),

    -- Link Tag (trigger: "a")
    luasnip.snippet('a', {
        luasnip.text_node('<a href="'),
        luasnip.insert_node(1, 'https://example.com'),
        luasnip.text_node('">'),
        luasnip.insert_node(2, 'Link Text'),
        luasnip.text_node('</a>'),
    }),

    -- Unordered List (trigger: "ul")
    luasnip.snippet('ul', {
        luasnip.text_node({
            '<ul>',
            '  <li>',
        }),
        luasnip.insert_node(1, 'Item 1'),
        luasnip.text_node('</li>'),
        luasnip.text_node({
            '  <li>',
        }),
        luasnip.insert_node(2, 'Item 2'),
        luasnip.text_node('</li>'),
        luasnip.text_node({
            '</ul>',
        }),
    }),

    -- Strong Tag (trigger: "strong")
    luasnip.snippet('strong', {
        luasnip.text_node('<strong>'),
        luasnip.insert_node(1, 'Bold Text'),
        luasnip.text_node('</strong>'),
    }),

    -- Div Tag (trigger: "div")
    luasnip.snippet('div', {
        luasnip.text_node('<div'),
        luasnip.insert_node(1, ' class="container"'),
        luasnip.text_node('>'),
        luasnip.insert_node(2, 'Content here'),
        luasnip.text_node('</div>'),
    }),
})




-- Add C++ snippets
luasnip.add_snippets('cpp', {
    -- std::cout (trigger: "cout")
    luasnip.snippet('cout', {
        luasnip.text_node('std::cout << '),
        luasnip.insert_node(1, 'expression'),
        luasnip.text_node(' << std::endl;'),
    }),

    -- For loop (trigger: "for")
    luasnip.snippet('for', {
        luasnip.text_node('for (int i = 0; i < '),
        luasnip.insert_node(1, 'n'),
        luasnip.text_node('; i++) {'),
        luasnip.text_node({'', '  '}),
        luasnip.insert_node(2, '/* code */'),
        luasnip.text_node({'', '}'}),
    }),

    -- Include statement (trigger: "include")
    luasnip.snippet('include', {
        luasnip.text_node('#include <'),
        luasnip.insert_node(1, 'library'),
        luasnip.text_node('>'),
    }),
})





-- Add C++ specific snippets
luasnip.add_snippets('cpp', {
    luasnip.snippet('cout', {
        luasnip.text_node('std::cout << '),  -- This part will be static
        luasnip.insert_node(1),              -- This is where you type your expression
        luasnip.text_node(' << std::endl;'), -- Static part for the newline
    }),

  luasnip.snippet('for', {
        luasnip.text_node('for (int i = 0; i < '),
        luasnip.insert_node(1),  -- This is where you type the condition for the loop
        luasnip.text_node('; i++) {}'),
        luasnip.insert_node(2),  -- This is where you type the body of the loop
    }),


    luasnip.snippet('include', {
        luasnip.text_node('#include <'),
        luasnip.insert_node(1),
        luasnip.text_node('>'),
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

