-- cmp configuration
-- cmp is the "engine" that allows us to see and expand snippets
-- Configuration here is based on typecraft vids + github pages 
-- It will use luasnip as a backend
local cmp = require'cmp'

-- The setup function below comes from the documentation for nvim-cmp
cmp.setup({
    -- Setting the snippet engine
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
    -- For configuring how the window looks
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
    -- For configuring keymaps
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
    -- for determining the sources of the autocomplete segments
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    })
})



-- Luasnip configuration
-- the snippet expansion completion engine
-- I have configured luasnip to use both manual snippets (which am learning) as well as vscode snippets (which I copied from typecraft vids)

-- These variables (there are a lot) are apparently very useful to define for configuration -- are taken from the luasnip documentation/githib & a lot of other people use them
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key


-- The code below allows tab & shift-tab to expand/unexpand snippets?
-- Not sure of the exact specifics - could be something to look into!
vim.cmd[[
    " Use Tab to expand and jump through snippets
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

    " Use Shift-Tab to jump backwards through snippets
    imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
    smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]

-- The code below allows certain snippets to be autoexpandable
ls.config.setup({ enable_autosnippets = true })

-- The configuration below here allows moving across different input fields within a snippet
-- am using <A-j> for forward and <A-k> for backward (vim down & up)
vim.keymap.set({ "i", "s" }, "<A-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<A-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

-- The line below lets us use "friendly snippets" from vscode (in documentation for luasnip)
-- copied from typecraft vids
require("luasnip.loaders.from_vscode").lazy_load()

-- The configuration below contains manual snippet expansions
-- am still learning how it works
-- snippets for all files (used mainly for testing purposes)
ls.add_snippets("all", {
})
-- snippets for lua files (also mostly for testing)
ls.add_snippets("lua", {
    s("hello", {
        t('print("hello world")')
    })
})
-- snippets for latex files
ls.add_snippets("tex", {
    -- Overall:
    -- Sections
    s({ trig = "sec", -- short for "section"
        snippetType = "autosnippet", -- allows for the snippet to autoexpand
         -- can only expand the snippet at the beginning of a line
        name = "Create Latex section",
    },{
        t("\\begin{"), i(1), t("}"),
        t({ "", "\t" }), i(0), -- strange that i(0) is used here but i(0) refers to the last input
        t({ "", "\\end{" }), rep(1), t("}"),
    }),

    -- Math:
    -- fractions
    s("frac", {
        t("\\frac{"),
        i(1),
        t("}{"),
        i(2),
        t("}")
    }),
    -- text
    s("text", {
        t("\\text{"),
        i(1),
        t("}")
    }),
})

