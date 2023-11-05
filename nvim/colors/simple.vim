let g:colors_name="simple"

lua package.loaded['lush_theme.simple'] = nil
lua require('lush')(require('lush_theme.simple'))
