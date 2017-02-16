" smart window/tab/buffer switching utilities
" smart tab/buffer switching. nice integrated with airline
" 
" usage:
" nnoremap <expr> <S-l>     tweak#wtb_switch#key_next()
" nnoremap <expr> <S-h>     tweak#wtb_switch#key_prev()
" nnoremap <expr> <S-q>     tweak#wtb_switch#key_quit()
"
" others:
" nnoremap <expr> <C-f><C-f> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZF\<CR>")

func! s:is_multi_tabpage()
	return tabpagenr("$")>1
endfunc

func! s:is_normal_buffer(nr)
	return buflisted(a:nr) && getbufvar(a:nr,'&buftype')==''
endfunc

func! s:get_normal_windows()
	let l:ret = []
	let l:windows = winnr('$')
	let l:i=1
	while l:i <= l:windows
		if s:is_normal_buffer(winbufnr(l:i))
			call add(l:ret,l:i)
		endif
		let l:i+=1
	endwhile
	return l:ret
endfunc

" Automatically select the window for buffer switching
func! tweak#wtb_switch#key_switch_buffer_in_this_page(key)
	if s:is_normal_buffer(winbufnr('.'))
		return a:key
	endif
	let l:windows = s:get_normal_windows()
	if len(l:windows) == 1
		" If there's only one window with listed buffer, swith to this window
		" to use it for switching
		return ":" . l:windows[0] . "windo echo \<CR>" . a:key
	elseif len(l:windows) == 0
		" we have no other option here :)
		return a:key
	else
		echom "Please use a normal window for the switch!!!"
		return ''
	endif
endfunc

func! tweak#wtb_switch#key_next()
	if s:is_multi_tabpage()
		return ":tabn\<CR>"
	endif
	return tweak#wtb_switch#key_switch_buffer_in_this_page(":bn\<CR>")
endfunc

func! tweak#wtb_switch#key_prev()
	if s:is_multi_tabpage()
		return ":tabp\<CR>"
	endif
	return tweak#wtb_switch#key_switch_buffer_in_this_page(":bp\<CR>")
endfunc

func! tweak#wtb_switch#key_quit()

	if s:is_multi_tabpage()
		return ":tabclose\<CR>"
	endif

	let l:normal_buffers = filter(range(1, bufnr('$')), 's:is_normal_buffer(v:val)')
	let l:nr = bufnr('%')
	if len(l:normal_buffers)>1

		" special buffer
		if index(['quickfix','help'],&buftype)>=0
			return ":q\<CR>"
		endif

		let l:windows = winnr('$')
		if l:windows>1
			let l:normal_cnt = len(s:get_normal_windows())
			" if current window is the only one with the listed buffer, delete
			" the buffer
			" otherwise, close the window
			if s:is_normal_buffer(l:nr) && l:normal_cnt==1
				return ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
			else
				return ":q\<CR>"
			endif
		else
			" the only window
			return ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
		endif
	else
		if bufname('%')!='' && s:is_normal_buffer(l:nr)
			" normal buffer with a name, which means it is associated with a
			" file. Close the buffer instead of close the window and end up
			" closing vim. 
			return ":bd\<CR>"
		endif
		return ":q\<CR>"
	endif
endfunc

