-- This is my neovim config built from scratch
--
-- Sources (as of now): typecraft vids & notusknot livestream
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

-- Tabbing
-- AY YA YA the documentation is oh so confusing
-- Here's what I want (For now): just tabs (no tabs & spaces combination), with each tab equal to 3 characters
-- Tabstop:
-- I don't really get what this setting does, but apparently it basically means that each tab character is equal to 3 spaces/is worth 3 columns in the editor? I actually don't think so and am jst confused now
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

-- Line Settings
-- This allows us to see what absolute line number the cursor is on
opt.number = true
-- This allows us to see the relative line numbers of the lines above/below the cursor
opt.relativenumber = true
-- highlights the line of text the cursor is on -- do I really want this? I can try and see
opt.cursorline = true
-- stop line wrapping
cmd("set nowrap")

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
configureKey("n", "<leader>w=", "<C-w>+", {desc = "Increase window height"})
configureKey("n", "<leader>w-", "<C-w>-", {desc = "Decrease window height"})
configureKey("n", "<leader>w.", "<C-w>>", {desc = "Increase window width"})
configureKey("n", "<leader>w,", "<C-w><", {desc = "Decrease window width"})
-- Keybinds to close a window
configureKey("n", "<leader>wq", "<C-w>q", {desc = "Close an open window"})

-- Mouse usage
-- I want to use the mouse in visual & normal mode
opt.mouse = "nv"

-- Options for storing the undo history of files into the local cache
-- Turned off for now because I don't really need the feature & I'm not too sure how the cache works on linux
opt.undofile = false
-- opt.undodir = "/home/arjuntina/.cache"

-- Other small things (searching, file sourcing)
-- Use smartcase when searching in a document
opt.smartcase = true
-- automatically load changes in a file if it was changed elsewhere
opt.autoread = true

