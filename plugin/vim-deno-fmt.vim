" File: vim-deno-fmt.vim
" Description: Run `deno fmt` whenever it makes sense
" Maintainer: vrugtehagel
" License: MIT

if exists('g:loaded_vim_deno_fmt') | finish | endif
let g:loaded_vim_deno_fmt = 1

function s:MaybeDenoFmt()
	let l:directory = expand('%:p:h')
	let l:previous_directory = ''
	while !filereadable(l:directory . '/deno.json')
		if l:previous_directory == l:directory | return | endif
		let l:previous_directory = l:directory
		let l:directory = fnamemodify(l:directory, ':h')
	endwhile
	let l:view = winsaveview()
	silent execute('!deno fmt %:p >& /dev/null')
	edit! %:p
	call winrestview(l:view)
endfunction

let s:deno_exists = system('command -v deno')
augroup vim_deno_fmt
	if strlen(s:deno_exists) > 0
		autocmd BufWritePost * call s:MaybeDenoFmt()
	endif
augroup END
