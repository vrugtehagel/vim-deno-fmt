vim9script

const deno_exists = system('command -v deno')
if !deno_exists | finish | endif

def MaybeDenoFmt(): void
	const file = expand('%:p')
	var directory = expand('%:p:h')
	var previous_directory = ''
	while !filereadable(directory .. '/deno.json')
		if previous_directory == directory | return | endif
		previous_directory = directory
		directory = fnamemodify(directory, ':h')
	endwhile
	const json = readfile(directory .. '/deno.json')->join('')
	const config = json_decode(json)
	if !config->has_key('fmt') | return | endif
	var included = []
	for include in config.fmt->get('include', ['**/*'])
		included += globpath(directory, include, false, true)
	endfor
	included->filter((_, dir) => stridx(file, dir) == 0)
	if included->len() == 0 | return | endif
	var ignore = ''
	if config.fmt->has_key('exclude')
		ignore = '--ignore=' .. config.fmt.exclude->join(',')
	endif
	const view = winsaveview()
	silent execute('!deno fmt ' .. ignore .. ' %:p >& /dev/null')
	edit! %:p
	winrestview(view)
enddef

autocmd_add([{
	group: 'VimDenoFmt',
	event: 'BufWritePost',
	pattern: '*',
	cmd: 'MaybeDenoFmt()',
	replace: true,
}])
