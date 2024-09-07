-- init.lua (Neovim configuration)

-- Set leader key to space
vim.g.mapleader = " "

-- Install lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "mg979/vim-visual-multi",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "nvim-lualine/lualine.nvim",
    "gruvbox-community/gruvbox",
    "tpope/vim-commentary",
    "windwp/nvim-autopairs",
    "navarasu/onedark.nvim",
    "nvim-tree/nvim-tree.lua", -- Add nvim-tree plugin
    "nvim-tree/nvim-web-devicons",
    "karb94/neoscroll.nvim",
    -- Add Mason and Mason-LSPconfig
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- Adding AutoImport
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind-nvim",
    "akinsho/toggleterm.nvim",
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "neoclide/coc.nvim",
    {
        'windwp/nvim-ts-autotag',
        after = 'nvim-treesitter',
        config = function()
            require('nvim-ts-autotag').setup()
        end,
    },
    -- Formatter
    "jose-elias-alvarez/null-ls.nvim"
})

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Smooth Scrolling
-- neoscroll.nvim configuration
require('neoscroll').setup({
    easing_function = "quadratic", -- You can try different easing functions
    hide_cursor = false,           -- Hide the cursor while scrolling
})
require 'nvim-treesitter.configs'.setup {
    auto_install=true,
   ensure_installed = { "c", "lua", "python", "javascript", "html", "css", "go", "svelte","htmldjango","tsx" },
    highlight = {
        enable = true,
    },
}
-- Auto Rename Tag
require('nvim-ts-autotag').setup()


-- Theme
require('onedark').setup {
    style = 'deep', -- options: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
}
require('onedark').load()
-- Statusline
require('lualine').setup()
-- Telescope (Fuzzy Finder)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Setup Mason
require("mason").setup()
-- Formatter
local null_ls = require("null-ls")

-- Configure null-ls with Prettier
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier, -- Use Prettier for formatting
    },
})

-- Ensure the servers are installed
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",
        "clangd",
        "tsserver",
        "svelte",
        "html",
        "cssls",
        "lua_ls",
        "pyright",
    },
    automatic_installation = true,
})

-- Multi Cursor Setup

vim.g.VM_maps = {
    ['Find Under'] = '<C-A-Down>',      -- Start multicursor selection
    ['Find Subword Under'] = '<C-A-n>', -- Start multicursor selection for subwords
    ['Select All'] = '<C-F2>',          -- Select all occurrences
    ['Skip Region'] = '<A>',            -- Skip the current selection
}

-- LSP Configuration
local lspconfig = require('lspconfig')

-- Language servers setup
lspconfig.gopls.setup {}
lspconfig.clangd.setup {}
lspconfig.tsserver.setup {
    on_attach = function(client)
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
            auto_inlay_hints = true,
            inlay_hints_highlight = "Comment",
        })
        ts_utils.setup_client(client)
    end,
}
lspconfig.svelte.setup {}
lspconfig.svelte.setup {}
lspconfig.html.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { "html", "htmldjango" }, -- Add more filetypes if necessary
}
lspconfig.cssls.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { "css"}, -- Add more filetypes if necessary
}
lspconfig.pyright.setup {}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Autocompletion
-- LSP Setup
local cmp = require('cmp')
local lspkind = require('lspkind')

-- nvim-cmp setup for auto-imports
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
    formatting = {
        format = lspkind.cmp_format({ with_text = true, maxwidth = 50 })
    },
})

-- LSP configuration for TypeScript/JavaScript with auto-imports

-- Treesitter (Better Syntax Highlighting)


-- Auto-pairs (Automatic closing of brackets, quotes, etc.)
require('nvim-autopairs').setup {}
-- nvim-tree configuration
require("nvim-tree").setup({
    view = {
        side = "right", -- Open the file explorer on the right
        width = 30,
    },
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    filters = {
        dotfiles = false, -- Show hidden files (set to true to hide dotfiles)
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})

-- ToggleTerm setup
require("toggleterm").setup({
    size = 15,                -- Height of the terminal window
    open_mapping = [[<C-\>]], -- Keybinding to toggle terminal
    direction = 'horizontal', -- Open terminal horizontally
    shading_factor = 2,       -- Darken the terminal background
    close_on_exit = true,     -- Close terminal when process exits
    shell = vim.o.shell,      -- Use default shell
})
-- Function to format the current buffer
local function lsp_formatting(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- Apply only Prettier via null-ls
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- Set up auto-formatting on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--    callback = function(event)
--        lsp_formatting(event.buf)
--    end,
-- })

-- Commenting
vim.keymap.set("n", "<leader>/", ":Commentary<CR>")
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a')
vim.keymap.set('v', '<C-c>', '+y')
vim.keymap.set('n', '<C-x>', 'dd')
vim.keymap.set('n', '<C-v>', 'p')
vim.keymap.set('i', '<C-v>', '<Esc>pa')
vim.keymap.set('n', '<C-z>', 'u')
vim.keymap.set('n', '<C-y>', '<C-r>')
vim.keymap.set('n', '<C-a>', 'ggVG')

vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==')
vim.keymap.set('i', '<A-Down>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-Up>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<S-A-Down>', 'yyp')
vim.keymap.set('v', '<S-A-Down>', ":'<,'>t'><CR>gv")
-- Keybinding to toggle the file explorer
vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>')
-- Keybinding to toggle the terminal
vim.keymap.set('n', '<C-\\>', ':ToggleTerm<CR>')
vim.api.nvim_set_keymap('n', '<A-f>', ':lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })
