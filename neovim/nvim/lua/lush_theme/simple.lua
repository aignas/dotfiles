local lush = require('lush')

-- base colors taken from https://xkcd.com/color/rgb/
local black       = lush.hsl('#121212')
local darkred     = lush.hsl('#840000')
local darkgreen   = lush.hsl('#15b01a')
local darkyellow  = lush.hsl('#d5b60a')
local darkblue    = lush.hsl('#00035b')
local darkmagenta = lush.hsl('#960056')
local darkcyan    = lush.hsl('#0a888a')
local gray        = lush.hsl('#c0c0c0')
local darkgray    = lush.hsl('#808080')
local red         = lush.hsl('#e50000')
local green       = lush.hsl('#01ff07')
local yellow      = lush.hsl('#ffff14')
local blue        = lush.hsl('#0343df')
local magenta     = lush.hsl('#c20078')
local cyan        = lush.hsl('#00ffff')
local white       = lush.hsl('#f0f0f0')


-- more colors for git diff
local lightgreen  = lush.hsl('#d1ffbd')
local lightred    = lush.hsl('#fd3c06')
local lightblue   = lush.hsl('#95d0fc')

local fg          = white
local bg          = lush.hsl('#3a3a3a')
local lightfg     = fg.darken(20)
local strongfg    = fg.lighten(30)
local strongbg    = bg.lighten(10)
local strongerbg  = bg.lighten(20)
local lightyellow = yellow.darken(40)


-- color options
if vim.o.background == 'light' then
    bg = white
    fg = black
    lightfg     = fg.lighten(20)
    strongfg    = fg.darken(20)
    strongbg    = bg.darken(10)
    strongerbg  = bg.darken(20)
    lightyellow = yellow.lighten(40)
else
    darkblue = blue
    blue = lightblue
end


return lush(function()
    return {
        Underlined { gui = "underline" },
        Bold       { gui = "bold" },
        Italic     { gui = "italic" },
        Undercurl  { gui = "undercurl" },

        ColorColumn  { fg = lightred, bg = strongbg },
        Conceal      { gui = "italic" },
        Cursor       { gui = "reverse"},
        lCursor      { Cursor },
        CursorIM     { Cursor },
        CursorColumn { Cursor },
        CursorLine   { },
        Directory    { gui = "bold" },
        DiffAdd      { bg = lightgreen, fg = black },
        DiffChange   { bg = strongerbg },
        DiffDelete   { bg = lightred },
        DiffText     { bg = lightyellow },
        NonText      { bg = bg, fg = darkgray },
        EndOfBuffer  { NonText },
        TermCursor   { },
        TermCursorNC { },
        ErrorMsg     { bg = fg, fg = darkred, gui = "bold,reverse" },
        VertSplit    { },
        Folded       { },
        FoldColumn   { },
        SignColumn   { },
        IncSearch    { bg = darkgreen, fg = fg },
        Substitute   { },
        LineNr       { },
        CursorLineNr { },
        MatchParen   { fg = darkgreen },
        ModeMsg      { fg = darkgreen },
        MsgArea      { },
        MsgSeparator { },
        MoreMsg      { fg = magenta },
        Normal       { bg = bg, fg = fg },
        NormalFloat  { },
        NormalNC     { },
        Pmenu        { bg = strongerbg },
        PmenuSel     { bg = strongbg, gui = "bold" },
        PmenuSbar    { bg = strongerbg },
        PmenuThumb   { bg = bg },
        Question     { },
        QuickFixLine { },
        Search       { bg = yellow, fg = black },
        SpecialKey   { },
        SpellBad     { Undercurl, sp = red },
        SpellCap     { Undercurl, sp = red },
        SpellLocal   { Undercurl, sp = red },
        SpellRare    { Undercurl, sp = red },
        StatusLine   { gui = "reverse" },
        StatusLineNC { gui = "underline" },
        TabLine      { gui = "underline" },
        TabLineFill  { TabLine },
        TabLineSel   { gui = "reverse" },
        Title        { gui = "bold" },
        Visual       { fg = darkcyan, gui = "reverse,bold" },
        VisualNOS    { },
        WarningMsg   { fg = red },
        Whitespace   { },
        WildMenu     { },

        -- de facto standard groups
        Constant       { gui = "bold" }, -- (preferred) any constant
        String         { Normal }, --   a string constant: "this is a string"
        Character      { }, --  a character constant: 'c', '\n'
        Number         { Constant }, --   a number constant: 234, 0xff
        Boolean        { }, --  a boolean constant: TRUE, false
        Float          { }, --    a floating point constant: 2.3e10

        Identifier     { gui = "bold" }, -- (preferred) any variable name
        Function       {}, -- function name (also: methods for classes)

        Statement      { fg = strongfg, gui = "bold" },
        Conditional    { Statement }, --  if, then, else, endif, switch, etc.
        Repeat         { Statement }, --   for, do, while, etc.
        Label          { Statement }, --    case, default, etc.
        Operator       { Statement }, -- "sizeof", "+", "*", etc.
        Keyword        { }, --  any other keyword
        -- Exception      { }, --  try, catch, throw

        -- PreProc        { }, -- (preferred) generic Preprocessor
        -- Include        { }, --  preprocessor #include
        -- Define         { }, --   preprocessor #define
        -- Macro          { }, --    same as Define
        -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.
        Error          { Undercurl, sp = "red" },

        Type           { gui = "bold" }, -- (preferred) int, long, char, etc.
        -- StorageClass   { }, -- static, register, volatile, etc.
        -- Structure      { }, --  struct, union, enum, etc.
        -- Typedef        { }, --  A typedef

        Special        { gui = "bold" }, -- (preferred) any special symbol
        -- SpecialChar    { }, --  special character in a constant
        -- Tag            { }, --    you can use CTRL-] on this
        Delimiter      { }, --  character that needs attention
        Comment        { fg = lightfg, gui = "italic" },
        SpecialComment { fg = lightfg, gui = "italic" },
        -- Debug          { }, --    debugging statements

        Ignore { },
        Todo { gui = "reverse", fg = "yellow" },

        -- These groups are for the native LSP client. Some other LSP clients may use
        -- these groups, or use their own. Consult your LSP client's documentation.

        LspDiagnosticsError               { bg = lightred }, -- used for "Error" diagnostic virtual text
        LspDiagnosticsErrorSign           { fg = red }, -- used for "Error" diagnostic signs in sign column
        LspDiagnosticsErrorFloating       { bg = lightred }, -- used for "Error" diagnostic messages in the diagnostics float
        -- LspDiagnosticsWarning             { }, -- used for "Warning" diagnostic virtual text
        -- LspDiagnosticsWarningSign         { }, -- used for "Warning" diagnostic signs in sign column
        -- LspDiagnosticsWarningFloating     { }, -- used for "Warning" diagnostic messages in the diagnostics float
        -- LspDiagnosticsInformation         { }, -- used for "Information" diagnostic virtual text
        -- LspDiagnosticsInformationSign     { }, -- used for "Information" signs in sign column
        -- LspDiagnosticsInformationFloating { }, -- used for "Information" diagnostic messages in the diagnostics float
        -- LspDiagnosticsHint                { }, -- used for "Hint" diagnostic virtual text
        -- LspDiagnosticsHintSign            { }, -- used for "Hint" diagnostic signs in sign column
        -- LspDiagnosticsHintFloating        { }, -- used for "Hint" diagnostic messages in the diagnostics float
        -- LspReferenceText                  { }, -- used for highlighting "text" references
        -- LspReferenceRead                  { }, -- used for highlighting "read" references
        -- LspReferenceWrite                 { }, -- used for highlighting "write" references

        -- These groups are for the neovim tree-sitter highlights.
        -- As of writing, tree-sitter support is a WIP, group names may change.
        -- By default, most of these groups link to an appropriate Vim group,
        -- TSError -> Error for example, so you do not have to define these unless
        -- you explicitly want to support Treesitter's improved syntax awareness.

        TSError              { Error }, -- For syntax/parser errors.
        -- TSPunctDelimiter     { }, -- For delimiters ie: `.`
        TSPunctBracket       { }, -- For brackets and parens.
        -- TSPunctSpecial       { }, -- For special punctutation that does not fall in the catagories before.
        TSConstant           { Constant }, -- For constants
        -- TSConstBuiltin       { }, -- For constant that are built in the language: `nil` in Lua.
        -- TSConstMacro         { }, -- For constants that are defined by macros: `NULL` in C.
        -- TSString             { }, -- For strings.
        -- TSStringRegex        { }, -- For regexes.
        -- TSStringEscape       { }, -- For escape characters within a string.
        -- TSCharacter          { }, -- For characters.
        -- TSNumber             { }, -- For integers.
        -- TSBoolean            { }, -- For booleans.
        -- TSFloat              { }, -- For floats.
        -- TSFunction           { }, -- For function (calls and definitions).
        -- TSFuncBuiltin        { }, -- For builtin functions: `table.insert` in Lua.
        -- TSFuncMacro          { }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
        -- TSParameter          { }, -- For parameters of a function.
        -- TSParameterReference { }, -- For references to parameters of a function.
        -- TSMethod             { }, -- For method calls and definitions.
        -- TSField              { }, -- For fields.
        -- TSProperty           { }, -- Same as `TSField`.
        -- TSConstructor        { }, -- For constructor calls and definitions: `{ }` in Lua, and Java constructors.
        -- TSConditional        { }, -- For keywords related to conditionnals.
        -- TSRepeat             { }, -- For keywords related to loops.
        -- TSLabel              { }, -- For labels: `label:` in C and `:label:` in Lua.
        -- TSOperator           { }, -- For any operator: `+`, but also `->` and `*` in C.
        -- TSKeyword            { }, -- For keywords that don't fall in previous categories.
        -- TSKeywordFunction    { }, -- For keywords used to define a fuction.
        -- TSException          { }, -- For exception related keywords.
        -- TSType               { }, -- For types.
        -- TSTypeBuiltin        { }, -- For builtin types (you guessed it, right ?).
        -- TSNamespace          { }, -- For identifiers referring to modules and namespaces.
        -- TSInclude            { }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
        -- TSAnnotation         { }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
        -- TSText               { }, -- For strings considered text in a markup language.
        -- TSStrong             { }, -- For text to be represented with strong.
        TSEmphasis           { gui = "italic" }, -- For text to be represented with emphasis.
        -- TSUnderline          { }, -- For text to be represented with an underline.
        -- TSTitle              { }, -- Text that is part of a title.
        -- TSLiteral            { }, -- Literal text.
        TSURI                { fg = blue, gui = "underline" }, -- Any URI like a link or email.
        -- TSVariable           { }, -- Any variable name that does not have another highlight.
        -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.
    }
end)
