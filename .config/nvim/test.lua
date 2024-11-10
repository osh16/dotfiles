require("telescope.builtin").find_files({ layout_strategy = "horizontal", layout_config = { prompt_position = "top" } })

require("telescope.themes").get_dropdown({})

require("telescope.builtin").find_files(require("telescope.themes").get_dropdown())

require("telescope.pickers").new({}, {
  prompt_title = "Harpoon",
  finder = require("telescope.finders").new_table({
    results = file_paths,
  }),
  previewer = conf.file_previewer({}),
  sorter = conf.generic_sorter({}),
}):find()

oskar = function()
	local lines = vim.fn.getline("'<", "'>")
	local code = table.concat(lines, "\n")
  vim.api.nvim_exec("lua << EOF\n" .. code .. "\nEOF", false)

end

print("Hello, world!")
