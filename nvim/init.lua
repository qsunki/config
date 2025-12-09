require("config.lazy")

vim.cmd.colorscheme("moonfly")
vim.opt.scrolloff = 5
vim.opt.tabstop = 4
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 4

vim.keymap.set("n", "<leader>s1", function()
		vim.cmd("match Error /\\V\\<" .. vim.fn.expand("<cword>") .. "\\>/")
end)

vim.keymap.set("n", "<leader>s2", function()
		vim.cmd("2match IncSearch /\\V\\<" .. vim.fn.expand("<cword>") .. "\\>/")
end)

vim.keymap.set("n", "<leader>s3", function()
		vim.cmd("3match Todo /\\V\\<" .. vim.fn.expand("<cword>") .. "\\>/")
end)

vim.keymap.set("n", "<leader>sd", function()
		vim.cmd("match none | 2match none | 3match none")
end)

-- Quickfix navigation
vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>", { silent = true })

--vim.api.nvim_set_hl(0, "LazyNormal", { bg = "#1e1e1e" })
