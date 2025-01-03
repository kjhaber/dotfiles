local config = {
  {
    "robitx/gp.nvim",
    lazy = true,
    cmd = {
      "GpAppend",
      "GpChatNew",
      "GpChatFinder",
      "GpChatDelete",
      "GpChatRespond",
      "GpChatToggle",
      "GpVnew",
      "GpNew",
      "GpRewrite",
      "GpStop",
    },

    config = function()
      local start_local_llm_server = function()
        pcall(io.popen, "tmuxinator start ollama")
      end

      -- start ollama in tmux session when plugin is lazy-loaded
      start_local_llm_server()

      require("gp").setup({
        providers = {
          openai = {},
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
            secret = "dummy_secret",
          },
        },
        agents = {
          {
            provider = "ollama",
            name = "ChatOllamaMistral",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "mistral",
              temperature = 0.6,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.",
          },
          {
            provider = "ollama",
            name = "CommandOllamaMistral",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "mistral",
              temperature = 0.4,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
        },
        whisper = {
          disable = true,
        },
        image = {
          disable = true,
        },
        default_chat_agent = "ChatOllamaMistral",
        default_command_agent = "CommandOllamaMistral",
        chat_template = require("gp.defaults").short_chat_template,
        -- toggle_target = "popup",
        toggle_target = "vsplit",
        chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<leader>a<cr>" },
        chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<leader>ad" },
        chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<leader>ax" },
        chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<leader>an" },
      })

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  },
}

-- Define leader key mappings outside of config due to lazy loading
local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "LLM prompt " .. desc,
  }
end

vim.keymap.set("n", "<leader>aa", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat Popup"))
vim.keymap.set("v", "<leader>aa", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat Popup"))

vim.keymap.set("n", "<leader>an", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat"))
vim.keymap.set("v", "<leader>an", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual New Chat"))

vim.keymap.set("n", "<leader>a>", ":%GpChatNew vsplit<cr>", keymapOptions("New Chat"))
vim.keymap.set("v", "<leader>a>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual New Chat"))

vim.keymap.set("n", "<leader>a<cr>", "<cmd>GpChatRespond<cr>", keymapOptions("Chat Request Response"))
vim.keymap.set("n", "<leader>ax", "<cmd>GpStop<cr>", keymapOptions("Stop"))
vim.keymap.set("n", "<leader>a.", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))
vim.keymap.set("n", "<leader>ad", "<cmd>GpChatDelete<cr>", keymapOptions("Delete Chat"))

vim.keymap.set("n", "<leader>a+", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set("v", "<leader>a+", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))

vim.keymap.set("n", "<leader>ar", ":%GpRewrite<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set("v", "<leader>ar", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))

vim.keymap.set("n", "<leader>a<bar>", ":%GpVnew<cr>", keymapOptions("Command output in vsplit"))
vim.keymap.set("v", "<leader>a<bar>", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual Command output in vsplit"))

return config
