" Vim color file - custom
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "custom"

"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
hi Normal guifg=#ffffff guibg=#000000 guisp=#000000 gui=NONE ctermfg=252 ctermbg=None cterm=NONE
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi EnumerationValue -- no settings --
"hi Union -- no settings --
"hi Question -- no settings --
"hi EnumerationName -- no settings --
"hi DefinedName -- no settings --
"hi LocalVariable -- no settings --
"hi CTagsClass -- no settings --
"hi clear -- no settings --
hi IncSearch guifg=#405158 guibg=#BD9800 guisp=#BD9800 gui=NONE ctermfg=240 ctermbg=1 cterm=NONE
hi WildMenu guifg=NONE guibg=#A1A6A8 guisp=#A1A6A8 gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE
hi SignColumn guifg=#405158 guibg=#536991 guisp=#536991 gui=NONE ctermfg=240 ctermbg=60 cterm=NONE
hi SpecialComment guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Typedef guifg=#738fc7 guibg=NONE guisp=NONE gui=bold ctermfg=110 ctermbg=NONE cterm=bold
hi Title guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=bold ctermfg=189 ctermbg=235 cterm=bold
hi Folded guifg=#405158 guibg=#A1A6A8 guisp=#A1A6A8 gui=italic ctermfg=240 ctermbg=248 cterm=NONE
hi PreCondit guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Include guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=12 ctermbg=NONE cterm=NONE
hi TabLineSel guifg=#405158 guibg=#BD9800 guisp=#BD9800 gui=bold ctermfg=240 ctermbg=1 cterm=bold
hi StatusLineNC guifg=#405158 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=240 ctermbg=66 cterm=bold
hi NonText guifg=#8ca0a6 guibg=NONE guisp=NONE gui=italic ctermfg=109 ctermbg=NONE cterm=NONE
hi DiffText guifg=NONE guibg=#492224 guisp=#492224 gui=NONE ctermfg=NONE ctermbg=52 cterm=NONE
hi ErrorMsg guifg=#d6dddf guibg=#912C00 guisp=#912C00 gui=NONE ctermfg=152 ctermbg=88 cterm=NONE
hi Debug guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#848688 guisp=#848688 gui=NONE ctermfg=NONE ctermbg=102 cterm=NONE
hi Identifier guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=11 ctermbg=NONE cterm=NONE
hi Conditional guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi StorageClass guifg=#738fc7 guibg=NONE guisp=NONE gui=bold ctermfg=110 ctermbg=NONE cterm=bold
hi Todo guifg=#f9f9ff guibg=#BD9800 guisp=#BD9800 gui=NONE ctermfg=10 ctermbg=8 cterm=NONE
hi Special guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi LineNr guifg=#00aeff guibg=NONE guisp=NONE gui=NONE ctermfg=6 ctermbg=NONE cterm=NONE
hi StatusLine guifg=#405158 guibg=#BD9800 guisp=#BD9800 gui=bold ctermfg=240 ctermbg=1 cterm=bold
hi Label guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=220 ctermbg=NONE cterm=bold
hi PMenuSel guifg=#405158 guibg=#BD9800 guisp=#BD9800 gui=NONE ctermfg=240 ctermbg=1 cterm=NONE
hi Search guifg=#405158 guibg=#BD9800 guisp=#BD9800 gui=NONE ctermfg=15 ctermbg=4 cterm=NONE
hi Delimiter guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Statement guifg=#ffff00 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi SpellRare guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi Comment guifg=#8ca0a6 guibg=NONE guisp=NONE gui=italic ctermfg=10 ctermbg=NONE cterm=NONE
hi Character guifg=#d6dddf guibg=NONE guisp=NONE gui=NONE ctermfg=9 ctermbg=NONE cterm=NONE
hi Float guifg=#d6dddf guibg=NONE guisp=NONE gui=NONE ctermfg=152 ctermbg=NONE cterm=NONE
hi Number guifg=#00ff00 guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Boolean guifg=#d6dddf guibg=NONE guisp=NONE gui=NONE ctermfg=11 ctermbg=NONE cterm=NONE
hi Operator guifg=#ffff00 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi CursorLine guifg=NONE guibg=#222E30 guisp=#222E30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi TabLineFill guifg=#405158 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=240 ctermbg=66 cterm=bold
hi WarningMsg guifg=#d6dddf guibg=#912C00 guisp=#912C00 gui=NONE ctermfg=152 ctermbg=88 cterm=NONE
hi VisualNOS guifg=#405158 guibg=#F9F9FF guisp=#F9F9FF gui=underline ctermfg=240 ctermbg=189 cterm=underline
hi DiffDelete guifg=NONE guibg=#192224 guisp=#192224 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE
hi ModeMsg guifg=#ffffff guibg=#192224 guisp=#192224 gui=bold ctermfg=15 ctermbg=black cterm=bold
hi CursorColumn guifg=NONE guibg=#222E30 guisp=#222E30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi Define guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=11 ctermbg=NONE cterm=NONE
hi Function guifg=#00ffff guibg=NONE guisp=NONE gui=bold ctermfg=39 ctermbg=NONE cterm=NONE
hi FoldColumn guifg=#405158 guibg=#A1A6A8 guisp=#A1A6A8 gui=italic ctermfg=240 ctermbg=248 cterm=NONE
hi PreProc guifg=#ff6060 guibg=NONE guisp=NONE gui=NONE ctermfg=9 ctermbg=NONE cterm=NONE
hi Visual guifg=#405158 guibg=#F9F9FF guisp=#F9F9FF gui=NONE ctermfg=15 ctermbg=12 cterm=NONE
hi MoreMsg guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=220 ctermbg=NONE cterm=bold
hi SpellCap guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi VertSplit guifg=#405158 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=240 ctermbg=66 cterm=bold
hi Exception guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi Keyword guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi Type guifg=#738fc7 guibg=NONE guisp=NONE gui=bold ctermfg=110 ctermbg=NONE cterm=bold
hi DiffChange guifg=NONE guibg=#492224 guisp=#492224 gui=NONE ctermfg=NONE ctermbg=52 cterm=NONE
hi Cursor guifg=#405158 guibg=#F9F9F9 guisp=#F9F9F9 gui=NONE ctermfg=240 ctermbg=15 cterm=NONE
hi SpellLocal guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi Error guifg=#d6dddf guibg=#912C00 guisp=#912C00 gui=NONE ctermfg=152 ctermbg=88 cterm=NONE
hi PMenu guifg=#405158 guibg=#5E6C70 guisp=#5E6C70 gui=NONE ctermfg=240 ctermbg=66 cterm=NONE
hi SpecialKey guifg=#8ca0a6 guibg=NONE guisp=NONE gui=italic ctermfg=109 ctermbg=NONE cterm=NONE
hi Constant guifg=#d6dddf guibg=NONE guisp=NONE gui=NONE ctermfg=152 ctermbg=NONE cterm=NONE
hi Tag guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi String guifg=#ff40ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#a4a6a8 guisp=#a4a6a8 gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE
hi MatchParen guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=220 ctermbg=NONE cterm=bold
hi Repeat guifg=#f0c000 guibg=NONE guisp=NONE gui=bold ctermfg=11 ctermbg=NONE cterm=bold
hi SpellBad guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi Directory guifg=#738fc7 guibg=NONE guisp=NONE gui=bold ctermfg=110 ctermbg=NONE cterm=bold
hi Structure guifg=#738fc7 guibg=NONE guisp=NONE gui=bold ctermfg=110 ctermbg=NONE cterm=bold
hi Macro guifg=#f0c000 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Underlined guifg=#f9f9ff guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi DiffAdd guifg=NONE guibg=#193224 guisp=#193224 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi TabLine guifg=#405158 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=240 ctermbg=66 cterm=bold
hi cursorim guifg=#405158 guibg=#536991 guisp=#536991 gui=NONE ctermfg=240 ctermbg=60 cterm=NONE
