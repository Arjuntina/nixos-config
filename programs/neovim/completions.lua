-- TO DO: SPLIT INTO SEPARATE FILES!!!!
-- create commands that enable/disable certain collections of snippets??!? hm hm hm

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
local line_begin = require("luasnip.extras.expand_conditions").line_begin -- line begin condition

-- KEYBINDS
-- The code below allows tab & shift-tab to move between various input fields of snippets
-- These commands are just copied - I don't know the specifics of how they work
vim.keymap.set({ "i", "s" }, "<Tab>",
function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    else
        -- The code below allows tab to work normally when no completions are available
        -- copied from a good reddit post (https://www.reddit.com/r/neovim/comments/zrcrv1/luasnip_tab_as_expandjump_trigger/)
        -- Explanation: figure out later
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })

-- Code below does not work
-- Intended so that you can "jump backwards" in a snippet with S-tab
-- also I don't necessarily want the keybind to be S-Tab
-- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
--     if ls.jumpable(-1) then
--         ls.jump(-1)
--     end
-- end, { silent = true })

-- Use the mapping below to cycle through choice nodes
-- Look into this one too
-- Then add to keybind
vim.cmd[[ 
    " Cycle forward through choice nodes with Control-f (for example)
    imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
]]

-- more config options (for changing the way snippets behave/appear) here
ls.config.setup({
    -- This line allows certain snippets to be autoexpandable
    enable_autosnippets = true,
    -- This line allows items in a repeat node to update as they are being typed (creates cool effect)
    update_events = 'TextChanged,TextChangedI',
    -- store_selection_keys = what to use for "cut and paste" snippets (think latex math mode snippets)
    store_selection_keys = "<Tab>", -- Not sure if this option should go here or in ls.config.set_config (or if it matters)
})

-- Lua function which returns the contents of selected/stored text in the LS_SELECT_RAW variable and outputs it to the default value of an input node
-- Allows for highlighting of syntax and inserting brackets around it "after the fact" (for "cut and paste" snippets)
local get_selected = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end




-- The line below lets us use "friendly snippets" from vscode (in documentation for luasnip)
-- copied from typecraft vids
-- disabled for now bc interferes with the manual snippets I have
-- Is there a way to prioritize the snippets i have? hm hm hm
-- require("luasnip.loaders.from_vscode").lazy_load() -- is disabled for now bc is hindering expansion of manual snippets (see if I can make this not autoexpand)

-- The configuration below contains manual snippet expansions
-- am still learning how it works
-- TODO: Put in separate files!!!!
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
    -- Sections
    s({ trig = "beg", -- short for "beginning a section"
        -- snippetType = "autosnippet", -- allows for the snippet to autoexpand -- lowk am scared of that rn so will wait till am more comfortable
        name = "Create Latex section",
    },{
        t("\\begin{"), i(1), t("}"),
        t({ "", "\t" }), i(0), -- strange that i(0) is used here but i(0) refers to the last input
        t({ "", "\\end{" }), rep(1), t("}"),
    },{
        condition = line_begin -- can only expand the snippet at the beginning of a line, uses a local definition from above
    }),

    -- text formatting
    s("bb", {
        t("\\textbf{"),
        d(1, get_selected),
        t("}")
    }),
    s("it", {
        t("\\textit{"),
        d(1, get_selected),
        t("}")
    }),
    s("uu", {
        t("\\underline{"),
        d(1, get_selected),
        t("}")
    }),
    s("em", {
        t("\\emph{"),
        d(1, get_selected),
        t("}")
    }),
    s("nl", {
        t("\\vspace{1em}")
    }),


    -- Math modes
    -- mm for math mode 
    s({
        trig = "mm", -- eventually want to use regex to make mm a trigger EXCEPT when it is located in the middle of a word
        -- wordTrig = false, regTrig = true -- parameters which basically tell the function to are pay attention to the regex string (which is specified) -- could NOT get this to work
    },{
        t("$"), d(1, get_selected), t("$"), i(0)
    },{
    }),
    -- dm for display math
    s({
        trig = "dm", -- eventually want to use regex to make dm a trigger EXCEPT when it is located in the middle of a word
        -- wordTrig = false, regTrig = true -- parameters which basically tell the function to are pay attention to the regex string (which is specified) -- could NOT get this to work
    },{
        t({"\\[", "\t"}), d(1, get_selected), t({"", "\\]"}), i(0)
    },{
    }),

    -- Math symbols:
    -- big symbol "containers"
    s("^", {
        t("^{"),
        d(1, get_selected),
        t("}")
    }),
    s("_", {
        t("_{"),
        d(1, get_selected),
        t("}")
    }),
    s("fr", {
        t("\\frac{"),
        i(1),
        t("}{"),
        i(2),
        t("}")
    }),
    s("un", {
        t("\\cup")
    }),
    s("in", {
        t("\\cap")
    }),
    s("bun", {
        t("\\bigcup")
    }),
    s("bin", {
        t("\\bigcap")
    }),
    -- math letters
    s("ml", {
        t("\\mathbb{"),
        d(1, get_selected),
        t("}")
    }),
    s("mc", {
        t("\\mathcal{"),
        d(1, get_selected),
        t("}")
    }),
    -- small symbols
    s("inf", {
        t("\\infty")
    }),
    s("emp", {
        t("\\varnothing")
    }),
    -- greek letters
    s("al", {
        t("\\alpha")
    }),
    s("be", {
        t("\\beta")
    }),
    s("gam", {
        t("\\gamma")
    }),
    s("eps", {
        t("\\epsilon")
    }),
    s("ta", {
        t("\\tau")
    }),
    s("tau", {
        t("\\tau")
    }),
    -- text
    s("tt", {
        t("\\text{"),
        d(1, get_selected),
        t("}")
    }),

    -- Figures! Oh what a headache to implement
    s({ trig = "fig", -- short for "beginning a section"
        -- snippetType = "autosnippet", -- allows for the snippet to autoexpand -- lowk am scared of that rn so will wait till am more comfortable
        name = "Create Latex figure",
    },{
        t({ "\\begin{figure}[H]", "\t\\centering", "\t\\def\\svgwidth{0.5\\textwidth}", "\t\\import{./figures/renderedInkscape/}{"}),
        i(1),
        t({".pdf_tex}", "\t\\hfill", "\\end{figure}"})
    },{
        condition = line_begin -- can only expand the snippet at the beginning of a line, uses a local definition from above
    }),


})

