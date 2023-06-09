local present, telescope = pcall(require, "telescope")
if not present then
    vim.notify("telescope not found.")
	return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {

		prompt_prefix = "  ",
		selection_caret = "  ",
		path_display = { "smart" },
		file_ignore_patterns = { ".git/", "node_modules" },

        pickers = {
            find_files = {
                hidden = true
            }
        },

		mappings = {
			i = {
				["<Down>"] = actions.cycle_history_next,
				["<Up>"] = actions.cycle_history_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
})
