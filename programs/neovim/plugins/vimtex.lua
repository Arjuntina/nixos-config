-- Should already be enabled by default in neovim (not in regular vim), but will include anyway
vim.cmd("filetype plugin indent on")
-- Another necessary command which allows for Vim's and Neovim's syntax related features? Which should also be enabled by default but idk?
vim.cmd("syntax enable")

-- the document viewer I am choosing to use
vim.g.vimtex_view_method = "zathura"

-- allows for some pretty neat built in shortcuts :)
vim.g.maplocalleader = "\\"

-- Documentation in the section below is from good online articles
-- The commands below conceals $ and [ latex brackets until you enter the line which they are on, making the document cleaner -- also they replace math symbols (investigate further)
-- They do not seem to work :(
vim.cmd("set conceallevel=1")
vim.g.text_conceal="abdmg"

-- End of section
