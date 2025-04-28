------- Lazy Bootstrap -------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---- Plugin Installation ----
require("lazy").setup({
    -- Gruvbox, sexy ass colorscheme
    "ellisonleao/gruvbox.nvim",

    -- Tokyonight, close second colorscheme
    "folke/tokyonight.nvim",

    -- A color scheme, nightfox
    "EdenEast/nightfox.nvim",

    -- Evangelion theme
    "nyngwang/nvimgelion",

    -- Snacks, a collection of QoL plugins that add many features
    "folke/snacks.nvim",

    -- Mini, another collection of QoL plugins
    "echasnovski/mini.nvim",

    -- -- Anyline, gives us animated indentation line
    { 'coal-rock/anyline.nvim',  opts = {} },

    -- ToggleTerm, nice quality of life wrapper for the default Neovim terminal
    { 'akinsho/toggleterm.nvim', opts = {} },

    -- Pretty icons
    "nvim-tree/nvim-web-devicons",

    -- Mason, used for LSP installation
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    'neovim/nvim-lspconfig',

    -- Telescope, a "fuzzy finder" - does many things
    'nvim-telescope/telescope.nvim',

    -- Lazydev, gives us auto-complete for the Neovim Lua API
    { 'folke/lazydev.nvim',            ft = "lua",                                opts = {} },

    -- Lualine, gives us a pretty status line
    { 'nvim-lualine/lualine.nvim' },

    -- Nvim-autopairs, automatically matches "{" with "}"
    { 'windwp/nvim-autopairs',         config = true },

    -- Telescope, gives us fast, comfy fuzzy finding (search through files, lsp suggestions, etc)
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Treesitter, basically magic
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'tree-sitter/tree-sitter-regex'
        },
        build = ':TSUpdate',
    },

    -- Todo-comments, gives us:
    -- TODO: highlighting
    { "folke/todo-comments.nvim", opts = {} },

    -- Lsp-lines, gives us inline error lense
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',

    -- Noice, UI overhaul
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    -- Blink, used for autocompletion
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            -- Snippets provider
            'rafamadriz/friendly-snippets',
        },
    },

    -- Multiple cursors, VSCode-like multi-line editing
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*",
        opts = {},
        keys = {
            { "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x" },      desc = "Add cursor and move down" },
            { "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x" },      desc = "Add cursor and move up" },

            { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
            { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "i", "x" }, desc = "Add cursor and move down" },

            { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   mode = { "n", "i" },      desc = "Add or remove cursor" },

            { "<Leader>m",     "<Cmd>MultipleCursorsAddVisualArea<CR>",    mode = { "x" },           desc = "Add cursors to the lines of the visual area" },

            { "<Leader>a",     "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to cword" },
            { "<Leader>A",     "<Cmd>MultipleCursorsAddMatchesV<CR>",      mode = { "n", "x" },      desc = "Add cursors to cword in previous area" },

            { "<Leader>d",     "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" },      desc = "Add cursor and jump to next cword" },
            { "<Leader>D",     "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" },      desc = "Jump to next cword" },

            { "<Leader>l",     "<Cmd>MultipleCursorsLock<CR>",             mode = { "n", "x" },      desc = "Lock virtual cursors" },
        },
    },

    -- Surround, enables comfy manipulation of surrounding pairs
    { "kylechui/nvim-surround",   opts = {} },
})


---- Plugin Setup ----

-- Configure lualine
require("lualine").setup({
    options = {
        component_separators = '',
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {
            {
                'mode',
                icon = { "" },
                separator = { left = '', right = '' },
                padding = { left = 1, right = 0 },
            }
        },
        lualine_b = {
            'branch',
            'diff',
            {
                'diagnostics',
                separator = { left = '', right = '' },
                padding = { left = 0, right = 1 }
            },
        },
        lualine_c = {
            {
                '%=',
                padding = 0,
            },
            {
                '',
            },
            {

                -- Fun little hack!
                -- This displays some information regarding the most recently
                -- recorded macro in the status line
                function()
                    local path = vim.fn.expand("%:t")

                    local recording_reg = vim.fn.reg_recording()
                    local macro_reg = vim.fn.reg_recorded()
                    local exec_reg = vim.fn.reg_executing()

                    if exec_reg ~= "" then
                        return path .. " | executing @" .. exec_reg
                    end

                    if recording_reg ~= "" then
                        return path .. " | recording @" .. recording_reg
                    end

                    if macro_reg ~= "" then
                        return path .. " | @" .. macro_reg
                    end

                    return vim.fn.expand("%:t")
                end,
                separator = { left = '', right = '' },
                padding = 0,
                color = {
                    fg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg),
                    bg = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).fg),
                }
            },
            { '' },
        },
        lualine_x = {},
        lualine_y = {
            {
                'filetype',
                separator = { left = '', right = '' },
            },
            'lsp_status',
            {
                'progress',
                separator = { left = '', right = '' },
                padding = { left = 1, right = 1 },
            }
        },
        lualine_z = {
            {
                'location',
                separator = { left = '', right = '' },
                padding = { left = 0, right = 1 },
            }
        }
    }
})
vim.opt.showmode = false
vim.opt.fillchars = vim.tbl_extend('force', vim.opt.fillchars:get(), {
    stl = '━',
    stlnc = '━',
})

-- Configure blink
require("blink.cmp").setup({
    keymap = {
        preset = 'enter',
        -- Bind tab and shift tab to scroll through completions
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },

        -- Scroll up and down in documentation with Ctrl+u and Ctrl+d
        ['<C-u>'] = { 'scroll_documentation_up' },
        ['<C-d>'] = { 'scroll_documentation_down' },
    },

    completion = {
        documentation = {
            -- Automatically show documentation with 0ms of debounce
            auto_show = true,
            auto_show_delay_ms = 0,
            -- Add rounded borders to documentation popup
            window = {
                border = "rounded",
            },
        },
        -- Add rounded borders to autocomplete popup
        menu = {
            border = "rounded",
        }
    },

})

-- Configure noice
require("noice").setup({
    lsp = {
        -- Disable LSP progress indicator
        progress = {
            enabled = false,
        },
        -- Prevent notification when trying to get LSP info with no running LSP
        hover = {
            silent = true,
        },
        message = {
            enabled = true,
            view = "notify"
        },
        override = {
            -- override markdown rendering
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
        }
    },
    views = {
        -- Add rounded corner to LSP hover
        hover = {
            border = {
                style = "rounded",
            }
        },
    }
})

-- Configure snacks
require("snacks").setup {
    -- Enable better statuscolumn
    statuscolumn = {
        folds = {
            open = true,
            git_hl = true,
        }
    },

    -- Enable file explorer
    explorer = { enabled = true },

    -- Configure + enable dashboard
    dashboard = {
        formats = {
            header = {
                '░▒▓█▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░\n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓██████▓▒░   ░▒▓██████▓▒░   ░▒▓██████▓▒░  \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░        ░▒▓█▓▒░       \n' ..
                '░▒▓█▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░',
                align = "center"
            }
        },
        sections = {
            { section = "header" },
            { icon = " ", title = "Actions", section = "keys", indent = 2, padding = 1 },
            { section = "startup" },
            {
                title = "“So, you can continue to use your arrow keys and mouse to navigate, but make no mistake...",
                align = "center",
                padding = { 0, 5 },
            },
            {
                title = "there is no faster way to edit text than through vi/vim”",
                align = "center",
                padding = { 1, 0 },

            },
            {
                title = "-Phipps",
                align = "center",

            },
        },
    },
}

-- Initialize Mason
require("mason").setup()
require("mason-lspconfig").setup()

-- Automatically setup LSPs
require("mason-lspconfig").setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = require('blink.cmp').get_lsp_capabilities()
        }
    end
}

-- Configure treesitter
require('nvim-treesitter.configs').setup {
    -- Allow async installation
    sync_install = false,

    -- Automatically install treesitter grammar for whatever language we're working with
    auto_install = true,

    -- We leave these blank, as we don't want to configure them at the moment
    ensure_installed = {},
    ignore_install = {},
    modules = {},

    highlight = {
        -- Enable syntax-aware highlighting
        enable = true,
        -- Remove old, dumb highlighting
        additional_vim_regex_highlighting = false,
    },
}


-- Configure telescope
require('telescope').setup {
    defaults = {
        -- We shouldn't be searching here, this can slow down performance and bloat results
        file_ignore_patterns = { "node_modules", "target/" },
        -- Keybindings!
        mappings = {
            i = {
                ['<Esc>'] = 'close',
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ['<Tab>'] = require('telescope.actions').move_selection_next,
                ['<S-Tab>'] = require('telescope.actions').move_selection_previous,
            },
        },
    },
}

-- require("multiple-cursors.nvim").setup({
--     keys = {
--         { "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x" },      desc = "Add cursor and move down" },
--         { "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x" },      desc = "Add cursor and move up" },
--
--         { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
--         { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
--
--         { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   mode = { "n", "i" },      desc = "Add or remove cursor" },
--
--         { "<Leader>m",     "<Cmd>MultipleCursorsAddVisualArea<CR>",    mode = { "x" },           desc = "Add cursors to the lines of the visual area" },
--
--         { "<Leader>a",     "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to cword" },
--         { "<Leader>A",     "<Cmd>MultipleCursorsAddMatchesV<CR>",      mode = { "n", "x" },      desc = "Add cursors to cword in previous area" },
--
--         { "<Leader>d",     "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" },      desc = "Add cursor and jump to next cword" },
--         { "<Leader>D",     "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" },      desc = "Jump to next cword" },
--
--         { "<Leader>l",     "<Cmd>MultipleCursorsLock<CR>",             mode = { "n", "x" },      desc = "Lock virtual cursors" },
--     }
-- })

---- Basic Configuration ----

-- Enable lazydev
vim.g.lazydev_enabled = true

-- Set colorscheme to the *best* (and only valid choice)
vim.cmd.colorscheme "tokyonight"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Enable sexy, 24-bit color
vim.o.termguicolors = true

-- Always show sign column, we get layout shifts without this
vim.o.signcolumn = "yes"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync yank with system clipboard
vim.o.clipboard = 'unnamed,unnamedplus'

-- Show current line number
vim.wo.number = true

-- Show relative line numbers
vim.wo.relativenumber = true

-- Tabs should be 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- Disable virtual_text, this is replaced with Lsp-lines
vim.diagnostic.config({ virtual_text = false })

-- Disabe line-wrapping
vim.cmd.set 'nowrap'

-- Make scrolloff behavior mimic Helix
vim.o.scrolloff = 5

-- Disable tab line
vim.opt.showtabline = 0

-- Round diagnostic border
vim.diagnostic.config({
    float = {
        border = "rounded",
    }
})

---- Keybindings ----

-- Remap redo to something actually same
vim.keymap.set('n', 'U', vim.cmd.redo)

-- Stop highlighting search after pressing "escape"
vim.keymap.set('n', '<Esc>', function() vim.cmd 'noh' end)

-- Toggle Snacks-explorer with Space + f
vim.keymap.set('n', '<space>f', Snacks.explorer.open)

-- Toggle terminal with Space + t
vim.keymap.set('n', '<space>t', function() vim.cmd "ToggleTerm" end)

-- Peek definition with Shift+K
vim.keymap.set('n', 'K', function() require("noice.lsp").hover() end)

-- Peek error/warning with Shift+J
vim.keymap.set('n', 'J', vim.diagnostic.open_float)

-- Toggle lsp_lines
vim.keymap.set('n', 'L', require("lsp_lines").toggle)

-- Go to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

-- Go to references
vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references)

-- LSP-aware rename
vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename)

-- Open LSP actions
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action)

-- Search document symbols
vim.keymap.set('n', '<space>ss', require("telescope.builtin").lsp_document_symbols)

-- Search workspace symbols
vim.keymap.set('n', '<space>sS', require("telescope.builtin").lsp_dynamic_workspace_symbols)

-- Search workspace diagnostics
vim.keymap.set('n', '<leader>sD', require('telescope.builtin').diagnostics)

-- Search workspace via grep
vim.keymap.set('n', '<space>sg', require("telescope.builtin").live_grep)

-- Search workspace files
vim.keymap.set('n', '<space>sf', require("telescope.builtin").find_files)

-- Search registers
vim.keymap.set('n', '<space>sr', require("telescope.builtin").registers)

-- Search installed color schemes
vim.keymap.set('n', '<space>sc', function()
    require("telescope.builtin").colorscheme({
        enable_preview = true,
    })
end)

-- Maps <Esc> to normal mode from the terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

---- Custom Commands ----

-- Creates the ":Format" command, that automatically formats the current buffer
vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
end, {})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

---- Format on write ----
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
