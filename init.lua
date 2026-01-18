-- ===========================
-- Performance
-- ===========================
vim.loader.enable()

-- ===========================
-- Core Settings
-- ===========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Keep terminal background (transparent)
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalFloat guibg=NONE ctermbg=NONE]])

-- Indentation (Python standard)
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- UI
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.guicursor = ""   -- solid block cursor

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Speed
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"

-- ===========================
-- Lazy.nvim
-- ===========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ===========================
  -- Gruvbox Theme
  -- ===========================
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
        italic = {
            strings = false,
            comments = false,
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ===========================
  -- LSP + Autocomplete
  -- ===========================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup_handlers({
        function(server)
          require("lspconfig")[server].setup({
            capabilities = capabilities,
          })
        end,
      })

      -- Autocomplete
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- ===========================
  -- Auto Pairs
  -- ===========================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

})

-- ===========================
-- Python: format on save (Black)
-- ===========================
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- ===========================
-- Python run shortcut
-- ===========================
vim.keymap.set("n", "<leader>r", ":w<CR>:!python3 %<CR>")

-- ===========================
-- Better copy/paste shortcuts
-- ===========================
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')

