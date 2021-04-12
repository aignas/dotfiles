" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/home/aignas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/aignas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/aignas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/aignas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/aignas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["completion-nvim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/completion-nvim"
  },
  ["eskk.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/eskk.vim"
  },
  fzf = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/fzf.vim"
  },
  ["hive.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/hive.vim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/lush.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/markdown-preview.nvim"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/opt/packer.nvim"
  },
  ["rust.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/rust.vim"
  },
  ["starlark.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/starlark.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-abolish"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-fugitive"
  },
  ["vim-go"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-go"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vim-vsnip-integ"
  },
  vimtex = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vimtex"
  },
  vimwiki = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/packer.nvim/start/vimwiki"
  }
}

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
