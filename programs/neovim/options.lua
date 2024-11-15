-- This is my neovim config built from scratch
--
-- Right now, is based on typecraft's videos (he made a really good guide)
-- Hopefully, i can incorporate more of them in the future!


-- Tabbing
-- AY YA YA the documentation is oh so confusing
-- Here's what I want (For now): just tabs (no tabs & spaces combination), with each tab equal to 3 characters
-- Tabstop:
-- I don't really get what this setting does, but apparently it basically means that each tab character is equal to 3 spaces/is worth 3 columns in the editor? I actually don't think so and am jst confused now
vim.cmd("set tabstop=4")
-- Softtabstop: (Soft tab stop)
-- TBH i don't fully understand this setting but setting it to 0 disables this feature
-- From what I understand, this sets the visual width of tabs in the document
-- ie. if tabstop was 3, but softtabstop was 4, pressing tab would insert 3 columns + a space?
-- Purpose: To change the visual width of tabs while still allowing for different behaviors of individual characters? Well idts because of shiftwidth below
vim.cmd("set softtabstop=4")
-- Shiftwidth:
-- How wide each tab visually looks
-- I don't understand the purpose of all the other tabbing configuration then
vim.cmd("set shiftwidth=4")
-- Noexpandtab/expandtab:
-- Use hard tabs instead of soft tabs/use soft tabs instead of hard tabs
vim.cmd("set expandtab")
-- Autoindent:
-- Makes neovim automatically indent the next line of a document if the previous line is indented
-- Should always want this "on"
vim.cmd("set autoindent")
