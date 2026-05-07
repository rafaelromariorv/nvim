-- ========================================================================== --
--                               OPCIONES BÁSICAS                             --
-- ========================================================================== --
vim.g.mapleader = " "           -- Tecla líder: Espacio
vim.opt.number = true           -- Números de línea
vim.opt.relativenumber = true   -- Números relativos
vim.opt.mouse = 'a'             -- Ratón habilitado
vim.opt.ignorecase = true       
vim.opt.smartcase = true        
vim.opt.tabstop = 4             
vim.opt.shiftwidth = 4
vim.opt.expandtab = true        
vim.opt.termguicolors = true    

vim.opt.foldmethod = "indent"  
vim.opt.foldlevel = 99         
vim.opt.foldenable = true      
vim.opt.foldcolumn = "1"
-- ========================================================================== --
--                             GESTOR DE PLUGINS                              --
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Apariencia
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },

  -- Treesitter (Sintaxis)
  { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      -- Usamos pcall para evitar que Neovim lance el error si el plugin no cargó
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then
        ts.setup({
          ensure_installed = { "lua", "python", "javascript", "html", "css" },
          highlight = { enable = true },
        })
      end
    end
  },


  -- Terminal Integrada
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-j>]], -- Control + \
        shade_terminal = true,
        direction = 'horizontal',
      })
    end
  },

  -- Telescope (Buscador)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Git
  { "lewis6991/gitsigns.nvim", config = true },

  -- LSP y Autocompletado
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
})

-- ========================================================================== --
--                        CONFIGURACIÓN LSP (MODERNA)                         --
-- ========================================================================== --
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright" } 
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Nueva API de Neovim 0.11/0.12 para evitar el error de "deprecated"
vim.lsp.config('pyright', {
    install = true,
    options = {
        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace", -- Analiza todo el proyecto, no solo el archivo abierto
                }
            }
        }
    }
})
    
vim.lsp.enable('pyright')

-- ========================================================================== --
--                        CONFIGURACIÓN DE AUTOCOMPLETADO                     --
-- ========================================================================== --
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- ========================================================================== --
--                                  ATAJOS                                    --
-- ========================================================================== --
vim.cmd.colorscheme "catppuccin"

-- Explorador de archivos (Espacio + e)
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Telescope (Buscador de archivos y texto)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Atajos de LSP (Solo activos cuando hay un servidor funcionando)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)    -- Ir a definición
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)          -- Ver documentación
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Renombrar
  end,
})
