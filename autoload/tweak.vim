
""
" execute command only the corrosponding plugin is installed
" usage: TweakForPlug bling/vim-airline call tweak#airline()
command! -nargs=+ TweakForPlug call s:TweakForPlug(<f-args>)
command! -nargs=+ -bar  TweakPlugBegin  call plug#begin(<args>) | call s:TweakPlugBegin(<args>)
command! -nargs=+ -bar  TweakPlug  call s:TweakPlug(<args>) | Plug <args>
command! -bar  TweakPlugEnd  call plug#end()


func! s:TweakPlugBegin(dir,...)
	let g:_tweak_plugins_dir = a:dir
endfunc


" register plugins for vim-tweak
func! s:TweakPlug(...)
	if exists('g:_tweak_plugins')!=1
		let g:_tweak_plugins = {}
	endif
	if len(a:000)>0
		let g:_tweak_plugins[a:000[0]] = a:000[1:]
	endif
	return g:_tweak_plugins
endfunc

func! s:TweakHasPlug(repo)
	if has_key(s:TweakPlug(),a:repo) == 0
		return 0
	endif
	if exists('g:_tweak_has_plugin_cache')==0
		let g:_tweak_has_plugin_cache = {}
	endif
	if has_key(g:_tweak_has_plugin_cache,a:repo)==1
		return g:_tweak_has_plugin_cache[a:repo]
	endif
	let g:_tweak_has_plugin_cache[a:repo] = (finddir(fnamemodify(a:repo,":t"),g:_tweak_plugins_dir) != "")
	return g:_tweak_has_plugin_cache[a:repo]
endfunc

func! s:TweakForPlug(repo,...)
	let l:repo = a:repo
	if l:repo[0]=="'" || l:repo[0]=='"'
		let l:repo = eval(a:repo)
	endif
	if s:TweakHasPlug(l:repo)==0
		" echo "plugin not installed: " . l:repo
		return
	endif
	execute join(a:000)
endfunc

func! tweak#plug(plugDir)

	" Execute :PlugInstall to install plugins when open vim for the
	" first time

	TweakPlugBegin a:plugDir

	" TweakPlug 'noahfrederick/vim-noctu'
	" TweakPlug 'w0ng/vim-hybrid'
	TweakPlug 'morhetz/gruvbox'
	" TweakPlug 'flazz/vim-colorschemes'
	" TweakPlug 'ryanoasis/vim-devicons'


	TweakPlug 'roxma/vim-window-resize-easy'
	TweakPlug 'bling/vim-airline'
	" TweakPlug 'itchyny/lightline.vim'

	" Get highlighted feedback when yanking
	" TweakPlug 'machakann/vim-highlightedyank'

	" TweakPlug 'yuttie/comfortable-motion.vim'

	" This plugin significantly slows down vim
	" TweakPlug 'severin-lemaignan/vim-minimap'

	" I use my own simple configuration, don't need this plugin anymore
	" TweakPlug 'edkolev/tmuxline.vim'

	" git
	TweakPlug 'tpope/vim-fugitive'
	TweakPlug 'junegunn/gv.vim'
	TweakPlug 'gregsexton/gitv'
	TweakPlug 'airblade/vim-gitgutter'

	TweakPlug 'sheerun/vim-polyglot'
	TweakPlug 'Glench/Vim-Jinja2-Syntax'

	" This plugin breaks the behavior of the . command
	" remove it for now
	" TweakPlug 'junegunn/vim-peekaboo'

	" Automatically set paste for you.
	TweakPlug 'roxma/vim-paste-easy'
	let g:paste_char_threshold = 3

	TweakPlug 'roxma/python-support.nvim'

	TweakPlug 'roxma/vim-encode'
	TweakPlug 'godlygeek/tabular'
	TweakPlug 'tpope/vim-surround'
	TweakPlug 'tpope/vim-commentary'
	" cool, but still have some confuzing issues, not what I want
	" TweakPlug 'terryma/vim-multiple-cursors'
	TweakPlug 'dhruvasagar/vim-table-mode'

	" I have easymotion already. If I partially mapped sneak key f,
	" Then F + ; will now work as I expected. So I don't use this plugin.
	" TweakPlug 'justinmk/vim-sneak'
	" seems like I never use easymotion after installing it
	" TweakPlug 'Lokaltog/vim-easymotion'

	" TweakPlug 'Valloric/YouCompleteMe'
	" TweakPlug 'scrooloose/syntastic'
	" TweakPlug 'roxma/vim-syntax-compl-pop'
	" TweakPlug 'jiangmiao/auto-pairs'
	" TweakPlug 'roxma/nvim-possible-textchangedi'
	TweakPlug 'neomake/neomake'
	if !has('nvim')
		TweakPlug 'roxma/vim-hug-neovim-rpc'
	endif

	" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
	" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
	" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
	Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
	TweakPlug 'roxma/nvim-completion-manager'
	TweakPlug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
	TweakPlug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
	autocmd FileType php LanguageClientStart
	" if has('nvim')
	" 	" fuzzy matcher don't work well on vim, has flickering issue
	" 	let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
	" 	let g:cm_completekeys = "\<Plug>(cm_completefunc)"
	" endif

	TweakPlug 'majutsushi/tagbar'
	TweakPlug 'scrooloose/nerdtree'
	TweakPlug 'Xuyuanp/nerdtree-git-plugin'
	" TweakPlug 'tiagofumo/vim-nerdtree-syntax-highlight'

	" need to install the_silver_searcher first: https://github.com/ggreer/the_silver_searcher
	TweakPlug 'rking/ag.vim'
	" Replace ctrlp with fzf
	" TweakPlug 'ctrlpvim/ctrlp.vim'
	TweakPlug 'junegunn/fzf', { 'do': './install --no-key-bindings --no-completion --no-update-rc' } " only install fzf for vim
	TweakPlug 'junegunn/fzf.vim'
	" for the enhanced <Leader>* key
	TweakPlug 'haya14busa/vim-asterisk'
	TweakPlug 'haya14busa/incsearch.vim'
	" TweakPlug 'dyng/ctrlsf.vim'
	" TweakPlug 'pelodelfuego/vim-swoop'

	" markdown
	TweakPlug 'plasticboy/vim-markdown'
	TweakPlug 'mzlogin/vim-markdown-toc'

	" php
	" Use my own forked repo, I'm planning on performance improvment
	TweakPlug 'roxma/phpcomplete.vim'

	" vim go
	TweakPlug 'fatih/vim-go'

	" vim python completion
	TweakPlug 'davidhalter/jedi-vim'

	TweakPlug 'roxma/clang_complete'

	" web front-end, disabled by polyglot
	" TweakPlug 'jelera/vim-javascript-syntax'
	" html syntaxed, it's inside polyglot
	" TweakPlug 'othree/html5.vim'
	TweakPlug 'mattn/emmet-vim'
	TweakPlug 'ternjs/tern_for_vim', { 'do': 'npm install' } " only install fzf for vim

	" uml, interesting
	" TweakPlug 'aklt/plantuml-syntax'
	" TweakPlug 'scrooloose/vim-slumlord'


	if !has('nvim')
		TweakPlug 'tmux-plugins/vim-tmux-focus-events'
	endif
	TweakPlug 'roxma/vim-tmux-clipboard'

	TweakPlug 'SirVer/ultisnips'
	TweakPlug 'honza/vim-snippets'
	" TweakPlug 'Shougo/neosnippet'
	" TweakPlug 'Shougo/neosnippet-snippets'

	" " SuperTab like snippets behavior.
	" " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	" " For conceal markers.
	" if has('conceal')
	" 	set conceallevel=2 concealcursor=niv
	" endif
	" inoremap <silent> <c-k> <c-r>=cm#sources#neosnippet#trigger_or_popup("\<Plug>(neosnippet_expand_or_jump)")<cr>

	TweakPlug 'metakirby5/codi.vim'

	" crashes if no man page found
	" TweakPlug 'jez/vim-superman'

	" don't need it anymore
	" TweakPlug 'christoomey/vim-tmux-navigator'

	" Can't match JavaScript inside html <script> tag
	" TweakPlug 'tmhedberg/matchit'

	" Browse hacker news in vim
	" TweakPlug 'ryanss/vim-hackernews'

	TweakPlugEnd

endfunc

" called by user's vimrc
func! tweak#bootstrap(...)

	set nocompatible
	syntax on
	filetype plugin indent on
	set encoding=utf-8 fileencodings=ucs-bom,utf-8,gbk,gb18030,latin1 termencoding=utf-8

	let g:mapleader = " "

	if a:0>0 && type(a:1)==1
		" first argument is directory for plugins managed by vim-plug
		call tweak#plug(a:1)
	endif


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

	set shortmess+=c

	augroup tweak_help
		" make help window open verticle right, so that you won't feel that the
		" file buffer window adjusted when help is opened
		au BufWinEnter */doc/* if &filetype=='help' && &modifiable==0 | wincmd L | endif
	augroup end

	" Always show at least one line above/below the cursor.
	set scrolloff=1

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
	nnoremap <expr> -         tweak#wtb_switch#key_switch_buffer_in_this_page(":" . " b " . v:count  . "\<CR>")
	nnoremap <expr> <S-l>     tweak#wtb_switch#key_next()
	nnoremap <expr> <S-h>     tweak#wtb_switch#key_prev()
	nnoremap <expr> <S-q>     tweak#wtb_switch#key_quit()
	nnoremap        <Leader>b :ls<CR>:buffer<Space>
	" nnoremap <expr> <Leader>b tweak#wtb_switch#key_bufer()
	" Avoid message "E37: No write since last change (add ! to override)" when try
	" to switch buffer

	set hidden

	" file tab highlighting, deprecated, use airline plugin with 'set t_Co=256' now
	" hi TabLineSel      term=bold cterm=bold
	" hi TabLine         term=underline cterm=underline ctermfg=0 ctermbg=7
	" hi TabLineFill     term=reverse cterm=reverse

	" more handy way of switching between split windows
	nnoremap <Leader>h  <C-w>h
	nnoremap <Leader>j  <C-w>j
	nnoremap <Leader>k  <C-w>k
	nnoremap <Leader>l  <C-w>l

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

	nnoremap <silent> g<c-o> :call tweak#enhance_jumps#buffer_c_o()<CR>
	nnoremap <silent> g<c-i> :call tweak#enhance_jumps#buffer_c_i()<CR>

	" call tweak#only_editting_buffers#init()

	" scrolling
	" noremap <expr> S float2nr(winheight(0)/3) . '<C-y>M0'
	" noremap <expr> s float2nr(winheight(0)/3) . '<C-e>M0'

	" the m key is taken by easymotion
	" noremap - m
	" ` is more precise than '
	noremap ' `

	" <Leader><C-O>
	" <Leader><C-I>
	" <Leader>g;
	" <Leader>g,
	" 参考 https://github.com/dyng/ctrlsf.vim 的实现
	" popup a windw like AG.vim which shows more than one line
	" func! <SID>changes()
	" 	let l:m=&more
	" 	let l:s=&shortmess
	" 	set nomore
	" 	set shortmess=a
	" 	redir => g:changes
	" 	silent changes
	" 	redir END
	" 	let &shortmess=l:s
	" 	let &more=l:m
	" endfunc
	" nnoremap <expr> <Leader>g; <SID>changes()

	"
	" }
	""""

	"""
	" searching
	" {

	" visual mode asterisk search
	TweakForPlug 'haya14busa/vim-asterisk' vmap * <Plug>(asterisk-*)
	TweakForPlug 'haya14busa/vim-asterisk' vmap # <Plug>(asterisk-#)

	"   use ':' so that we could found the previous search string in history command
	"   '\c' case insensitive
	TweakForPlug 'haya14busa/incsearch.vim' map /  <Plug>(incsearch-forward)\c\v
	TweakForPlug 'haya14busa/incsearch.vim' map ?  <Plug>(incsearch-backward)\c\v

	" Thanks to https://yuez.me/vim-ji-qiao/
	" n always for searching down, N always for searching up
	nnoremap <expr> n  'Nn'[v:searchforward]
	nnoremap <expr> N  'nN'[v:searchforward]

	" clean last pattern to avoid highlighting
	" :help last-pattern
	nnoremap <ESC><ESC> :let @/ = ""<CR>

	" kind of like <c-l> in shell cmdline, use
	" tweak#wtb_switch#key_switch_buffer_in_this_page to switch to the default
	" normal buffer window
	nnoremap <silent> <expr> <C-l>  tweak#wtb_switch#key_switch_buffer_in_this_page('') . "zz:nohlsearch \| diffupdate \| syntax sync fromstart \<cr>" 
	inoremap <c-l> <c-o>zz


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

	" save
	nnoremap <C-s> :<C-U>w<CR>
	inoremap <C-s> <ESC>:<C-U>w<CR>

	" use g= for textwidth formattingh, easier to remember because = is for
	" tab formatting
	nnoremap g=   gw
	nnoremap g==   gwgw

	" inspired by kakoune's alt-i and alt-a key
	nnoremap s vi
	nnoremap S va

	" `u` is the undo key in normal mode
	" `U` would be more intuitive to be the redo key.
	" The original `U` key may have is usage circumstances, but dost not look
	" good to me.
	nnoremap U <C-R>

	" do not override the register after paste in select mode
	xnoremap <expr> p 'pgv"'.v:register.'y`>'

	noremap <leader>p :setlocal paste!<cr>

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
	autocmd FileType text,markdown setlocal tw=78 | setlocal fo+=t | setlocal tabstop=4 | setlocal softtabstop=4 | setlocal shiftwidth=4 | setlocal  expandtab
	" markdown list leader (-) and (+) will not be auto inserted like a
	" comment leader. This helps auto formatting for a long list line with
	" 'gq'.
	autocmd FileType markdown      setlocal comments-=b:- | setlocal comments-=b:+
	" auto insert '\' as a comment leader
	autocmd FileType vim           setlocal comments+=b:\

	" indentation
	set tabstop=4 | set softtabstop=4 | set shiftwidth=4 | set noexpandtab
	" cpp indentation, use google style
	autocmd FileType cpp,c,cxx,h,hpp setlocal tabstop=2| setlocal softtabstop=2| setlocal shiftwidth=2 | setlocal expandtab
	autocmd FileType html*,javascript* setlocal tabstop=2 | setlocal softtabstop=2 | setlocal shiftwidth=2 | setlocal  expandtab
	" php indentation standard, check this out: http://www.php-fig.org/psr/psr-2/#2-4-indenting
	autocmd FileType php             let &l:tabstop= (bufname('%')=~'blade.php$'?2:4) | let &l:softtabstop=&l:tabstop | let &l:shiftwidth=&l:tabstop | setlocal expandtab

	" folding
	set foldenable
	set foldmethod=syntax
	set foldlevel=100


	" like emacs mode shell command editing
	inoremap <C-E> <C-o>$
	inoremap <C-A> <C-o>^
	inoremap <C-B> <c-o>b
	inoremap <C-F> <c-o>w
	inoremap <C-D> <Delete>

	" command line editing
	cnoremap <C-A>      <Home>
	cnoremap <C-B>      <Left>
	cnoremap <C-D>      <Delete>
	" <C-F>  is also used for open  normal command-line editing. So if the
	" cursor is at the end of the command-line, open normal command-line
	" editing, otherwise move the cursor one character right.
	cnoremap <expr> <C-F>  (getcmdpos()<(len(getcmdline())+1)) && (getcmdtype()==":") ?  "\<Right>" : "\<C-F>"
	" already well mapped by default:
	" <C-P> <Up>
	" <C-N> <Down>
	" <C-E> <End>
	
	" smart tab for auto complete
	inoremap <expr> <silent> <Tab>  pumvisible()?"\<C-n>":"\<TAB>"
	inoremap <expr> <silent> <S-TAB>  pumvisible()?"\<C-p>":"\<S-TAB>"
	inoremap <expr> <buffer> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

	set completeopt=menu,menuone,longest

	" }
	""""

	""""
	" {

	" <Leader>w as prefix for special window

	nnoremap <Leader>wc :cwindow<CR>

	" }
	""""

	TweakForPlug 'bling/vim-airline'                call tweak#airline()
	TweakForPlug 'bling/vim-lightline'              call tweak#lightline()
	TweakForPlug 'majutsushi/tagbar'                call tweak#tagbar()
	TweakForPlug 'scrooloose/nerdtree'              call tweak#nerdtree()
	TweakForPlug 'junegunn/fzf.vim'                 call tweak#fzf()
	TweakForPlug 'scrooloose/syntastic'             call tweak#syntastic()
	TweakForPlug 'neomake/neomake'					call tweak#neomake()
	TweakForPlug 'ctrlpvim/ctrlp.vim'               call tweak#ctrlp()
	TweakForPlug 'fatih/vim-go'                     call tweak#go()
	TweakForPlug 'davidhalter/jedi-vim'             call tweak#jedi()
	TweakForPlug 'plasticboy/vim-markdown'          call tweak#markdown()
	TweakForPlug 'christoomey/vim-tmux-navigator'   call tweak#vim_tmux_navigator()
	TweakForPlug 'Valloric/YouCompleteMe'           call tweak#YouCompleteMe()
	TweakForPlug 'tpope/vim-surround'               call tweak#surround()
	TweakForPlug 'pelodelfuego/vim-swoop'           let g:swoopUseDefaultKeyMap = 0
	TweakForPlug 'airblade/vim-gitgutter'           let g:gitgutter_map_keys = 0
	TweakForPlug 'SirVer/ultisnips'                 call tweak#ultisnip()
	TweakForPlug 'Shougo/neosnippet'                call tweak#neosnippet()
	TweakForPlug 'roxma/python-support.nvim'		call tweak#python_support()
	TweakForPlug 'roxma/nvim-completion-manager'    call tweak#nvim_completion_manager()

endfunc

fun! tweak#nvim_completion_manager()
	" use this to add airline plugin if airline rtp load is disabled
	let g:airline#extensions#cm_call_signature#enabled = 1
	let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'jedi')

	" language specific completions on markdown file
	let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'mistune')

	" utils, optional
	let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'psutil')
	let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

	imap <c-g> <Plug>(cm_force_refresh)

endfunc

func! tweak#python_support()
	let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'flake8')
endfunc

func! tweak#airline()
	let g:airline#extensions#disable_rtp_load = 1
	let g:airline_extensions = ['tabline']
	let g:airline#extensions#tabline#buffer_nr_show = 1 
	let g:airline#extensions#tabline#enabled = 1
	" let g:airline#extensions#tabline#left_sep = ' '
	" let g:airline#extensions#tabline#left_alt_sep = '|'
	set laststatus=2
	let g:airline#extensions#capslock#enabled = 1
	"let g:airline_section_b = '%{&expandtab?"et":"noet"}'

	" airline plugin shows the mode, no need for this
	" set noshowmode

endfunc

func! tweak#lightline()
	let g:lightline = {
				\ 'colorscheme': 'gruvbox',
				\	'component': {
				\	  'readonly': '%{&readonly}"⭤":""}',
				\	}
				\ }
endfunc

func! tweak#tagbar()
	" <C-p> for open/close pane
	nnoremap <Leader>wt :TagbarToggle<CR>
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
	let g:NERDTreeQuitOnOpen=1
	nnoremap <Leader>wn :NERDTreeToggle<CR>
	"  close vim if the only window left open is a NERDTree
	autocmd BufEnter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endfunc

func! tweak#fzf()

	let g:fzf_command_prefix = 'FZF'

	" fzf files
	nnoremap <expr> <C-f><C-f> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZF\<CR>")
	nnoremap <expr> <C-f>f     tweak#wtb_switch#key_switch_buffer_in_this_page(":FZF\<CR>")
	nnoremap <expr> <Leader>f  tweak#wtb_switch#key_switch_buffer_in_this_page(":FZF\<CR>")

	" Recently opened files
	nnoremap <expr> <C-f><C-r> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFHistory\<CR>")
	nnoremap <expr> <C-f>r     tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFHistory\<CR>")
	nnoremap <expr> <C-f><C-h> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFHistory\<CR>")
	nnoremap <expr> <C-f>h     tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFHistory\<CR>")

	nnoremap <C-f><C-m> :FZFMaps<CR>
	nnoremap <C-f>m     :FZFMaps<CR>

	" Commands
	nnoremap <C-f><C-c> :FZFCommands<CR>
	nnoremap <C-f>c     :FZFCommands<CR>

	" Buffers
	nnoremap <expr> <C-f><C-b> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFBuffers\<CR>")
	nnoremap <expr> <C-f>b     tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFBuffers\<CR>")
	nnoremap <expr> <C-b>      tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFBuffers\<CR>")

	" lines
	nnoremap <expr> <C-f>l  	 tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFLines\<CR>")
	nnoremap <expr> <C-f><C-l>  tweak#wtb_switch#key_switch_buffer_in_this_page(":FZFLines\<CR>")

	nnoremap <C-f>/  	 :FZFBLines<CR>
	" vim can't recognize
	" nnoremap <C-f><C-/>  :FZFLines<CR>

	" commands
	nnoremap <C-f>:  	 :FZFCommands<CR>

	" fzf ag
	nnoremap <expr> <C-f>a  	 tweak#wtb_switch#key_switch_buffer_in_this_page(':FZFAg ')
	nnoremap <expr> <C-f><C-a>   tweak#wtb_switch#key_switch_buffer_in_this_page(':FZFAg ')

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

func! tweak#neomake()
	let g:neomake_open_list = 2
	autocmd! BufWritePost * Neomake
	" A value of 2 will
	" preserve the cursor position when the |location-list| or |quickfix|
	" window is
	" opened.
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
	" Turn on case insensitive feature
	let g:EasyMotion_smartcase = 1
	" go to character, 'm' for motion
	nmap m <Plug>(easymotion-s)
	xmap m <Plug>(easymotion-s)
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

func! tweak#jedi()
	let g:jedi#auto_initialization = 0
	let g:jedi#auto_vim_configuration = 0
	let g:jedi#show_call_signatures = 0
	autocmd FileType python nmap <buffer> <C-]> :call jedi#goto_definitions()<CR>
endfunc

func! tweak#markdown()
	let g:vim_markdown_initial_foldlevel=100
endfunc

func! tweak#vim_tmux_navigator()
	" tmux navigator stuff
	let g:tmux_navigator_no_mappings = 1
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

func! tweak#surround()
	let g:surround_no_mappings = 1
	" s instead of ys, feels more consistence
	nmap ds  <Plug>Dsurround
	nmap cs  <Plug>Csurround
	xmap s   <Plug>VSurround
endfunc

func! tweak#neosnippet()
	imap <expr> <Tab> (pumvisible() ? "\<C-n>" : (neosnippet#mappings#expand_or_jump_impl()!=''?neosnippet#mappings#expand_or_jump_impl():"\<Tab>"))
	smap <Tab>     <Plug>(neosnippet_expand_or_jump)
	xmap <Tab>     <Plug>(neosnippet_expand_target)
	" neosnippet doesn't have jump back key
	imap <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<S-Tab>")
endfunc

func! tweak#ultisnip()

	" https://github.com/roxma/nvim-completion-manager/issues/38#issuecomment-284195597

	let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
	let g:UltiSnipsJumpForwardTrigger	= "<Plug>(ultisnips_expand)"
	let g:UltiSnipsJumpBackwardTrigger	= "<Plug>(ultisnips_backward)"
	let g:UltiSnipsListSnippets			= "<Plug>(ultisnips_list)"
    let g:UltiSnipsRemoveSelectModeMappings = 0

	vnoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
	inoremap <expr> <Plug>(ultisnip_expand_or_jump_result) g:ulti_expand_or_jump_res?'':"\<Tab>"
	imap <silent> <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<cr>\<Plug>(ultisnip_expand_or_jump_result)")
	xmap <Tab> <Plug>(ultisnips_expand)
	smap <Tab> <Plug>(ultisnips_expand)

	vnoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
	inoremap <expr> <Plug>(ultisnips_backwards_result) g:ulti_jump_backwards_res?'':"\<S-Tab>"
	imap <silent> <expr> <S-Tab> (pumvisible() ? "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()\<cr>\<Plug>(ultisnips_backwards_result)")
	xmap <S-Tab> <Plug>(ultisnips_backward)
	smap <S-Tab> <Plug>(ultisnips_backward)

	" optional
	inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>


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
 

