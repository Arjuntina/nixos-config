local wk = require("which-key")

wk.setup({
    icons = {
        separator = "",
    }
})

wk.add({
    { "<leader>f", group = "Find (telescope)" },  -- group
    { "<leader>k", group = "Code folding" },  -- group
    { "<leader>l", group = "LSP stuff" },  -- group
    { "<leader>w", group = "Window management" },  -- group
    { "<leader>c", group = "Code commenting" },  -- group
    { "<leader>d", group = "Directory view (neotree)" },  -- group
})
