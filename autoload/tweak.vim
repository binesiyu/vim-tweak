
""
" execute command only the corrosponding plugin is installed
" usage: TweakForPlugin bling/vim-airline call tweak#airline()
command! -nargs=+ TweakForPlugin call tweak#tweak_for_plugin(<f-args>)

func! tweak#has_plugin(repo)
	" g:TweakHasPlug is defined globally in vimrc
	if exists('g:_tweak_has_plugin_cache')==0
		let g:_tweak_has_plugin_cache = {}
	endif
	if has_key(g:_tweak_has_plugin_cache,a:repo)==0
		let g:_tweak_has_plugin_cache = {}
	endif
	let l:ret = g:TweakHasPlug(a:repo)
	let g:_tweak_has_plugin_cache[a:repo] = l:ret
	return l:ret
endfunc

func! tweak#tweak_for_plugin(repo,...)
	let l:repo = a:repo
	if l:repo[0]=="'" || l:repo[0]=='"'
		let l:repo = eval(a:repo)
	endif
	if tweak#has_plugin(l:repo)==0
		" echo "plugin not installed: " . l:repo
		return
	endif
	execute join(a:000)
endfunc

" called by user's vimrc
func! tweak#bootstrap()

	"""
	" appearance
	" {
	"

	if &term=="xterm"
		set t_Co=8
		set t_Sb=[4%dm
		set t_Sf=[3%dm
	endif
	if &term=="xterm-256color"
		set t_Co=256
	endif

	try
		" my favorite colorscheme
		" let g:gruvbox_contrast_dark="hard"
		set background=dark
		colorscheme gruvbox
		" A black background would be better for remote terminal 
		" due to the low FPS
		hi Normal ctermbg=none
	catch
		set background=dark
		colorscheme default
	endtry

	set ruler               	" show the cursor position all the time

	" No beeps
	set noerrorbells

	" Don't wake up system with blinking cursor:
	" http://www.linuxpowertop.org/known.php
	let &guicursor = &guicursor . ",a:blinkon0"

	" no mouse interaction, mouse is evil
	set mouse=

	" don't split a long line for display
	set nowrap

	" line number
	set relativenumber
	set number

	"
	" }
	"""


	" redefine leader key
	let mapleader = " "


	"""
	" window/buffer switching
	" {
	"

	" NOTE: this is wierd, the follow ing command is invalid:
	" nnoremap <expr> <S-l> ( (type(tabpagebuflist(tabpagenr()==3))||(type(tabpagebuflist(tabpagenr()-1))==3)) ? ":tabn\<CR>"  : ":bn\<CR>" )
	nnoremap <Leader>1 :buffer 1<CR>
	nnoremap <Leader>2 :buffer 2<CR>
	nnoremap <Leader>3 :buffer 3<CR>
	nnoremap <Leader>4 :buffer 4<CR>
	nnoremap <Leader>5 :buffer 5<CR>
	nnoremap <Leader>6 :buffer 6<CR>
	nnoremap <Leader>7 :buffer 7<CR>
	nnoremap <Leader>8 :buffer 8<CR>
	nnoremap <Leader>9 :buffer 9<CR>
	nnoremap <expr> <S-l>     tweak#wtb_switch#key_next()
	nnoremap <expr> <S-h>     tweak#wtb_switch#key_prev()
	nnoremap <expr> <S-q>     len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))>1?":bd\<CR>":":q\<CR>"
	nnoremap <Leader>b :ls<CR>:buffer<Space>
	" nnoremap <expr> <Leader>b tweak#wtb_switch#key_bufer()
	" Avoid message "E37: No write since last change (add ! to override)" when try
	" to switch buffer

	" nnoremap <expr> <Leader>b eval('ls | return 1')
	" :ls<CR>:echo "buffer:"<CR>:execute 'b ' . nr2char(getchar())<CR>

	set hidden

	" file tab highlighting, deprecated, use airline plugin with 'set t_Co=256' now
	" hi TabLineSel      term=bold cterm=bold
	" hi TabLine         term=underline cterm=underline ctermfg=0 ctermbg=7
	" hi TabLineFill     term=reverse cterm=reverse

	" more handy way of switching between split windows
	nnoremap <C-h>  <C-w>h
	nnoremap <C-j>  <C-w>j
	nnoremap <C-k>  <C-w>k
	nnoremap <C-l>  <C-w>l

	"
	" }
	"""

	"""
	" motion
	" {

	" go to parent, it's better to create a plugin map insead of nmap
	nnoremap ]t vatatv
	nnoremap [t vatatov

	noremap <expr> { tweak#blockmove#up_key()
	noremap <expr> } tweak#blockmove#down_key()

	nnoremap <expr> <C-u> winheight(0)/3 . '<C-y>'
	nnoremap <expr> <C-d> winheight(0)/3 . '<C-e>'

	" just like shell command editing
	inoremap <C-e> <C-o>$
	inoremap <C-a> <C-o>^
	inoremap <C-b> <Left>
	inoremap <C-f> <Right>

	"
	" }
	""""

	"""
	" searching
	" {

	" visual mode asterisk search
	TweakForPlugin 'haya14busa/vim-asterisk' vmap * <Plug>(asterisk-*)

	"   use ':' so that we could found the previous search string in history command
	"   '\c' case insensitive
	nnoremap /  /\c\v
	nnoremap ?  ?\c\v

	" clean last pattern to avoid highlighting
	" :help last-pattern
	nnoremap <ESC><ESC> :let @/ = ""<CR>

	" enable incremental search 
	set incsearch

	" highlighting
	set hlsearch
	" conflict with gruvbox colorscheme
	" hi Search guibg=LightBlue ctermbg=LightBlue
	" hi MatchParen ctermbg=lightred guibg=lightred

	"
	" }
	""""

	if has('nvim')  
		" with neovim, press `<ESC><ESC>` to exit terminal mode
		tnoremap <ESC><ESC> <C-\><c-n>
	endif


	"""
	" editing
	" {

	nnoremap <C-s> :w<CR>
	nnoremap S :w<CR>

	set viminfo='100,\"50    	" read/write a .viminfo file, don't store more
								" than 50 lines of registers
	set history=1000          	" keep 1000 lines of command line history
	if has('nvim')  
		set shada='100"50
	endif

	set bs=indent,eol,start 	" allow backspacing over everything in insert mode

	" When open a file, always jump to the last cursor position
	autocmd BufReadPost *
	\ if line("'\"") > 0 && line ("'\"") <= line("$") |
	\   exe "normal! g'\"" |
	\ endif

	" don't write swapfile on most commonly used directories for NFS mounts or USB sticks
	autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp

	" auto wraping in text files
	" fo+=t enable auto wraping
	" fo+=a enable auto wraping for paragraph
	autocmd FileType text,markdown setlocal tw=79 | setlocal fo+=t | setlocal tabstop=4 | setlocal softtabstop=4 | setlocal shiftwidth=4 | setlocal  expandtab

	" indentation
	set tabstop=4 | set softtabstop=4 | set shiftwidth=4 | set noexpandtab
	" cpp indentation, use google style
	autocmd FileType cpp,c,cxx,h,hpp setlocal tabstop=2| setlocal softtabstop=2| setlocal shiftwidth=2 | setlocal expandtab
	" php indentation standard, check this out: http://www.php-fig.org/psr/psr-2/#2-4-indenting
	autocmd FileType php             let &l:tabstop= (bufname('%')=~'blade.php$'?2:4) | let &l:softtabstop=&l:tabstop | let &l:shiftwidth=&l:tabstop | setlocal expandtab

	" folding
	set foldenable
	set foldmethod=syntax
	set foldlevel=100

	" }
	""""

	TweakForPlugin 'bling/vim-airline' call tweak#airline()
	TweakForPlugin 'majutsushi/tagbar' call tweak#tagbar()
	TweakForPlugin 'scrooloose/nerdtree' call tweak#nerdtree()
	TweakForPlugin 'junegunn/fzf.vim' call tweak#fzf()
	TweakForPlugin 'roxma/SimpleAutoComplPop' call tweak#SimpleAutoComplPop()
	TweakForPlugin 'altercation/vim-colors-solarized' call tweak#solarized()
	TweakForPlugin 'scrooloose/syntastic' call tweak#syntastic()
	TweakForPlugin 'ctrlpvim/ctrlp.vim' call tweak#ctrlp()
	TweakForPlugin 'Lokaltog/vim-easymotion' call tweak#easymotion()
	TweakForPlugin 'fatih/vim-go' call tweak#go()
	TweakForPlugin 'plasticboy/vim-markdown' call tweak#markdown()
	TweakForPlugin 'christoomey/vim-tmux-navigator' call tweak#vim_tmux_navigator()
	TweakForPlugin 'simeji/winresizer'      call tweak#winresizer()
	TweakForPlugin 'Valloric/YouCompleteMe' call tweak#YouCompleteMe()

endfunc

func! tweak#airline()
	let g:airline#extensions#tabline#buffer_nr_show = 1 
	let g:airline#extensions#tabline#enabled = 1
	" let g:airline#extensions#tabline#left_sep = ' '
	" let g:airline#extensions#tabline#left_alt_sep = '|'
	set laststatus=2
	let g:airline#extensions#capslock#enabled = 1
	"let g:airline_section_b = '%{&expandtab?"et":"noet"}'
endfunc

func! tweak#tagbar()
	" The tags are not sorted according to their name
	let g:tagbar_sort = 0
	let g:tagbar_type_php  = {
				\ 'ctagstype' : 'php',
				\ 'kinds'     : [
				\ 'i:interfaces',
				\ 'c:classes',
				\ 'd:constant definitions',
				\ 'f:functions',
				\ 'j:javascript functions:1'
				\ ]
				\ }
endfunc

func! tweak#nerdtree()
	nnoremap <C-p><C-n> :NERDTreeToggle<CR>
	nnoremap <C-p>n :NERDTreeToggle<CR>
	"  close vim if the only window left open is a NERDTree
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endfunc

func! tweak#fzf()

	let g:fzf_command_prefix = 'FZF'

	" fzf files
	nnoremap <C-f><C-f> :FZF<CR>
	nnoremap <C-f>f     :FZF<CR>
	nnoremap <Leader>f  :FZF<CR>

	" MRU
	nnoremap <C-f><C-m> :FZFHistory<CR>
	nnoremap <C-f>m     :FZFHistory<CR>

	" Commands
	nnoremap <C-f><C-c> :FZFCommands<CR>
	nnoremap <C-f>c     :FZFCommands<CR>

	" Buffers
	nnoremap <C-f><C-b> :FZFBuffers<CR>
	nnoremap <C-f>b     :FZFBuffers<CR>
	nnoremap <C-b>      :FZFBuffers<CR>

	" lines
	nnoremap <C-f>l  	 :FZFLines<CR>
	nnoremap <C-f><C-l>  :FZFLines<CR>

	nnoremap <C-f>/  	 :FZFBLines<CR>
	" vim can't recognize
	" nnoremap <C-f><C-/>  :FZFLines<CR>

	" commands
	nnoremap <C-f>:  	 :FZFCommands<CR>

	" fzf ag
	nnoremap <C-f>a  	 :FZFAg<Space>
	nnoremap <C-f><C-a>  :FZFAg<Space>

endfunc


func! tweak#SimpleAutoComplPop()
	" disable default behavior for php
	let g:sacpDefaultFileTypesEnable = { "php":0, "markdown":1, "text":1, "go":0}

	" The omnifunc phpcomplete#Complete is very slow, stop using it!
	autocmd FileType php call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\$\w\{2,}$'     , 'feedkeys': "\<plug>(sacp_cache_fuzzy_bufferkeyword_complete)"},
				\ { '=~': '\v[a-zA-Z]{3,}$', 'feedkeys': "\<plug>(sacp_cache_fuzzy_bufferkeyword_complete)"},
				\ { '=~': '::$'            , 'feedkeys': "\<plug>(sacp_cache_fuzzy_bufferkeyword_complete)"},
				\ { '=~': '->$'            , 'feedkeys': "\<plug>(sacp_cache_fuzzy_bufferkeyword_complete)"},
				\ ]
				\ })

	" 1. variables are all defined in current scope, use keyword from current
	" buffer for completion
	" 2. When the '.' is pressed, use smarter omnicomplete `<C-x><C-o>`, this
	" works well with the vim-go plugin
	autocmd FileType go call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{3}$' , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_bufferkeyword_complete)"} ,
				\ { '=~': '\.$'            , 'feedkeys': "\<Plug>(sacp_cache_fuzzy_omnicomplete)", "ignoreCompletionMode":1} ,
				\ ]
				\ })
endfunc

func! tweak#solarized()
	if &t_Co == 256
		" syntax enable
		let g:solarized_termcolors=256
		" set background=dark
		" colorscheme solarized
	endif
endfunc

func! tweak#syntastic()
	if exists(':SyntasticCheck')
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*
	endif

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 0
	let g:syntastic_check_on_wq = 0

	" working with vim-go
	let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
	let g:go_list_type = "quickfix"
	let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
endfunc

func! tweak#ctrlp()
	" Set no max file limit
	let g:ctrlp_max_files = 0
	" Search from current directory instead of project root
	let g:ctrlp_working_path_mode = 0

	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.yardoc/*,*.o,*.png,*.gif,*.gz
endfunc

func! tweak#easymotion()
	" do not use default mapping, I only use the s key
	let g:EasyMotion_do_mapping = 0
	" go to character
	nmap s <Plug>(easymotion-s)
endfunc

func! tweak#go()
	" vim-go plugin
	let g:go_auto_type_info=1
	" disable go fmt on siave
	let g:go_fmt_autosave = 0
	" turn highlighting on
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_structs = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_build_constraints = 1
	" autocmd FileType go nmap <buffer>  <C-w><C-]> <Plug>(go-def-split)
	autocmd FileType go nnoremap <buffer> <silent> <C-w><C-]> :<C-u>call go#def#Jump("split")<CR>
	" autocmd FileType go nnoremap <buffer> <C-w><C-]> :<C-u>call go#def#Jump("split")<CR>
endfunc

func! tweak#markdown()
	let g:vim_markdown_initial_foldlevel=100
endfunc

func! tweak#vim_tmux_navigator()
	" tmux navigator stuff
	let g:tmux_navigator_no_mappings = 1
endfunc

func! tweak#winresizer()
	let g:winresizer_start_key    = '<C-W><C-W>'
	let g:winresizer_vert_resize  = 1
	let g:winresizer_horiz_resize = 1
endfunc


func! tweak#YouCompleteMe()
	" only enable for php complications
	let g:ycm_filetype_whitelist = {"vimrc":1,"c":1,"cpp":1,"php":1}
	""
	" NOTICE: The  regex is python's syntax
	" 3 characters to 
	let g:ycm_semantic_triggers = {}
	let g:ycm_semantic_triggers.php =  ['->','::','re![_a-zA-Z]{3,}']
endfunc


" ""
" " Parse and execute vimscript in c/cpp file
" "
" " for example: (test.cpp)
" " /**
" "  * @vimrc let &l:makeprg='cd ' . expand('%:p:h') . ' && g++ test.cpp -o test.o'
" "  */
" "
" 
" """
" " Secirity issue
" """
" 
" autocmd FileType c,cpp call CFileLocalVimrc()
" 
" function! CFileLocalVimrc()
" 	
" 	let l:l = 1
" 	let l:skipThis=1
" 
" 	" check first line
" 	let l:lineArr = getbufline('%',l)
" 	if ( len(l:lineArr)==0)   " empty file
" 		return
" 	endif
" 	let l:lineStr = l:lineArr[0]
" 	if ( l:lineStr !~ '^\/\*\*$' )				" /** first line
" 		return
" 	endif
" 
" 	let l:l = l:l+1
" 	while (1)
" 
" 		let l:lineArr = getbufline("%",l)
" 		if ( len(l:lineArr)==0)
" 			call cursor(l:l-1, 1)
" 			return
" 		endif
" 
" 		let l:lineStr = l:lineArr[0]
" 		if(l:lineStr !~ '^\s\*')
" 			return
" 		endif
" 
" 		if(l:lineStr =~ '^\s\*\s@vimrc')
" 			let l:toExecute = substitute(l:lineStr,'^\s\*\s@vimrc','','')
" 			" silent execute '!echo l:toExecute'
" 			execute l:toExecute
" 		endif
"       
" 		let l:l = l:l+1
" 	endwhile
" 
" endfunction
 

