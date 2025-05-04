-- This is my neovim config built from scratch
--
-- Sources (as of now): typecraft vids & notusknot livestream & many long google searches
-- Hopefully, I can use this to configure neovim however i want to!

-- Set some variables here to make the rest of the config a bit more readable
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local configureKey = vim.keymap.set

-- Leader key
g.mapleader = " "

-- Remapping 
-- map semicolon to colon so that i don't have to press shift (very neat concept I recently learned)
cmd("map ; :")

-- TEXT FORMATTING
-- Tabbing
-- AY YA YA the documentation is oh so confusing
-- Here's what I want (For now): just tabs (no tabs & spaces combination), with each tab equal to 4 characters
-- Tabstop:
-- I don't really get what this setting does, but apparently it basically means that each tab character is equal to 4 spaces/is worth 4 columns in the editor? I actually don't think so and am jst confused now
cmd("set tabstop=4")
-- Softtabstop: (Soft tab stop)
-- TBH i don't fully understand this setting but setting it to 0 disables this feature
-- From what I understand, this sets the visual width of tabs in the document
-- ie. if tabstop was 3, but softtabstop was 4, pressing tab would insert 3 columns + a space?
-- Purpose: To change the visual width of tabs while still allowing for different behaviors of individual characters? Well idts because of shiftwidth below
cmd("set softtabstop=4")
-- Shiftwidth:
-- How wide each tab visually looks
-- I don't understand the purpose of all the other tabbing configuration then
cmd("set shiftwidth=4")
-- Noexpandtab/expandtab:
-- Use hard tabs instead of soft tabs/use soft tabs instead of hard tabs
cmd("set expandtab")
-- Autoindent:
-- Makes neovim automatically indent the next line of a document if the previous line is indented
-- Should always want this "on"
opt.autoindent = true;
-- Smartindent:
-- sounds nice, but messes up indents of nix comments :(
-- opt.smartindent = true;
-- Line Appearance settings:
-- highlights the line of text the cursor is on
opt.cursorline = true
-- stop line wrapping
cmd("set nowrap")

-- Text folding!
-- I will define some custom keybinds here bc I find the default keybindings (with "z") a bit goofy
-- Treat "<leader>k" as the key precursor for any text folds
-- (f is already taken for "finding" stuff with telescope)
-- Toggling folds (i pretty much exclusively use this instead of the separate binds for opening & closing folds)
configureKey("n", "<leader>kj", "za", {desc = "toggle folds"})
-- Command for creating folds
-- the command below runs in visual mode because text needs to be highlighted to get marked for folding
configureKey("v", "<leader>kk", "zf", {desc = "create folds"})
-- Command for deleting folds
configureKey("n", "<leader>kd", "zd", {desc = "delete folds under cursor"})


-- Left gutter settings
-- Left gutter typically included 3 things - sign column, line number, fold column
-- Still has that general structure but now has many more advanced features that can be defined through statuscolumn & lua functions
--
-- Overall left gutter formatting:
-- using the new "statuscolumn" feature, which allows for a lot of customization!
-- Explanation:
-- %s for status column
-- %= for right align
-- v:relnum & v:lnum for the line number
-- lua.display.fold() = custom function
opt.statuscolumn = "%s%=%{v:relnum == 0 ? v:lnum . ' ' : v:relnum} %{v:lua.fold_arrows()} "
-- 
-- Sign column:
-- The column which shows LSP suggestions and git changes
opt.signcolumn = "yes:1"
-- Integration of git signs handled by the gitsigns plugin
-- To do: Split up git & LSP
--
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
    return "|" -- inside an open fold, not first line
end
--
-- Line Number:
-- Enables the option to see absolute line numbers (the actual line number of a line)
-- Disabled because is handled with the v:lnum variable in "statuscolumn" above!
opt.number = false
-- 2 purposes: If not using "statuscolumn" & just using "numbercolumn", this enables the option to see relative line numbers in the number gutter
-- Therefore, you would think this should be disabled
-- However, is enabled because, if using "statuscolumn", this enables fast refresh of the relative numbers! (otherwise it is really slow + laggy)
opt.relativenumber = true


-- Window Management
-- Keybinds to move the cursor between windows
configureKey("n", "<leader>wh", "<C-w>h", {desc = "Move window focus left"})
configureKey("n", "<leader>wj", "<C-w>j", {desc = "Move window focus down"})
configureKey("n", "<leader>wk", "<C-w>k", {desc = "Move window focus up"})
configureKey("n", "<leader>wl", "<C-w>l", {desc = "Move window focus right"})
-- Keybinds to split a window
configureKey("n", "<leader>wv", "<C-w>v", {desc = "Split a window vertically"})
configureKey("n", "<leader>ws", "<C-w>s", {desc = "Split a window horizontally"})
-- Keybinds to resize a window 
-- Todo: Maybe use a shift version to make much larger changes to window size?
configureKey("n", "<leader>w=", "<C-w>+", {desc = "Increase window height"})
configureKey("n", "<leader>w-", "<C-w>-", {desc = "Decrease window height"})
configureKey("n", "<leader>w.", "<C-w>>", {desc = "Increase window width"})
configureKey("n", "<leader>w,", "<C-w><", {desc = "Decrease window width"})
-- Keybinds to close a window
configureKey("n", "<leader>wq", "<C-w>q", {desc = "Close an open window"})

-- Mouse usage
-- I want to use the mouse in visual & normal mode to select text when I need to
opt.mouse = "nv"

-- Options for storing the undo history of files into the local cache
-- Turned off for now because I don't really need the feature & I'm not too sure how the cache works on linux
opt.undofile = false
-- opt.undodir = "/home/arjuntina/.cache"
configureKey("n", "<leader>r", "redo", {desc = "Redo command (to undo any undos)"})

-- Other small things (searching, file sourcing)
-- Use smartcase when searching in a document (smartcase = if the word is all lowercase, the search is not case sensitive, but if the word has a capital, the search becomes case sensitive)
opt.smartcase = true
-- automatically load changes in a file if it was changed elsewhere
opt.autoread = true

-- TO DO:
-- FUNCTION FOLDING!!!!
-- PROJECT ORGANIZATION
-- um other keybinds as well? (mass commenting - which needs to vary based on file type)
-- make sure to save all files once quit?
-- Fix copy and paste stuff!!! (Have smth like ctrl-shift-c copy to the system clipboard)
