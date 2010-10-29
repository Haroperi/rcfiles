" Last Change: 2009/10/25 22:20:26.
scriptencoding utf-8
syntax on
filetype plugin on
filetype indent on
augroup vimrc
autocmd!
augroup end

" カーソルキーを殺す {{{1
"map <Left> <Esc>
"map <Down> <Esc>
"map <Up> <Esc>
"map <Right> <Esc>
"imap <Left> <Esc>
"imap <Down> <Esc>
"imap <Up> <Esc>
"imap <Right> <Esc>
" }}}1

" set {{{1
set ttimeoutlen=10
set tabpagemax=100
set modelines=5
set nocompatible
set diffopt=filler,icase,iwhite
set noerrorbells
set noexpandtab
set noinsertmode
set visualbell
set backspace=indent,start,eol
set fileformats=unix,dos,mac
set helplang=en,ja
set nrformats-=octal
set nrformats+=alpha
set runtimepath+=${HOME}/.vim/chalice
set runtimepath+=${HOME}/.vim/hatena
if exists('&ambiwidth')
	set ambiwidth=double
endif
" }}}1

" 外観 {{{1
set cmdheight=1
"set cursorline
set eadirection=both
set equalalways
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:-
set laststatus=2
set list
set listchars=tab:»\ ,trail:_,precedes:«,extends:»
set number
set ruler
set shortmess=at
set showbreak=>>
set showcmd
set showmode
set statusline=%n:%<\ %f%a\ %m%r%h%w%y[%{&fenc!=''?&fenc:&enc}][%{&ff}]%=pos:%l,%c%V\ %obytes\ 0x%06.6B\ %03.3p%%
set notitle
set nowrap
" set display=uhex
" }}}1

" タブ/バッファ {{{1
" set showtabline=2 " タブを表示するか
set hidden
set nosplitbelow
set splitright
" }}}1

" 検索 {{{1
set hlsearch
set ignorecase
set incsearch
set matchpairs+=<:>
set matchtime=3
set report=0
set showmatch
set smartcase
set wrapscan
" }}}1

" 補完 {{{1
"set complete=.,w,b,u,U,t,i,d,k
set completeopt=menu,longest,preview
set tags=~/.vim/systags,./tags,../tags,./*/tags,~/.tags/*/tags
set wildmenu
set wildmode=list:longest
if exists( "+omnifunc" )
	if &omnifunc == ""
		setlocal omnifunc=syntaxcomplete#Complete
	endif
endif
" }}}1

" インデント {{{1
set autoindent
set cinoptions=:0g0
set copyindent
set smartindent
set formatoptions+=nM
" }}}1

" ファイルブラウズ {{{1
set browsedir=current
let g:netrw_liststyle=1
let g:netrw_http_cmd="wget -q -O"
" }}}1

" 自動文字コード判別 {{{1
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=iso-2022-jp,utf-8,euc-jp,sjis,cp932
set termencoding=utf-8
if has('autocmd')
	autocmd vimrc BufReadPost * call AU_ReCheck_FENC()
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
endif
" }}}1

" 自動バックアップ {{{1
set backup
set backupdir=~/.backup/vim
set viewdir=~/.backup/view
if has( "autocmd" )
	autocmd vimrc BufWritePre * call UpdateBackupFile()
	function! UpdateBackupFile()
		let dir = strftime("~/.vim/backup/%Y/%m/%d", localtime())
		if !isdirectory(dir)
			let retval = system("mkdir -p ".dir)
			let retval = system("chown goth:staff ".dir)
		endif
		exe "set backupdir=".dir
		unlet dir
		let ext = strftime("%H_%M_%S", localtime())
		exe "set backupext=.".ext
		unlet ext
	endfunction
endif
" }}}1

" バイナリエディタ {{{1
augroup Binary
	autocmd!
	autocmd BufReadPre  *.bin let &binary = 1
	autocmd BufReadPost * call BinReadPost()
	autocmd StdinReadPost * call BinReadPost()
	autocmd BufWritePre * call BinWritePre()
	autocmd BufWritePost * call BinWritePost()
	"autocmd CursorHold * call BinReHex()
	" 関数群 {{{2
	function! BinReadPost()
		if &binary
			silent %!xxd
			set ft=gothicHex
		endif
	endfunction
	function! BinWritePre()
		if &binary
			let s:saved_pos = getpos( '.' )
			silent %!hex2bin
		endif
	endfunction
	function! BinWritePost()
		if &binary
			let s:modified = &modified
			silent %!xxd
			call setpos( '.', s:saved_pos )
			let &modified = s:modified
		endif
	endfunction
	" function! BinReHex()
	" 	if &binary
	" 		let s:saved_pos = getpos( '.' )
	" 		let s:modified = &modified
	" 		silent %!hex2bin
	" 		silent %!xxd
	" 		call setpos( '.', s:saved_pos )
	" 		let &modified = s:modified
	" 	endif
	" endfunction
	" }}}2
augroup END
" }}}1

" mapping {{{1
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap j gj
nmap k gk

nmap <ESC><ESC> :nohlsearch<CR><ESC>

map \mm :set aw \| make \| set noaw<CR>
map \mn :set aw \| make clean \| set noaw<CR>

map [H <Home>
map! [H <Home>
map [F <End>
map! [F <End>

nmap <C-H> :tabprev<CR>
nmap <C-L> :tabnext<CR>

nmap gc `[v`]
vmap gc :<C-u>normal gc<Enter>
omap gc :<C-u>normal gc<Enter>
" }}}1

" Fold関係 {{{1
set foldlevel=15
set foldmethod=marker
set foldtext=MyFoldText()
set foldcolumn=3
function! MyFoldText()
	let indent = substitute( v:folddashes, '-', '>', 'g' )
	let indent = substitute( indent . '        ', '\(.\{8\}\).*', '\1', '' )
	let line = substitute( getline( v:foldstart ), '{{{\d\=', '', 'g' ) "}}}
	return indent.' '.line
endfunction
" }}}1

" Color関係 {{{1
highlight Comment ctermfg=5
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4
highlight Folded ctermbg=darkgray ctermfg=white
highlight FoldColumn ctermbg=0
highlight StatusLineNC ctermfg=black ctermbg=black
highlight NonText ctermfg=black
highlight SpecialKey ctermfg=darkgray
highlight CursorLine NONE cterm=underline
highlight ZenkakuSpace cterm=underline ctermbg=white ctermfg=blue
autocmd vimrc VimEnter,WinEnter * match ZenkakuSpace /　/

if has( "autocmd" )
	autocmd vimrc filetype actionscript set dictionary+=~/.vim/dict/actionscript3.dict
	autocmd vimrc filetype mplayerconf set dictionary+=~/.vim/dict/mplayerconf
endif

" xterm-256color関係 {{{2
let s:colourcube_values = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]
let s:base16_values = 	[ [ 0x00, 0x00, 0x00 ]
\			, [ 0xCD, 0x00, 0x00 ]
\			, [ 0x00, 0xCD, 0x00 ]
\			, [ 0xCD, 0xCD, 0x00 ]
\			, [ 0x00, 0x00, 0xEE ]
\			, [ 0xCD, 0x00, 0xCD ]
\			, [ 0x00, 0xCD, 0xCD ]
\			, [ 0xE5, 0xE5, 0xE5 ]
\			, [ 0x7F, 0x7F, 0x7F ]
\			, [ 0xFF, 0x00, 0x00 ]
\			, [ 0x00, 0xFF, 0x00 ]
\			, [ 0xFF, 0xFF, 0x00 ]
\			, [ 0x5C, 0x5C, 0xFF ]
\			, [ 0xFF, 0x00, 0xFF ]
\			, [ 0x00, 0xFF, 0xFF ]
\			, [ 0xFF, 0xFF, 0xFF ] ]
function! s:abs( n )
	if a:n > 0
		return a:n
	else
		return (0 - a:n)
	end
endfunction

function! ESC2RGB( esc )
	let esc = a:esc
	if esc < 16
		return s:base16_values[a:esc]
	endif
	let esc = esc - 16
	if esc < 216
		let r = s:colourcube_values[(esc / 36) % 6]
		let g = s:colourcube_values[(esc / 6) % 6]
		let b = s:colourcube_values[esc % 6]
		return [r,g,b]
	endif
	let esc = esc - 216
	if esc < 24
		let y = 8 + esc * 10
		return [y,y,y]
	endif
	let esc = esc - 24
	echom "unknown esc code: " (esc+256)
	return
endfunction

let s:esc2rgbDict = {}
for i in range( 0, &t_Co - 1 )
	let s:esc2rgbDict[i] = ESC2RGB(i)
endfor

function! RGB2ESC( rgb )
	let rgb = a:rgb
	if rgb[0] ==? "#"
		let rgb = rgb[1:]
	endif
	if strlen( rgb ) == 6
		let r = str2nr(rgb[0] . rgb[1], 16 )
		let g = str2nr(rgb[2] . rgb[3], 16 )
		let b = str2nr(rgb[4] . rgb[5], 16 )
	elseif strlen( rgb ) == 3
		let r = str2nr(rgb[0] . rgb[0], 16 )
		let g = str2nr(rgb[1] . rgb[1], 16 )
		let b = str2nr(rgb[2] . rgb[2], 16 )
	else
		echom "format error for: " . a:rgb
		return
	endif

	let mindiff = 20 " 妥協
	let diff = 0xff * 3
	let index = 0
	for i in range( 0, &t_Co - 1 )
		let d	= s:abs( s:esc2rgbDict[i][0] - r )
\			+ s:abs( s:esc2rgbDict[i][1] - g )
\			+ s:abs( s:esc2rgbDict[i][2] - b )
		if d < mindiff
			return i
		elseif d < diff
			let diff = d
			let index = i
		endif
	endfor
	return index
endfunction
" }}}2

" }}}1

" errorformat関係 {{{1
if has( "autocmd" )
	autocmd vimrc filetype prolog set errorformat^=ERROR:\ %f:%l:%c:\ %m
endif
set errorformat+=%D%*\\a[%*\\d]:\ ディレクトリ\ `%f'\ に入ります
set errorformat+=%X%*\\a[%*\\d]:\ ディレクトリ\ `%f'\ から出ます
" }}}1

" いろいろ {{{1
if has( "autocmd" )
	autocmd vimrc BufReadPost * if 0 < line("'\"") && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
" }}}1

" plugin設定 {{{1
" autodate {{{2
let autodate_format="%Y/%m/%d %H:%M:%S"
" }}}2
" haskellmode {{{2
autocmd vimrc Bufenter *.hs compiler ghc
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"
let b:ghc_staticoptions = "-Wall"
" }}}2
" Align {{{2
let g:Align_xstrlen = 3
" }}}2
" AutoComplPop {{{2
let g:AutoComplPop_NotEnableAtStartup = 1
" let g:AutoComplPop_BehaviorKeywordLength = 2
" let g:AutoComplPop_CompleteOption=".,w,b,u,U,t,i,d,k"
" }}}2
" ShowMarks {{{2
let g:showmarks_textlower="\t "
let g:showmarks_textupper="\t "
let g:showmarks_textother="\t "
let g:showmarks_hlline_upper=1
highlight ShowMarksHLl ctermfg=white
highlight ShowMarksHLu ctermfg=white
highlight ShowMarksHLo ctermfg=yellow
highlight ShowMarksHLm ctermfg=red
" }}}2
" Chalice {{{2
let g:chalice_startupflags="aa=no,bookmark"
let g:chalice_previewflags="autoclose"
let g:chalice_titlestring=""
" }}}2
" vimwiki {{{2
let g:vimwiki_list=[{'path_html': '~/.vim/vimwiki/html/', 'html_footer': '', 'maxhi': 1, 'index': 'index', 'path': '~/.vim/vimwiki/source/', 'gohome': 'split', 'ext': '.wiki', 'folding': 1, 'html_header': '', 'syntax': 'default', 'css_name': 'style.css'}]
" }}}2
" twitvim {{{2
let twitvim_login=""
" }}}2
" hatena {{{2
let g:hatena_user="goth_wrist_cut"
" }}}2
" prtdialog {{{2
let g:prd_prtDeviceList="standard,192.168.10.249,toccata"
let g:prd_prtDeviceIdx=1
nmap <Leader>prt <Plug>PRD_PrinterDialogNormal
vmap <Leader>prt <Plug>PRD_PrinterDialogVisual
" }}}2
" }}}1
let g:load_doxygen_syntax=1

" ファイルタイプ毎の追加オプション {{{1
" Haskell {{{2
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_highlight_debug = 1
let hs_allow_hash_operator = 1
let lhs_markup = "tex"
" }}}2
" Lisp {{{2
let g:lisp_instring = 1
let g:lisp_rainbow = 1
" }}}2
" SQL {{{2
let msql_sql_query = 1
" }}}2
" Python {{{2
let python_highlight_builtins = 1
let python_highlight_exceptions = 1
let python_highlight_space_errors = 1
let python_highlight_all = 1
" }}}2
" Readline with Bash {{{2
let readline_has_bash = 1
" }}}2
" Ruby {{{2
let ruby_minlines = 500
let ruby_space_errors = 1
" }}}2
" sh {{{2
let g:is_bash = 1 "bashしか使わへん
let sh_minlines = 500
" }}}2
" {{{2
" }}}2
" }}}1
" set t_ti=
" set t_te=
" vim: foldmethod=marker:foldlevel=1

autocmd BufNewFile *.cpp 0r $HOME/.rc/vim/template/template.cpp
autocmd BufNewFile *.pl 0r $HOME/.rc/vim/template/template.pl
autocmd BufNewFile *.tex 0r $HOME/.rc/vim/template/template.tex
autocmd BufNewFile *.c 0r $HOME/.rc/vim/template/template.c
autocmd BufNewFile *.html 0r $HOME/.rc/vim/template/template.html
autocmd BufNewFile *.y 0r $HOME/.rc/vim/template/template.y
autocmd BufNewFile *.l 0r $HOME/.rc/vim/template/template.l

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

