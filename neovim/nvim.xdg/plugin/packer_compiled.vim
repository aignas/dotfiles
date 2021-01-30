" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif
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

_G.packer_plugins = {
  ["LanguageClient-neovim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/LanguageClient-neovim"
  },
  ["completion-nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/completion-nvim"
  },
  ["eskk.vim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/eskk.vim"
  },
  fzf = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/fzf.vim"
  },
  ["hive.vim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/hive.vim"
  },
  ["lush.nvim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/lush.nvim"
  },
  minpac = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/minpac"
  },
  neoformat = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/neoformat"
  },
  ["nvim-lspconfig"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/opt/packer.nvim"
  },
  ["rust.vim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/rust.vim"
  },
  ["starlark.vim"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/starlark.vim"
  },
  ["vim-abolish"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-abolish"
  },
  ["vim-fugitive"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-fugitive"
  },
  ["vim-go"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-go"
  },
  ["vim-markdown-composer"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-markdown-composer"
  },
  ["vim-minisnip"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-minisnip"
  },
  ["vim-repeat"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vim-unimpaired"
  },
  vimtex = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vimtex"
  },
  vimwiki = {
    loaded = true,
    only_sequence = true,
    only_setup = false,
    path = "/home/aignas/.config/nvim/pack/minpac/start/vimwiki"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = packer_plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

local packer_load = nil
local function handle_after(name, before)
  local plugin = packer_plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    packer_load({name}, {})
  end
end

packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not packer_plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if packer_plugins[name].commands then
      for _, cmd in ipairs(packer_plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if packer_plugins[name].keys then
      for _, key in ipairs(packer_plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not packer_plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      if packer_plugins[name].config then
        for _i, config_line in ipairs(packer_plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if packer_plugins[name].after then
        for _, after_name in ipairs(packer_plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      packer_plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count ~= 0 and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    local escaped_keys = vim.api.nvim_replace_termcodes(cause.keys .. extra, true, true, true)
    vim.api.nvim_feedkeys(escaped_keys, 'm', true)
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

_packer_load_wrapper = function(names, cause)
  success, err_msg = pcall(packer_load, names, cause)
  if not success then
    vim.cmd('echohl ErrorMsg')
    vim.cmd('echomsg "Error in packer_compiled: ' .. vim.fn.escape(err_msg, '"') .. '"')
    vim.cmd('echomsg "Please check your config for correctness"')
    vim.cmd('echohl None')
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Post-load configuration
-- Conditional loads
-- Load plugins in order defined by `after`
END

function! s:load(names, cause) abort
  call luaeval('_packer_load_wrapper(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
  " Function lazy-loads
augroup END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
