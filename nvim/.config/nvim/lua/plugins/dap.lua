return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      ui.setup()
      local dotnet = require("configs.nvim-dap-dotnet")

      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
      local netcoredbg_adapter = {
        type = "executable",
        command = mason_path,
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapter
      dap.adapters.coreclr = netcoredbg_adapter

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return dotnet.build_dll_path()
          end,
        },
      }
      vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
      vim.keymap.set("n", "<leader>b", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "DAP Toggle Breakpoint", noremap = true })
      vim.keymap.set("n", "<F1>", "<Cmd>lua require('dap').continue()<CR>", { desc = "DAP Continue", noremap = true })
      vim.keymap.set("n", "<F2>", "<Cmd>lua require('dap').step_into()<CR>", { desc = "DAP Step Into", noremap = true })
      vim.keymap.set("n", "<F3>", "<Cmd>lua require('dap').step_over()<CR>", { desc = "DAP Step Over", noremap = true })
      vim.keymap.set("n", "<F4>", "<Cmd>lua require('dap').step_out()<CR>", { desc = "DAP Step Out", noremap = true })
      vim.keymap.set("n", "<F5>", "<Cmd>lua require('dap').step_back()<CR>", { desc = "DAP Step Back", noremap = true })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        ui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        ui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        ui.close()
      end
    end,
  },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "nvim-neotest/nvim-nio" },
}
