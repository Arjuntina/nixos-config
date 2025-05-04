-- Todo: Add some keybinds + other goodies so that you can see changes made to code chunks, who modified the code, quickly stage, and more!

-- most of the stuff below are default settings - stuff I modify will have an additional comment

require('gitsigns').setup {
    -- not sure why the colors of sings aren't showing in the editor but they work quite nicely in practice
    signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        -- topdelete = code deleted at the top of a file
        topdelete    = { text = '‾' },
        -- changedelete = code that was modified and then deleted
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    -- again am not sure why the sign colors aren't showing
    -- description of the colors: more translucent versions of the big signs shown above
    -- I like it! :D
    signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
}
