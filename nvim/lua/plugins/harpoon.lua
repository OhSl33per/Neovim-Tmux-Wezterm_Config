return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Custom telescope picker over the harpoon list
    local function toggle_telescope(harpoon_files)
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = finders.new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
    end

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add file" })

    vim.keymap.set("n", "<leader>hd", function()
      harpoon:list():remove()
    end, { desc = "Harpoon: Remove file" })

    vim.keymap.set("n", "<leader>hc", function()
      harpoon:list():clear()
    end, { desc = "Harpoon: Clear list" })

    vim.keymap.set("n", "<leader>he", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle quick menu" })

    vim.keymap.set("n", "<leader>hh", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Harpoon: Telescope picker" })

    vim.keymap.set("n", "<leader>hp", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Prev file" })

    vim.keymap.set("n", "<leader>hn", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Next file" })

    for i = 1, 4 do
      vim.keymap.set("n", "<leader>h" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Harpoon: Select file " .. i })
    end
  end,
}
