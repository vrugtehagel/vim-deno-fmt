vim9script

const deno_exists = system('command -v deno')
if !deno_exists | finish | endif

def MaybeDenoFmt(): void
	var directory = expand('%:p:h')
	var previous_directory = ''
	while !filereadable(directory .. '/deno.json')
		if previous_directory == directory | return | endif
		previous_directory = directory
		directory = fnamemodify(directory, ':h')
	endwhile
	const view = winsaveview()
	silent execute('!deno fmt %:p >& /dev/null')
	edit! %:p
	winrestview(view)
enddef

autocmd_add([{
	group: 'vim_deno_fmt',
	event: 'BufWritePost',
	pattern: '*',
	cmd: 'MaybeDenoFmt()',
	replace: true,
}])
