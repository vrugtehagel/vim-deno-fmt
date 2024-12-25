" File: vim-deno-fmt.vim
" Description: Run `deno fmt` whenever it makes sense
" Maintainer: vrugtehagel
" Version: 0.1
" License: MIT

if exists('g:loaded_vim_deno_fmt') | finish | endif
let g:loaded_vim_deno_fmt = 1

function s:MaybeDenoFmt()
	let directory = expand('%:p:h')
	let previous_directory = ''
	while !filereadable(directory . '/deno.json')
		if previous_directory == directory | return | endif
		let previous_directory = directory
		let directory = fnamemodify(directory, ':h')
	endwhile
	let view = winsaveview()
	silent execute('!deno fmt %:p >& /dev/null')
	edit! %:p
	call winrestview(view)
endfunction

let s:deno_exists = system('command -v deno')
augroup vim_deno_fmt
	if strlen(s:deno_exists) > 0
		autocmd BufWritePost * call s:MaybeDenoFmt()
	endif
augroup END
