
" smart window/tab/buffer switching utilities
" smart tab/buffer switching. nice integrated with airline

" nnoremap <expr> <S-l> tweak#wtb_swtich#key_kext()
" nnoremap <expr> <S-h> tweak#wtb_swtich#key_prev()

func! tweak#wtb_switch#key_next()
	return ( (type(tabpagebuflist(tabpagenr()+1))+type(tabpagebuflist(tabpagenr()-1))>0) ? ":tabn\<CR>"  : ":bn\<CR>" )
endfunc

func! tweak#wtb_switch#key_prev()
	return ( (type(tabpagebuflist(tabpagenr()-1))+type(tabpagebuflist(tabpagenr()+1))>0) ? ":tabp\<CR>"  : ":bp\<CR>" )
endfunc

func! tweak#wtb_switch#key_quit()
	let l:list = filter(range(1, bufnr('$')), 'buflisted(v:val)')
	let l:nr = bufnr('%')
	if len(l:list)>1

		" special buffer
		if index(['quickfix','help'],&buftype)>=0
			return ":q\<CR>"
		endif

		if index(l:list,l:nr)>=0
			return ":bn\<CR>:bd " . l:nr  . "\<CR>"
		else
			if winnr('$')>1
				return ":q\<CR>"
			else
				return ":bd\<CR>"
			endif
		endif
	else
		return ":q\<CR>"
	endif
endfunc

" func! tweak#wtb_switch#key_bufer()
" 	let l:shm     = &shortmess
" 	let l:ch      = &cmdheight
" 	try
" 		let l:buffers = tweak#wtb_switch#buflisted()
" 
" 		set shortmess=a
" 		let &cmdheight=len(l:buffers)+1
" 
" 		let l:prompt  = join(map(l:buffers, 'tweak#wtb_switch#format_buffer(v:val)'),"\n")
" 		echo l:prompt . "\nselect buffer: "
" 		redraws!
" 
" 		let l:n = getchar()
" 
" 		echo ""
" 		redraws!
" 		return ":buffer " . nr2char(l:n) . "\<CR>"
" 	finally
" 		let &shortmess = l:shm
" 		let &cmdheight = l:ch
" 	endtry
" endfunc
" 
" func! tweak#wtb_switch#buflisted()
"   return filter(range(1, bufnr('$')), 'buflisted(v:val)')
" endfunc
" 
" " copy from fzf.vim
" func! tweak#wtb_switch#format_buffer(b)
"   let name = bufname(a:b)
"   let name = empty(name) ? 'No Name' : name
"   let flag = a:b == bufnr('')  ? '%' :
"           \ (a:b == bufnr('#') ? '#' : ' ')
"   let modified = getbufvar(a:b, '&modified') ? ' [+]' : ''
"   let readonly = getbufvar(a:b, '&modifiable') ? '' : ' [RO]'
"   let extra = join(filter([modified, readonly], '!empty(v:val)'), '')
"   return printf(" %-2d %-2s \"%s\" %s", a:b, flag, name, extra)
" endfunc
" 
" function! s:strip(str)
"   return substitute(a:str, '\v^\s*|\s*$', '', 'g')
" endfunction



" let bufs = map(tweak#wtb_switch#buflisted(), 'tweak#wtb_switch#format_buffer(v:val)')
