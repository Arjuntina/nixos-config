-- Left gutter Status Column
-- Left gutter typically included 3 things - sign column, line number, fold column
-- Still has that general structure but now has many more advanced features that can be defined through statuscolumn & lua functions

-- UNFINISHED
-- To work on: Highlighting & Text color
-- Spacing!

-- some globals from the general config
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local configureKey = vim.keymap.set


-- Overall left gutter formatting:
-- using the new "statuscolumn" feature, which allows for a lot of customization!
-- Explanation:
-- %lua.diagnostics_symbols() = custom function which isolates diagnostics symbols
-- %s for status column (aka. git status)
-- %= for right align
-- v:relnum & v:lnum for the line number
-- lua.fold_arrows() = custom function
opt.statuscolumn = "%{v:lua.diagnostics_symbol()}%s%=%{v:relnum == 0 ? v:lnum . '' : v:relnum} %{v:lua.fold_arrows()} "

-- Sign column:
-- Traditionally the column which shows LSP suggestions and git changes
-- I have disabled LSP suggestions in the sign column so that the %s sign column ONLY displays git changes (LSP functionality is displayed in a column to the left of the sign column with a custom function defined below)
-- "auto" lets the signs be there for projects in which I am using git but lets the gitsigns disappear for ones in which I am not
-- "yes:1" always enforces a width of 1 and fixes the spacing on some projects? 
opt.signcolumn = "yes:1"
-- LSP functionality handled using the functions & settings below
-- Broad LSP settings
vim.diagnostic.config({
    signs = false, -- disable LSP warnings in the sign column
    virtual_text = true, -- displays diagnostic messages inline (ie right next to the line)
    underline = true, -- underlines the problem words
    update_in_insert = false, -- don't update the lsp while in insert mode (otherwise LSP distracting)
    severity_sort = true, -- sort errors by severity - displays errors over warnings over suggestions/hints
})
-- function to create the custom column which displays diagnostic symbols
function _G.diagnostics_symbol()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.v.lnum - 1  -- Lua line numbers are 0-indexed for diagnostics (they are always 1 off :0)
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum }) -- get the diagnostics for a particular line
    -- return " " if nothing
    if #diags == 0 then return " " end
    -- Get the most severe diagnostic
    -- most severe diagnostic = the lowest value of a.severity or b.severity (ranges from 1 to 4)
    table.sort(diags, function(a, b)
        return a.severity < b.severity  -- lower = more severe
    end)
    local severity = diags[1].severity
    local entry = _G.diagnostics_symbols[severity]
    -- using an external table here bc was trying to do something with highlighting but it was not working out
    return entry.text
end
_G.diagnostics_symbols = {
  [vim.diagnostic.severity.ERROR] = { text = "", hl = "DiagnosticError" },
  [vim.diagnostic.severity.WARN]  = { text = "", hl = "DiagnosticWarn"  },
  [vim.diagnostic.severity.INFO]  = { text = "", hl = "DiagnosticInfo"  },
  [vim.diagnostic.severity.HINT]  = { text = "", hl = "DiagnosticHint"  },
}
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#F44747" })  -- red
vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#FF8800" })  -- orange/yellow
vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#4FC1FF" })  -- blue
vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#10B981" })  -- green/teal


-- Fold column:
-- width set to 1
opt.foldcolumn = "1"
-- content determined by the function below (I use arrows to show folds)
-- _G for "global" scope of a lua function
_G.fold_arrows = {}
function _G.fold_arrows()
    -- store the current line number in a local variable
    local lnum = vim.v.lnum
    -- return the fold level of the line - if zero then the fold column should be empty
    local currentLineFoldLevel = vim.fn.foldlevel(lnum)
    if currentLineFoldLevel == 0 then
         return " " -- no fold here
    end
    -- at this point, all code is within a fold
    -- isFoldClosed determines whether a fold is closed or notusknot
    -- does so with the fold_closed function, which returns a value of -1 if the fold is open
    local isFoldClosed = vim.fn.foldclosed(lnum) ~= -1
    if isFoldClosed then
        return "" -- closed fold, top line of the fold
    end
    -- at this point, all code is in an open fold
    -- determine the amount of folding in the previous line (for line 1 the amount of folding in the previous line = 0)
    local prevLineFoldLevel = 0
    if (lnum ~= 1) then
        prevLineFoldLevel = vim.fn.foldlevel(lnum - 1)
    end
    -- if the currentFoldLevel > prevFoldLevel, that means that the current line is the first line of a fold
    if currentLineFoldLevel > prevLineFoldLevel then
        return "" -- first line of an open fold
    end
    -- if not, we indicate the rest of the fold with vertical lines
    return " " -- inside an open fold, not first line
end

-- Line Number:
-- Enables the option to see absolute line numbers (the actual line number of a line)
-- Disabled because is handled with the v:lnum variable in "statuscolumn" above!
opt.number = false
-- 2 purposes: If not using "statuscolumn" & just using "numbercolumn", this enables the option to see relative line numbers in the number gutter
-- Therefore, you would think this should be disabled
-- However, is enabled because, if using "statuscolumn", this enables fast refresh of the relative numbers! (otherwise it is really slow + laggy)
opt.relativenumber = true

-- TESTING ZONE
-- Am working on: highlighting

-- local bg = "#292d3e"
-- vim.api.nvim_set_hl(0, "StatusColumnBG", { bg = bg })

-- vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'AltGitSignsAdd' })
-- -- vim.api.nvim_set_hl(0, "AltGitSignsAdd", { fg = "#10932617", bg = bg })
-- vim.api.nvim_set_hl(0, "AltGitSignsAdd", { fg = "#10932617", bg = bg })
-- 
-- vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'AltGitSignsChange' })
-- -- vim.api.nvim_set_hl(0, "AltGitSignsChange", { fg = "#16746496", bg = bg })
-- vim.api.nvim_set_hl(0, "AltGitSignsChange", { fg = "#16746496", bg = bg })
-- 
-- vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'AltGitSignsDelete' })
-- -- vim.api.nvim_set_hl(0, "AltGitSignsDelete", { fg = "#16009031", bg = bg })
-- vim.api.nvim_set_hl(0, "AltGitSignsDelete", { fg = "#16009031", bg = bg })
