-- Debugger config
-- https://github.com/mfussenegger/nvim-dap
local dap = {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- async io library needed to connect the UI to the debugger
    -- https://github.com/nvim-neotest/nvim-nio
    "nvim-neotest/nvim-nio",
  },
  event = "BufEnter",
  lazy = true,
  keys = {
    { "<leader>dd", "<cmd>DapViewToggle<CR>", mode = { "n", "v" }, desc = "Debugger: toggle the debugger UI" },
    { "<leader>dt", "<cmd>DapTerminate<CR>", mode = { "n", "v" }, desc = "Debugger: terminate debugger" },
    { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", mode = { "n", "v" }, desc = "Debugger: toggle breakpoint" },
    { "<leader>dc", "<cmd>DapContinue<CR>", mode = { "n", "v" }, desc = "Debugger: continue" },
    { "<leader>do", "<cmd>DapStepOver<CR>", mode = { "n", "v" }, desc = "Debugger: step over" },
    { "<leader>di", "<cmd>DapStepInto<CR>", mode = { "n", "v" }, desc = "Debugger: step into" },
    { "<leader>du", "<cmd>DapStepOut<CR>", mode = { "n", "v" }, desc = "Debugger: step up (out)" },
    { "<leader>de", "<cmd>DapToggleRepl<CR>", mode = { "n", "v" }, desc = "Debugger: toggle REPL" },
    { "<leader>dr", function() require("dap").run_to_cursor() end, mode = { "n", "v" }, desc = "Debugger: run to cursor" },
    { "<leader>dsu", function() require("dap").up() end, mode = { "n", "v" }, desc = "Debugger: stack Trace Up" },
    { "<leader>dsd", function() require("dap").down() end, mode = { "n", "v" }, desc = "Debugger: stack Trace Down" },
    -- maybe add an eval?,
  },

  config = function()
    local dap = require("dap")

    -- Language configuration
    -- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/

    -- Ruby
    dap.configurations.ruby = {
      { -- Ruby Binary exe
        type = "ruby",
        name = "Executable",
        request = "attach",
        port = 12345,
        localfs = true,
        program = function()
          -- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L54
          local program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/exe/", "file")
          return { "bundle", "exec", program }
        end,
      },
      { -- Ruby binary exe with arguments
        type = "ruby",
        name = "Executable with arguments",
        request = "attach",
        port = 12345,
        localfs = true,
        program = function()
          local program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/exe/", "file")
          local args = vim.fn.input("Arguments: ")
          local command = { "bundle", "exec" }
          command = vim.list_extend(command, { program })
          args = vim.split(args, " ")
          return vim.list_extend(command, args)
        end,
      },
    }
    -- Need to setup the project to use RSPEC not MINITEST in order to get tests working
    -- with DAP. Using minitest and `rake test` seems to fail.
    dap.adapters.ruby = function(callback, config)
      local args = { "--open", "--port=${port}", "-c", "--" }
      local final = vim.list_extend(args, config.program)
      callback {
        -- should take the args after -- from the config
        type = "server",
        port = "${port}",
        executable = {
          command = "rdbg",
          args = final,
        },
      }
    end

    -- Golang
    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "delve",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
      },
      -- Persistent arguments with dlv?
      -- {
      --   type = "delve",
      --   name = "Debug Run with Arguments",
      --   request = "launch",
      --
      --   _last_program = nil,
      --   _last_args = "",
      --   program = function(config)
      --     local default_program = config._last_program or vim.fn.getcwd() .. "/"
      --     local program = vim.fn.input("Path to Go program: ", default_program, "file")
      --     config._last_program = program
      --     return program
      --   end,
      --   args = function(config)
      --     local default_args = config._last_args or ""
      --     local prompt = "Arguments" .. (default_args ~= "" and " (current: " .. default_args .. ")" or "") .. ": "
      --     local args_input = vim.fn.input(prompt)
      --     if args_input == "" then
      --       args_input = default_args
      --     end
      --     config._last_args = args_input
      --     return vim.split(args_input, " ")
      --   end,
      -- }
    }

    dap.adapters.delve = function(callback, config)
      if config.mode == "remote" and config.request == "attach" then
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or "38697",
        })
      else
        callback({
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
            detached = vim.fn.has("win32") == 0,
          },
        })
      end
    end

  end,
}

-- A minal view for the debugger using DAP
-- https://github.com/igorlfs/nvim-dap-view
local dap_view = {
  "igorlfs/nvim-dap-view",
}

-- Show assigned values as virtual text
-- https://github.com/theHamsta/nvim-dap-virtual-text
local dap_virtual_text = {
  "theHamsta/nvim-dap-virtual-text",
  config = function()
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true, -- DapVirtualText(enable|disable|toggle) commands
      commented = false,
      only_first_definition = true,
      clear_on_continue = false,
      all_frames = false,
      virt_lines = false,
      virt_text_pos = "inline",
    })
  end,
}

return { dap, dap_view, dap_virtual_text }
