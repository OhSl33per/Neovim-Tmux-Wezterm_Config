return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  keys = {
    { "<leader>dc", function() require("dap").continue() end,                                                    desc = "Debug: Start/Continue" },
    { "<leader>do", function() require("dap").step_over() end,                                                   desc = "Debug: Step Over" },
    { "<leader>di", function() require("dap").step_into() end,                                                   desc = "Debug: Step Into" },
    { "<leader>du", function() require("dap").step_out() end,                                                    desc = "Debug: Step Out" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end,                                           desc = "Debug: Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,        desc = "Debug: Conditional Breakpoint" },
    { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Debug: Log Point" },
    { "<leader>dr", function() require("dap").repl.open() end,                                                   desc = "Debug: Open REPL" },
    { "<leader>dL", function() require("dap").run_last() end,                                                    desc = "Debug: Run Last" },
    { "<leader>dt", function() require("dap").terminate() end,                                                   desc = "Debug: Terminate" },
    { "<leader>dw", function() require("dapui").toggle() end,                                                    desc = "Debug: Toggle DAP UI" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    require("mason-nvim-dap").setup({
      automatic_installation = true,
      ensure_installed = { "python", "codelldb", "node2", "js-debug-adapter" },
      handlers = {},
    })
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Chrome / Angular debugging via js-debug-adapter (vscode-js-debug)
    -- Install with :MasonInstall js-debug-adapter
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_debug_path, "${port}" },
      },
    }
    dap.configurations.typescript = {
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome (prompt for app port)",
        url = function()
          local port = vim.fn.input("App port [7070]: ")
          if port == "" then port = "7070" end
          return "http://localhost:" .. port
        end,
        webRoot = "${workspaceFolder}/apps/admin-ui",
        sourceMaps = true,
      },
    }
    dap.configurations.javascript = dap.configurations.typescript
  end,
}
