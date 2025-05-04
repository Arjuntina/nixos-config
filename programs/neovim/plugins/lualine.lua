-- config for the lualine plugin
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'palenight',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = {
            { 'mode', fmt = function(str) return str:sub(1,1):upper() .. str:sub(2):lower() end , separator = { left = '' }, padding = {left = 1, right = 1} }
        },
        lualine_b = {
            { 'branch', padding = {left = 2, right = 1} },
            'diff',
            'diagnostics'
        },
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {
            { 'progress', padding = {left = 1, right = 1} }
        },
        lualine_z = {
            { 'location', separator = { right = '' }, padding = {left = 2, right = 1} }
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}






























































