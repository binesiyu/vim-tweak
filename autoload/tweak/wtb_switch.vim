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

	let l:normal_buf_cnt = len(filter(range(1, bufnr('$')), 's:is_normal_buffer(v:val)'))
	let l:normal_win_cnt = len(s:get_normal_windows())
	let l:nr = bufnr('%')
	if len(l:normal_buf_cnt)>1

		" special buffer
		if index(['quickfix','help'],&buftype)>=0
			return ":q\<CR>"
		endif

		let l:windows = winnr('$')
		if l:windows>1
			" if current window is the only one with the listed buffer, delete
			" the buffer
			" otherwise, close the window
			if s:is_normal_buffer(l:nr) && l:normal_win_cnt==1
				return ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
			else
				return ":q\<CR>"
			endif
		else
			" the only window
			return ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
		endif
	else
		if bufname(l:nr)!='' && s:is_normal_buffer(l:nr) && l:normal_win_cnt==1
			" normal buffer with a name, which means it is associated with a
			" file. Close the buffer instead of close the window and end up
			" closing vim. 
			return ":bd\<CR>"
		endif
		" `l:normal_win_cnt==1` for closing the window when the same
		" opeded buffer is displayed in two splitted window
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
            echo "no buffer [" . l:input . "]"
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
