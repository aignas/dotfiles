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
    path = "/home/aignas/.config/nvim/pack/minpac/start/completion-nvim"
  },
  ["eskk.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/eskk.vim"
  },
  fzf = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/fzf.vim"
  },
  ["hive.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/hive.vim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/lush.nvim"
  },
  neoformat = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/neoformat"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/packer.nvim"
  },
  ["rust.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/rust.vim"
  },
  ["starlark.vim"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/starlark.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-abolish"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-fugitive"
  },
  ["vim-go"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-go"
  },
  ["vim-markdown-composer"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-markdown-composer"
  },
  ["vim-minisnip"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-minisnip"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-unimpaired"
  },
  vimtex = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vimtex"
  },
  vimwiki = {
    loaded = true,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vimwiki"
  }
}

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
