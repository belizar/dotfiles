-- OIL --
local oil = require("oil")
oil.setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- OIL --

-- TELESCOPE --
local ok, builtin = pcall(require, "telescope.builtin")
if ok then
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
else
	-- Fallback si Telescope no está disponible
	vim.keymap.set("n", "<leader>ff", "<cmd>find .<cr>", { desc = "Find files (fallback)" })
end
-- TELESCOPE --
