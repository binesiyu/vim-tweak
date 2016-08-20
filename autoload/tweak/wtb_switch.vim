
" smart window/tab/buffer switching utilities
" smart tab/buffer switching. nice integrated with airline

" nnoremap <expr> <S-l> tweak#wtb_swtich#key_kext()
" nnoremap <expr> <S-h> tweak#wtb_swtich#key_prev()

func! tweak#wtb_switch#is_multi_tabpage()
	return type(tabpagebuflist(tabpagenr()+1))==3 || type(tabpagebuflist(tabpagenr()-1))==3
endfunc

func! tweak#wtb_switch#key_next()
	return ( tweak#wtb_switch#is_multi_tabpage() ? ":tabn\<CR>"  : ":bn\<CR>" )
endfunc

func! tweak#wtb_switch#key_prev()
	return ( tweak#wtb_switch#is_multi_tabpage() ? ":tabp\<CR>"  : ":bp\<CR>" )
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

func! tweak#wtb_switch#key_leader_bufnum(num)
	let l:buffers = tweak#wtb_switch#buflisted()
	let l:input = a:num . ""

	while 1

		let l:cnt = 0
		let l:i=0
		" count matches
		while l:i<len(l:buffers)
			let l:bn = l:buffers[l:i] . ""
			if l:input==l:bn[0:len(l:input)-1]
				let l:cnt+=1
			endif
			let l:i+=1
		endwhile

		" no matches
		if l:cnt==0 && len(l:input)>0
			" echoerr is a bit annoying, use echohl instead
			echohl WarningMsg | echo "No buffer [" . l:input . "]" | echohl None
			return ''
		elseif l:cnt==1
			return ":b " . l:input . "\<CR>"
		endif

		echo ":b " . l:input

		let l:n = getchar()

		if l:n==char2nr("\<BS>") ||  l:n==char2nr("\<C-h>")
			" delete one word
			if len(l:input)>=2
				let l:input = l:input[0:len(l:input)-2]
			else
				let l:input = ""
			endif
		elseif l:n==char2nr("\<CR>") || (l:n<char2nr('0') || l:n>char2nr('9'))
			return ":b " . l:input . "\<CR>"
		else
			let l:input = l:input . nr2char(l:n)
		endif

		let g:n = l:n

	endwhile

endfunc

func! tweak#wtb_switch#buflisted()
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
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
