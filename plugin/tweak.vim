

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

" smart tab/buffer switching. nice integrated with airline
" NOTE: this is wierd, the follow ing command is invalid:
" nnoremap <expr> <S-l> ( (type(tabpagebuflist(tabpagenr()==3))||(type(tabpagebuflist(tabpagenr()-1))==3)) ? ":tabn\<CR>"  : ":bn\<CR>" )
nnoremap <expr> <S-l> ( (type(tabpagebuflist(tabpagenr()+1))+type(tabpagebuflist(tabpagenr()-1))>0) ? ":tabn\<CR>"  : ":bn\<CR>" )
nnoremap <expr> <S-h> ( (type(tabpagebuflist(tabpagenr()-1))+type(tabpagebuflist(tabpagenr()+1))>0) ? ":tabp\<CR>"  : ":bp\<CR>" )
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

noremap <expr>{ tweak#blockmove#up_key()
noremap <expr>} tweak#blockmove#down_key()

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
vmap * <Plug>(asterisk-*)

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
autocmd VimEnter * DoMatchParen

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
"

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

