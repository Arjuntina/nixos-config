require('Comment').setup({

    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,

    -- LHS of toggle mappings in NORMAL mode
    -- Disabled because I don't understand these in the slightest :0
    toggler = {
        ---Line-comment toggle keymap
        -- line = '<leader>cc',
        ---Block-comment toggle keymap
        -- block = '<leader>cv',
    },

    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    -- Lets you toggle comments with a simple keybind 
    opleader = {
        ---Line-comment keymap
        line = '<leader>cc',
        ---Block-comment keymap 
        block = '<leader>cb',
    },

    -- LHS of extra mappings
    -- Mainly used to add comments quickly on lines
    extra = {
        ---Add comment on the line above
        above = '<leader>ck',
        ---Add comment on the line below
        below = '<leader>cj',
        ---Add comment at the end of line
        eol = '<leader>cA',
    },

    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        basic = true,
        extra = true,
    },

    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
})


