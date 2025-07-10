return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		-- Configuración
		vim.g.mkdp_auto_start = 0 -- No abrir automáticamente
		vim.g.mkdp_auto_close = 1 -- Cerrar cuando cambies de buffer
		vim.g.mkdp_refresh_slow = 0 -- Refresh en tiempo real
		vim.g.mkdp_command_for_global = 0 -- Solo para archivos markdown
		vim.g.mkdp_open_to_the_world = 0 -- Solo localhost
		vim.g.mkdp_open_ip = "" -- Usar localhost
		vim.g.mkdp_browser = "" -- Usar browser por defecto
		vim.g.mkdp_echo_preview_url = 0 -- No mostrar URL en consola
		vim.g.mkdp_browserfunc = "" -- Función custom de browser
		vim.g.mkdp_theme = "light"

		-- Keymaps
		vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })
		vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown Preview Stop" })
		vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview Toggle" })
	end,
}
