local lush = require('lush')

return lush(function()
    -- base colors taken from https://xkcd.com/color/rgb/
    black       = lush.hsl('#000000')
    darkred     = lush.hsl('#840000')
    darkgreen   = lush.hsl('#15b01a')
    darkyellow  = lush.hsl('#d5b60a')
    darkblue    = lush.hsl('#00035b')
    darkmagenta = lush.hsl('#960056')
    darkcyan    = lush.hsl('#0a888a')
    gray        = lush.hsl('#c0c0c0')
    darkgray    = lush.hsl('#808080')
    red         = lush.hsl('#e50000')
    green       = lush.hsl('#01ff07')
    yellow      = lush.hsl('#ffff14')
    blue        = lush.hsl('#0343df')
    magenta     = lush.hsl('#c20078')
    cyan        = lush.hsl('#00ffff')
    white       = lush.hsl('#ffffff')

    -- more colors for git diff
    lightgreen  = lush.hsl('#d1ffbd')
    lightred    = lush.hsl('#fd3c06')
    lightgray   = gray.lighten(50)
    lightyellow = yellow.lighten(40)

    return {
        ColorColumn  { fg = "darkred" },
        Conceal      { gui = "italic" },
        Cursor       { },
        lCursor      { Cursor },
        CursorIM     { Cursor },
        CursorColumn { Cursor },
        CursorLine   { },
        Directory    { gui = "bold" },
        DiffAdd      { bg = lightgreen, },
        DiffChange   { bg = lightgray },
        DiffDelete   { bg = lightred },
        DiffText     { bg = lightyellow },
        NonText      { fg = darkgray },
        EndOfBuffer  { NonText },
        TermCursor   { },
        TermCursorNC { },
        ErrorMsg     { bg = white, fg = red, gui = "reverse" },
        VertSplit    { },
        Folded       { },
        FoldColumn   { },
        SignColumn   { },
        IncSearch    { bg = green, fg = black },
        Substitute   { },
        LineNr       { },
        CursorLineNr { },
        MatchParen   { fg = darkgreen },
        ModeMsg      { fg = darkgreen },
        MsgArea      { },
        MsgSeparator { },
        MoreMsg      { fg = magenta },
        Normal       { },
        NormalFloat  { },
        NormalNC     { },
        Pmenu        { },
        PmenuSel     { },
        PmenuSbar    { },
        PmenuThumb   { },
        Question     { },
        QuickFixLine { },
        Search       { bg = yellow, fg = black },
        SpecialKey   { },
        SpellBad     { bg = black.lighten(93) },
        SpellCap     { bg = black.lighten(93) },
        SpellLocal   { bg = black.lighten(93) },
        SpellRare    { bg = black.lighten(93) },
        StatusLine   { gui = "reverse" },
        StatusLineNC { gui = "underline" },
        TabLine      { gui = "underline" },
        TabLineFill  { TabLine },
        TabLineSel   { gui = "reverse" },
        Title        { },
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

        Identifier     { gui = "underline,bold" }, -- (preferred) any variable name
        Function       {}, -- function name (also: methods for classes)

        Statement      { gui = "bold" },
        -- Conditional    { }, --  if, then, else, endif, switch, etc.
        -- Repeat         { }, --   for, do, while, etc.
        -- Label          { }, --    case, default, etc.
        -- Operator       { }, -- "sizeof", "+", "*", etc.
        Keyword        { }, --  any other keyword
        -- Exception      { }, --  try, catch, throw

        -- PreProc        { }, -- (preferred) generic Preprocessor
        -- Include        { }, --  preprocessor #include
        -- Define         { }, --   preprocessor #define
        -- Macro          { }, --    same as Define
        -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.
        Error          { ErrorMsg },

        Type           { gui = "bold" }, -- (preferred) int, long, char, etc.
        -- StorageClass   { }, -- static, register, volatile, etc.
        -- Structure      { }, --  struct, union, enum, etc.
        -- Typedef        { }, --  A typedef

        Special        { gui = "bold" }, -- (preferred) any special symbol
        -- SpecialChar    { }, --  special character in a constant
        -- Tag            { }, --    you can use CTRL-] on this
        Delimiter      { }, --  character that needs attention
        Comment        { fg = black.lighten(30), gui = "italic" },
        -- SpecialComment { }, -- special things inside a comment
        -- Debug          { }, --    debugging statements

        Underlined { gui = "underline" },
        Bold       { gui = "bold" },
        Italic     { gui = "italic" },

        Ignore { },
        Todo { gui = "reverse" },

        -- These groups are for the native LSP client. Some other LSP clients may use
        -- these groups, or use their own. Consult your LSP client's documentation.

        LspDiagnosticsError               { bg = lightred }, -- used for "Error" diagnostic virtual text
        LspDiagnosticsErrorSign           { fg = darkred }, -- used for "Error" diagnostic signs in sign column
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

        TSError              { bg = lightred.lighten(80) }, -- For syntax/parser errors.
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
        -- TSEmphasis           { }, -- For text to be represented with emphasis.
        -- TSUnderline          { }, -- For text to be represented with an underline.
        -- TSTitle              { }, -- Text that is part of a title.
        -- TSLiteral            { }, -- Literal text.
        TSURI                { fg = blue, gui = "underline" }, -- Any URI like a link or email.
        -- TSVariable           { }, -- Any variable name that does not have another highlight.
        -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.
    }
end)
