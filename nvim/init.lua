require("config.lazy")

-- Keybinds
vim.keymap.set({"n", "i", "v"}, "<C-s>", "<Cmd>w<CR>")
vim.keymap.set("v", "<C-/>", "gc", {remap = true}) -- Not set in Comment.lua as it doesn't use remap = true

vim.keymap.set({"n", "v", "i"}, "<C-l><C-g>", "<Cmd>FzfLua live_grep<CR>")

vim.keymap.set({"n", "v", "i"}, "<F7>", "<Cmd>! ./build.sh<CR>")
vim.keymap.set({"n", "v", "i"}, "<F5>", "<Cmd>! ./run.sh<CR>")

vim.opt.tabstop = 4 
vim.opt.shiftwidth = 4

vim.opt.number = true

-- Show Diagnositcs (Erros/Warnings)
vim.diagnostic.config({ virtual_text = true })
