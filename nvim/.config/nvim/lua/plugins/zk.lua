return {
	{
		"zk-org/zk-nvim",
		config = function()
			require("zk").setup({
        picker = "snacks_picker",
        lsp = {
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
        },
        auto_attach = {
          enabled = true,
        },
			})
      vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "Zk New Note" })
      vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Zk Find Notes" })
      vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Zk Tags" })
      vim.keymap.set("v", "<leader>zl", ":'<,'>ZkInsertLink<CR>", { desc = "Zk Insert Link" })
      vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>", { desc = "Zk match visual selection"})
			vim.keymap.set("n", "<leader>zg", function()
        local script_path = vim.fn.expand("~/.local/bin/auto_save_zk.sh")
        vim.fn.jobstart({ script_path }, {
          stdout_buffered = true,
          stderr_buffered = true,

          on_stdout = function(_, data)
            if data and data[1] ~= "" then
              vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, {
                title = "🧠 ZK Sync",
                timeout = 3000,
                icon = "",
              })
            else
              vim.notify("ZK notes pushed (no output).", vim.log.levels.INFO, {
                title = "🧠 ZK Sync",
                timeout = 2000,
                icon = "",
              })
            end
          end,
          on_stderr = function(_, data)
            if data and data[1] ~= "" then
              -- Only notify if there is actual error output (not just any output)
              local has_error = false
              for _, line in ipairs(data) do
                if line ~= "" and not line:match("^To github.com:") and not line:match("^Already up to date%.") and not line:match("^%[master") and not line:match("master -> master") then
                  has_error = true
                  break
                end
              end
              if has_error then
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, {
                  title = "❌ ZK Push Failed",
                  timeout = 5000,
                  icon = "",
                })
              end
            end
          end,
        })
			end, { desc = "Zk Git Push" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<CR>", vim.lsp.buf.definition, { buffer = true, desc = "Go to Definition (ZK)" })
        end,
      })
		end,
	},
}
