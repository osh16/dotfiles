return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
      local netcoredbg_adapater = {
        type = "executable",
        command = mason_path,
        args = { "--interpreter=vscode" },
      }

      dap.adapters.netcoredbg = netcoredbg_adapater
      dap.adapters.coreclr = netcoredbg_adapater

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file")
          end,
        },
      }
      vim.fn.sign_define('DapBreakpoint', {text='B', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
      vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint", noremap = true })
      vim.keymap.set("n", "<F1>", function() dap.continue() end, { desc = "DAP Continue", noremap = true })
      vim.keymap.set("n", "<F2>", function() dap.step_into() end, { desc = "DAP Step Into", noremap = true })
      vim.keymap.set("n", "<F3>", function() dap.step_over() end, { desc = "DAP Step Over", noremap = true })
      vim.keymap.set("n", "<F4>", function() dap.step_out() end, { desc = "DAP Step Out", noremap = true })
      vim.keymap.set("n", "<F5>", function() dap.step_back() end, { desc = "DAP Step Out", noremap = true })

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
