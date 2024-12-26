# VIM deno fmt

Run deno fmt whenever it makes sense.

This is a very simple plugin that runs `deno fmt` whenever a file within a Deno
project is written to. This is detected by the presence of a `deno.json` file in
any of the written-to file's parent directories.

## Installation

This plugin requires the latest version of VIM (it may or may not work on older
versions). To install the plugin, first navigate to your VIM plugins folder:

```bash
cd ~/.vim/pack/plugins/start
```

then clone this repository using

```bash
git clone git@github.com:vrugtehagel/vim-deno-fmt.git
```

And that's it!
