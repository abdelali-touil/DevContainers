#!/bin/sh
set -e

USER_NAME=devops
USER_HOME=/home/$USER_NAME

if ! id -u "$USER_NAME" >/dev/null 2>&1; then
    adduser -D -h "$USER_HOME" -s /bin/bash "$USER_NAME"
fi

# Create necessary directories for Neovim configuration
mkdir -p "$USER_HOME/.config/nvim/lua/plugins"
mkdir -p "$USER_HOME/.local/share/nvim"
mkdir -p "$USER_HOME/.local/state/nvim"
mkdir -p "$USER_HOME/.cache/nvim"

# Define environment variables for Neovim
chown -R "$USER_NAME:$USER_NAME" "$USER_HOME/.config" "$USER_HOME/.local" "$USER_HOME/.cache"

# Create the init.lua file
cat > "$USER_HOME/.config/nvim/init.lua" << 'NVIMEOF'
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

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.mapleader = " "

-- Plugins sont définis ici
require("lazy").setup({
  { "folke/tokyonight.nvim", priority = 1000, config = function()
      vim.cmd.colorscheme "tokyonight-night"
    end
  },

  -- Treesitter : Utilise un fichier de configuration externe chargé après l'installation du plugin
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("plugins.treesitter")
    end
  },

  { "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer", "L3MON4D3/LuaSnip" } },

  { "hrsh7th/nvim-cmp", config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "buffer" } }),
      })
    end
  },

  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      require("telescope").setup()
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
      vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {})
    end
  },

  { "nvim-tree/nvim-tree.lua", config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true })
    end
  },

  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("lualine").setup()
    end
  },

  { "tpope/vim-fugitive" },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },
  { "folke/which-key.nvim", config = function() require("which-key").setup() end },
})
NVIMEOF

# Create the Treesitter configuration file
cat > "$USER_HOME/.config/nvim/lua/plugins/treesitter.lua" << 'TREESITTEREOF'
-- Ce fichier ne sera chargé que si nvim-treesitter a été correctement installé par Lazy.nvim
if pcall(require, "nvim-treesitter.configs") then
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "bash", "yaml", "json", "python", "go", "rust", "dockerfile" },
        highlight = { enable = true },
        indent = { enable = true },
    })
else
    print("WARNING: nvim-treesitter module not found, skipping configuration.")
end
TREESITTEREOF

# Download plugins using Lazy.nvim (Phase 1)
echo "--- Téléchargement des plugins Lazy.nvim (Phase 1) ---"
sudo -u "$USER_NAME" nvim --headless -c 'Lazy sync' -c 'quitall'

# Install Treesitter parsers (Phase 2)
echo "--- Installation des parsers Treesitter (Phase 2) ---"
sudo -u "$USER_NAME" nvim --headless \
  -c 'TSUpdateSync' \
  -c 'quitall'

echo "=== Neovim configuration completed on Alpine (FIXED) ==="