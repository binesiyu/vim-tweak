" smart window/tab/buffer switching utilities
" smart tab/buffer switching. nice integrated with airline
" 
" usage:
" nnoremap <expr> <Leader>1 tweak#wtb_switch#key_leader_bufnum(1)
" nnoremap <expr> <Leader>2 tweak#wtb_switch#key_leader_bufnum(2)
" nnoremap <expr> <Leader>3 tweak#wtb_switch#key_leader_bufnum(3)
" nnoremap <expr> <Leader>4 tweak#wtb_switch#key_leader_bufnum(4)
" nnoremap <expr> <Leader>5 tweak#wtb_switch#key_leader_bufnum(5)
" nnoremap <expr> <Leader>6 tweak#wtb_switch#key_leader_bufnum(6)
" nnoremap <expr> <Leader>7 tweak#wtb_switch#key_leader_bufnum(7)
" nnoremap <expr> <Leader>8 tweak#wtb_switch#key_leader_bufnum(8)
" nnoremap <expr> <Leader>9 tweak#wtb_switch#key_leader_bufnum(9)
" nnoremap <expr> <S-l>     tweak#wtb_switch#key_next()
" nnoremap <expr> <S-h>     tweak#wtb_switch#key_prev()
" nnoremap <expr> <S-q>     tweak#wtb_switch#key_quit()
"
" others:
" nnoremap <expr> <C-f><C-f> tweak#wtb_switch#key_switch_buffer_in_this_page(":FZF\<CR>")

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
	return tabpagenr("$")>1
endfunc

" Automatically select the window for buffer switching
func! tweak#wtb_switch#key_switch_buffer_in_this_page(key)
	call s:init()
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
		return a:key
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
				return s:key_switch_buffer_before_bd(l:nr,l:list) . ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
			else
				return ":q\<CR>"
			endif
		else
			if index(l:list,l:nr)>=0 && len(l:list)==1
				" if this is the only listed buffer
				return ":q\<CR>"
			else
				return s:key_switch_buffer_before_bd(l:nr,l:list) . ":try | bd " . l:nr . " | catch | b " . l:nr . " | endtry\<CR>"
			endif
		endif
	else
		return ":q\<CR>"
	endif
endfunc

nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum) ''
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)1 tweak#wtb_switch#key_leader_bufnum(1,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)2 tweak#wtb_switch#key_leader_bufnum(2,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)3 tweak#wtb_switch#key_leader_bufnum(3,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)4 tweak#wtb_switch#key_leader_bufnum(4,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)5 tweak#wtb_switch#key_leader_bufnum(5,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)6 tweak#wtb_switch#key_leader_bufnum(6,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)7 tweak#wtb_switch#key_leader_bufnum(7,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)8 tweak#wtb_switch#key_leader_bufnum(8,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)9 tweak#wtb_switch#key_leader_bufnum(9,1)
nnoremap <expr> <Plug>(tweak#wtb_switch#key_leader_bufnum)0 tweak#wtb_switch#key_leader_bufnum(0,1)


func! tweak#wtb_switch#key_leader_bufnum(num,...)
	call s:init()

	let l:usePrefix = get(a:,'1',0)
	if l:usePrefix
		let l:prefix = g:tweak#wtb_switch#key_leader_bufnum_prefix
	else
		let l:prefix = ''
		let g:tweak#wtb_switch#key_leader_bufnum_start_nr = bufnr('%')
	endif

	let l:input = l:prefix . a:num . ""

	let g:tweak#wtb_switch#key_leader_bufnum_prefix = l:input

	let l:cnt   = 0
	let l:exact = 0
	" count matches
	let l:buffers = s:listed_buffers()
	if l:input=='$' || l:input=='^'
		if l:input=='$'
			let l:input=l:buffers[-1]
		else
			let l:input=l:buffers[0]
		endif
		let l:cnt=1
		let l:exact=1
	else
		for l:bn in l:buffers
			if l:input==l:bn[0:len(l:input)-1]
				let l:cnt+=1
			endif
			if l:input == l:bn
				let l:exact=1
			endif
		endfor
	endif

	" no matches
	if l:cnt==0
		" echoerr is a bit annoying, use echohl instead
		let g:tweak#wtb_switch#key_leader_bufnum_tmpnr = 0
		echohl WarningMsg | echo "No buffer [" . l:input . "]" | echohl None
		return ''
	elseif l:exact==0
		" need more input
		return tweak#wtb_switch#key_switch_buffer_in_this_page(':call feedkeys("\<Plug>(tweak#wtb_switch#key_leader_bufnum)")' . "\<CR>")
	endif

	let l:keepjumps = ''
	let l:setOldfile = ''
	if l:usePrefix && get(g:,'tweak#wtb_switch#key_leader_bufnum_tmpnr',0)
		call s:listedbuf_history_remove_tail(g:tweak#wtb_switch#key_leader_bufnum_start_nr)
		let l:keepjumps = 'keepjumps '
		let l:setOldfile = ' | let @# =' . g:tweak#wtb_switch#key_leader_bufnum_start_nr
	endif

	if l:exact && l:cnt==1
		" This is the only match
		let g:tweak#wtb_switch#key_leader_bufnum_tmpnr = 0
		return tweak#wtb_switch#key_switch_buffer_in_this_page(":" . l:keepjumps . " b " . l:input . l:setOldfile . "\<CR>")
	elseif l:exact && l:cnt>1
		" There's an exact match, but we still needs more input to verify
		let g:tweak#wtb_switch#key_leader_bufnum_tmpnr = l:input
		return tweak#wtb_switch#key_switch_buffer_in_this_page(":" . l:keepjumps . " b " . l:input . ' | call feedkeys("\<Plug>(tweak#wtb_switch#key_leader_bufnum)")' . l:setOldfile . "\<CR>")
	endif

endfunc

func! s:listed_buffers()
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunc

let g:tweak#wtb_switch#listedbuf_history = []
func! s:buf_win_enter()
	let l:nr = bufnr('%')
	if buflisted(l:nr)
		call add(g:tweak#wtb_switch#listedbuf_history,l:nr)
		" remove duplicated history
		while (len(g:tweak#wtb_switch#listedbuf_history)>=2) && (g:tweak#wtb_switch#listedbuf_history[-1]==g:tweak#wtb_switch#listedbuf_history[-2])
			call remove(g:tweak#wtb_switch#listedbuf_history,-1)
		endwhile
		" do not exceeds 100
		if len(g:tweak#wtb_switch#listedbuf_history) > 100
			call remove(g:tweak#wtb_switch#listedbuf_history,0,9)
		endif
	endif
endfunc

func! s:listedbuf_history_remove_tail(tillNr)
	if len(g:tweak#wtb_switch#listedbuf_history)==0
		return
	endif
	if g:tweak#wtb_switch#listedbuf_history[-1]!=a:tillNr
		call remove(g:tweak#wtb_switch#listedbuf_history,-1)
	endif
endfunc

func! s:key_switch_buffer_before_bd(nr,list)
	let g:tweak#wtb_switch#listedbuf_history = get(g:,'tweak#wtb_switch#listedbuf_history',[])

	if len(g:tweak#wtb_switch#listedbuf_history)>0
		let l:pos = len(g:tweak#wtb_switch#listedbuf_history)-1
		while l:pos>=0
			let l:nr=g:tweak#wtb_switch#listedbuf_history[l:pos]
			if l:nr!=a:nr && buflisted(l:nr)
				call remove(g:tweak#wtb_switch#listedbuf_history,l:pos,-1)
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

