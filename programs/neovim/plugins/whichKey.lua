local wk = require("which-key")

wk.setup({
    icons = {
        separator = "",
    }
})

wk.add({
    { "<leader>f", group = "Find (with telescope)" },  -- group
    { "<leader>k", group = "Code folding" },  -- group
    { "<leader>w", group = "Window management" },  -- group
    { "<leader>c", group = "Code commenting" },  -- group
})
