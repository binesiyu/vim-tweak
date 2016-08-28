" smart window/tab/buffer switching utilities
" smart tab/buffer switching. nice integrated with airline
" 
" nnoremap <expr> <S-l> tweak#wtb_swtich#key_kext()
" nnoremap <expr> <S-h> tweak#wtb_swtich#key_prev()

func! s:init()
	if get(g:,'tweak#wtb_switch#init',0)==1
		return
	endif
	augroup tweak#wtb_switch
		autocmd!
		autocmd BufWinEnter * call s:buf_win_enter()
	augroup END
	let g:tweak#wtb_switch#init = 1
endfunc

func! s:is_multi_tabpage()
	call s:init()
	return type(tabpagebuflist(tabpagenr()+1))==3 || type(tabpagebuflist(tabpagenr()-1))==3
endfunc

" Automatically select the window for buffer switching
func! tweak#wtb_switch#key_switch_buffer_in_this_page(key)
	if buflisted(winbufnr('.'))
		return a:key
	endif
	let l:winnr = 0
	let l:windows = winnr('$')
	let l:listedCnt = 0
	let l:i=1
	while l:i <= l:windows
		if buflisted(winbufnr(l:i))
			let l:winnr = l:i
			let l:listedCnt+=1
		endif
		let l:i+=1
	endwhile
	" If there's only one window with listed buffer, use it
	" for switching
	" Otherwise do nothing
	if l:listedCnt == 1
		return ":" . l:winnr . "windo echo \<CR>" . a:key
	elseif l:listedCnt == 0
		" we have no other option here :)
		return key
	else
		echom "Please use a window with listed buffer for the switch!!!"
		return ''
	endif
endfunc

func! tweak#wtb_switch#key_next()
	call s:init()
	if s:is_multi_tabpage()
		return ":tabn\<CR>"
	endif
	return tweak#wtb_switch#key_switch_buffer_in_this_page(":bn\<CR>")
endfunc

func! tweak#wtb_switch#key_prev()
	call s:init()
	if s:is_multi_tabpage()
		return ":tabp\<CR>"
	endif
	return tweak#wtb_switch#key_switch_buffer_in_this_page(":bp\<CR>")
endfunc

func! tweak#wtb_switch#key_quit()
	call s:init()

	let l:list = filter(range(1, bufnr('$')), 'buflisted(v:val)')
	let l:nr = bufnr('%')
	if len(l:list)>1

		" special buffer
		if index(['quickfix','help'],&buftype)>=0
			return ":q\<CR>"
		endif

		let l:windows = winnr('$')
		if l:windows>1
			" if buflisted(l:nr)
			let l:listedCnt = 0
			let l:i=1
			while l:i <= l:windows
				if buflisted(winbufnr(l:i))
					let l:listedCnt+=1
				endif
				let l:i+=1
			endwhile
			" if current window is the only one with the listed buffer
			" delete the buffer
			" otherwise, close the window
			if buflisted(l:nr) && (l:listedCnt==1)
				return s:key_switch_buffer_before_bd(l:nr,l:list) . ":bd " . l:nr . "\<CR>"
			else
				return ":q\<CR>"
			endif
		else
			if index(l:list,l:nr)>=0 && len(l:list)==1
				" if this is the only listed buffer
				return ":q\<CR>"
			else
				return s:key_switch_buffer_before_bd(l:nr,l:list) . ":bd " . l:nr . "\<CR>"
			endif
		endif
	else
		return ":q\<CR>"
	endif
endfunc

func! tweak#wtb_switch#key_leader_bufnum(num)
	call s:init()
	let l:buffers = s:listed_buffers()
	let l:input = a:num . ""

	while 1

		let l:cnt = 0
		let l:i=0
		let l:exactCnt = 0
		" count matches
		while l:i<len(l:buffers)
			let l:bn = l:buffers[l:i] . ""
			if l:input==l:bn[0:len(l:input)-1]
				let l:cnt+=1
			endif
			if l:input == l:bn
				let l:exactCnt+=1
			endif
			let l:i+=1
		endwhile

		" no matches
		if l:cnt==0 && len(l:input)>0
			" echoerr is a bit annoying, use echohl instead
			echohl WarningMsg | echo "No buffer [" . l:input . "]" | echohl None
			return ''
		elseif l:cnt==1 && l:exactCnt==1
			return tweak#wtb_switch#key_switch_buffer_in_this_page(":b " . l:input . "\<CR>")
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
		elseif l:n==char2nr("\<C-c>")
			return ''
		elseif l:n==char2nr("\<CR>") || (l:n<char2nr('0') || l:n>char2nr('9'))
			return tweak#wtb_switch#key_switch_buffer_in_this_page(":b " . l:input . "\<CR>")
		else
			let l:input = l:input . nr2char(l:n)
		endif

		let g:n = l:n

	endwhile

endfunc

func! s:listed_buffers()
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunc


func! s:buf_win_enter()
	let l:nr = bufnr('%')
	if buflisted(l:nr)
		let g:tweak#wtb_switch#listed_buf_access_history = add(get(g:,'tweak#wtb_switch#listed_buf_access_history',[]),l:nr)
		" do not exceeds 100
		if len(g:tweak#wtb_switch#listed_buf_access_history) > 100
			call remove(g:tweak#wtb_switch#listed_buf_access_history,0,9)
		endif
	endif
endfunc

func! s:key_switch_buffer_before_bd(nr,list)
	let g:tweak#wtb_switch#listed_buf_access_history = get(g:,'tweak#wtb_switch#listed_buf_access_history',[])

	if len(g:tweak#wtb_switch#listed_buf_access_history)>0
		let l:pos = len(g:tweak#wtb_switch#listed_buf_access_history)-1
		while l:pos>=0
			let l:nr=g:tweak#wtb_switch#listed_buf_access_history[l:pos]
			if l:nr!=a:nr && buflisted(l:nr)
				call remove(g:tweak#wtb_switch#listed_buf_access_history,l:pos,-1)
				return ":b " . l:nr . "\<CR>"
			endif
			let l:pos -= 1
		endwhile
	endif

	let l:i = index(a:list,a:nr)
	if l:i==0
		return ":bn\<CR>"
	else
		return ":bp\<CR>"
	endif
endfunc


" func! tweak#wtb_switch#key_bufer()
" 	let l:shm     = &shortmess
" 	let l:ch      = &cmdheight
" 	try
" 		let l:buffers = s:listed_buffers()
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



" let bufs = map(s:listed_buffers(), 'tweak#wtb_switch#format_buffer(v:val)')
