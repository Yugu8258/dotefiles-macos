-- Using the built-in plugin manager. See `:help vim.pack`.
-- Update with `:lua vim.pack.update()`.

vim.pack.add {
    'https://github.com/folke/snacks.nvim',
    'https://github.com/Shatur/neovim-ayu',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/christoomey/vim-tmux-navigator',
    'https://github.com/akinsho/toggleterm.nvim',
    'https://github.com/lukas-reineke/virt-column.nvim',
    'https://github.com/rmagatti/alternate-toggler',
    'https://github.com/HiPhish/rainbow-delimiters.nvim',
}

-- Set rainbow delimiter highlight groups before plugin initialization
vim.g.rainbow_delimiters = {
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}

local function apply_rainbow_delimiters_hl()
    local palette = {
        love = '#eb6f92',
        gold = '#f6c177',
        pine = '#3e8fb0',
        rose = '#ea9a97',
        leaf = '#95b1ac',
        iris = '#c4a7e7',
        foam = '#9ccfd8',
    }

    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = palette.love })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = palette.gold })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = palette.pine })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = palette.rose })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = palette.leaf })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = palette.iris })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = palette.foam })
end

local rainbow_group = vim.api.nvim_create_augroup('user-rainbow-delimiters', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    desc = 'Apply rainbow delimiter highlights when opening a buffer',
    group = rainbow_group,
    once = true,
    callback = apply_rainbow_delimiters_hl,
})
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Re-apply rainbow delimiter highlights after colorscheme changes',
    group = rainbow_group,
    callback = apply_rainbow_delimiters_hl,
})

-- Load snacks early with only the indent module enabled. See `:help snacks-indent`
local ok_snacks, snacks = pcall(require, 'snacks')
if ok_snacks then
    snacks.setup {
        indent = {
            enabled = true,
            char = '│',
            scope = {
                enabled = true,
            },
            chunk = {
                enabled = false,
            },
        },
        -- Explicitly disable unused modules to avoid unintended side effects
        dashboard = { enabled = false },
        picker = { enabled = false },
        explorer = { enabled = false },
        layout = { enabled = false },
        win = { enabled = false },
        input = { enabled = false },
        quickfile = { enabled = false },
        image = { enabled = false },
        scroll = { enabled = false },
    }
end

-- Treesitter. Neovim only bundles parsers for c, lua, markdown, vim, vimdoc and
-- query; nvim-treesitter installs the rest. Needs `tree-sitter` CLI and a C compiler.
-- See `:help treesitter-highlight` and `:checkhealth nvim-treesitter`
local ts_langs = { 'bash', 'make', 'python' }
require('nvim-treesitter').install(ts_langs)
vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Update parsers when nvim-treesitter is updated',
    group = vim.api.nvim_create_augroup('user-ts-update', { clear = true }),
    callback = function(ev)
        if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
            vim.cmd 'TSUpdate'
        end
    end,
})

-- Only for the languages above: c's regex syntax plus clangd's semantic tokens looks
-- just as good, without the flicker of the async first parse
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Use treesitter highlighting for the installed parsers',
    group = vim.api.nvim_create_augroup('user-ts-start', { clear = true }),
    pattern = vim.iter(ts_langs):map(vim.treesitter.language.get_filetypes):flatten()
        :totable(),
    callback = function() vim.treesitter.start() end,
})

-- Colorscheme. `ayu mirage`
require('ayu').setup {
    mirage = true,
    overrides = {
        Normal = { bg = vim.g.neovide and "#212836" or "None" },
        NormalFloat = { bg = vim.g.neovide and "#212836" or "None" },
        SignColumn = { bg = "None" },

        -- Current line number (Ayu Mirage warm orange)
        CursorLineNr = { fg = "#FFA759", bg = "None", bold = true },
        -- Relative line numbers above and below cursor
        LineNrAbove = { fg = "#5C6773", bg = "None" },
        LineNrBelow = { fg = "#5C6773", bg = "None" },
        -- Fallback standard line number
        LineNr = { fg = "#707A8C", bg = "None" },
        -- Subtle cursorline background
        CursorLine = { bg = "#283040" },
    },
}
vim.cmd.colorscheme 'ayu'

-- Toggle alternate values under cursor. See `:help alternate-toggler`
local ok_alt, alt = pcall(require, 'alternate-toggler')
if ok_alt then
    alt.setup {
        alternates = {
            -- Booleans (case variants)
            { 'true', 'false' },
            { 'True', 'False' },
            { 'TRUE', 'FALSE' },
            -- Comparison operators
            { '===',  '!==' },
            { '==',   '!=' },
        },
    }
    vim.keymap.set('n', '<leader>i', '<cmd>ToggleAlternate<CR>', { desc = 'Toggle alternate word/operator' })
end

-- Virtual column guide at column 120. See `:help virt-column`
local virt_column_group = vim.api.nvim_create_augroup('user-virt-column', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    desc = 'Setup virt-column when opening a buffer',
    group = virt_column_group,
    once = true,
    callback = function()
        -- Safely load plugin so startup is never blocked on failure
        local ok, virt_column = pcall(require, 'virt-column')
        if not ok then
            return
        end

        virt_column.setup {
            -- Column guide at character 120 matching textwidth = 120
            virtcolumn = '120',
            char = '│',
            highlight = 'NonText',
            exclude = {
                filetypes = {
                    'alpha',
                    'dashboard',
                    'neo-tree',
                    'toggleterm',
                    'lazy',
                    'mason',
                    'TelescopePrompt',
                    'notify',
                },
                buftypes = {
                    'terminal',
                    'quickfix',
                    'help',
                    'nofile',
                    'prompt',
                },
            },
        }
    end,
})

-- Toggleable terminal. See `:help toggleterm`
require('toggleterm').setup {
    open_mapping = [[<D-j>]],
    insert_mappings = true,
    terminal_mappings = true,
    direction = 'float',
    float_opts = {
        border = 'curved',
        width = 145,
        height = 45,
    },
}

-- Minimal file explorer. See `:help oil`
require('oil').setup({
    delete_to_trash = false,
    skip_confirm_for_simple_edits = true,
    constrain_cursor = "editable",
    view_options = {
        show_hidden = true,
    },
})
vim.keymap.set('n', '<leader>-', '<cmd>lua require("oil").open_float()<CR>', { desc = 'Open parent directory (float)' })

-- Git added/changed/deleted lines in the sign column. See `:help gitsigns`
require('gitsigns').setup()

-- Telescope, see `:help telescope`
require('telescope').setup()
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ff', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers,
    { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sm', function()
    -- Sections 2 (system calls) and 3 (C library functions)
    local opts = { sections = { '2', '3' } }
    -- Match on every name of a page (e.g. "calloc, free, malloc"), not just the first
    local make_entry = require('telescope.make_entry').gen_from_apropos(opts)
    opts.entry_maker = function(line)
        local entry = make_entry(line)
        if entry then
            entry.ordinal = entry.keyword
        end
        return entry
    end
    builtin.man_pages(opts)
end, { desc = '[S]earch [M]an pages' })

-- ========== vim-tmux-navigator keymaps  ==========
vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'Tmux navigate left', silent = true })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'Tmux navigate down', silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'Tmux navigate up', silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'Tmux navigate right', silent = true })
vim.keymap.set('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'Tmux navigate previous', silent = true })
-- terminal
vim.keymap.set('t', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'Tmux navigate left', silent = true })
vim.keymap.set('t', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'Tmux navigate down', silent = true })
vim.keymap.set('t', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'Tmux navigate up', silent = true })
vim.keymap.set('t', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'Tmux navigate right', silent = true })
