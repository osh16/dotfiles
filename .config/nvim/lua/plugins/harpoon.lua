return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon");
      local conf = require("telescope.config").values
      local themes = require("telescope.themes")
      harpoon.setup()

      local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
          end

          require("telescope.pickers").new(themes.get_dropdown({
            layout_config = {
              prompt_position = "top",
            }
          }), {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                  results = file_paths,
              }),
              -- previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
          }):find()
      end

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, {desc = "Add file to harpoon"})
      vim.keymap.set("n", "<leader>rm", function() harpoon:list():add() end, {desc = "Remove file from harpoon"})
      --vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end, {desc = "Open harpoon window"})
      vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "Open harpoon window"})
      vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end, {desc = "Next harpoon file"})
      vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end, {desc = "Prev harpoon file"})
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, {desc = "Harpoon to file 1"})
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, {desc = "Harpoon to file 2"})
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, {desc = "Harpoon to file 3"})
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, {desc = "Harpoon to file 4"})
      vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, {desc = "Harpoon to file 5"})
      vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, {desc = "Harpoon to file 6"})
    end
	},
}
