
" I offten ended up open quite a bunch of buffers when editting using vim.
" This module auto close non editting normal buffers which you open by
" jumpping to references, I feel clean this way, etc.


" usage: 
"
" call tweak#only_editting_buffers#init()

func! tweak#only_editting_buffers#init()

	let s:last_buffer = 0
	let s:last_buftype = ''

	augroup only_editting_buffers
			au!
			au BufWritePre * let b:edit_focus_modified = 1
			au BufLeave * let s:last_buffer = bufnr('%') | let s:last_buftype=&buftype
			au BufEnter * call <sid>on_buf_enter()
	augroup end

endfunc

func! s:on_buf_enter()
        if s:last_buffer==0
                return
        endif
        let l:modified =  getbufvar(s:last_buffer,'edit_focus_modified',0) || getbufvar(s:last_buffer,'&modified')
        if l:modified==0 && bufwinid(s:last_buffer)==-1 && buflisted(s:last_buffer) && s:last_buftype==''
                " normal buffer that has not been modified or written to file, and not
                " opened
                exec 'bd ' . s:last_buffer
        endif
        let s:last_buffer = 0
endfunc

