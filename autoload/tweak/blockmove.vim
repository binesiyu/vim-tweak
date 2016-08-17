
" usage:
" noremap <expr>{ tweak#blockmove#up_key()
" noremap <expr>} tweak#blockmove#down_key()

function! tweak#blockmove#up_key()
	let l:firstVisableLine = line('w0')
	let l:lastVisableLine  = line('w$')
	let l:l = line(".")
	let l:skipThis=1
	while (l:l > 1)

		let l:whiteSpaceLine = 0
		let l:lineStr = getbufline("%",l)[0]

		if(lineStr =~ "^[[:blank:]\r]*$")
			let l:whiteSpaceLine = 1
		endif

		if (l:whiteSpaceLine==1)
			if l:skipThis==0
				break
			endif
		else
			let l:skipThis = 0
		endif

		let l:l = l:l-1
	endwhile
	let l:zz_Key = ''
	" if (l:l < (l:firstVisableLine+l:lastVisableLine)/2)
	" 	let l:zz_Key = 'zz'
	" endif
	return (l:l) . "G" . l:zz_Key . "$"
endfunction

function! tweak#blockmove#down_key()
	let l:firstVisableLine = line('w0')
	let l:lastVisableLine = line('w$')
	let l:l = line(".")
	let l:skipThis=1
	while (1)

		let l:whiteSpaceLine = 0
		let l:lineArr = getbufline("%",l)
		if ( len(l:lineArr)==0)		" endi of file
			let l:l = l:l-1
			break
		endif

		let l:lineStr = l:lineArr[0]
		if(lineStr =~ "^[[:blank:]\r]*$")
			let l:whiteSpaceLine = 1
		endif

		if (l:whiteSpaceLine==1)
			if l:skipThis==0
				break
			endif
		else
			let l:skipThis = 0
		endif
      
		let l:l = l:l+1
	endwhile
	let l:zz_Key = ''
	" if (l:l > (l:firstVisableLine+l:lastVisableLine)/2)
	" 	let l:zz_Key = 'zz'
	" endif
	return l:l . "G" . l:zz_Key . "$"
	return
endfunction

