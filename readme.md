# vim-svelte 

Vim syntax highlighting for [Svelte components](https://v3.svelte.technology).

This was forked from
[posva/vim-vue](https://github.com/posva/vim-vue). Most of this is just s/vue/svelte/g.

## Installation

### Install with [Vundle](https://github.com/VundleVim/Vundle.vim)

```viml
Plugin 'edmorrish/vim-svelte'
```

### Install with [Pathogen](https://github.com/tpope/vim-pathogen)

```bash
cd ~/.vim/bundle && \
git clone https://github.com/edmorrish/vim-svelte.git
```

### Install without a plugin manager (Vim 8)

```bash
git clone https://github.com/edmorrish/vim-svelte.git ~/.vim/pack/plugins/start/vim-svelte
```

### Integration with [Syntastic](https://github.com/scrooloose/syntastic) or [ALE](https://github.com/w0rp/ale)

I haven't tested the eslint integration at all, but the vue version worked so this might...
Currently only `eslint` is available. Please make sure
[eslint](http://eslint.org/) and
[eslint-plugin-svelte](https://github.com/vuejs/eslint-plugin-svelte) are installed
and properly [configured](https://github.com/vuejs/eslint-plugin-svelte):

```bash
npm i -g eslint eslint-plugin-svelte3
eslint --init
```
Add something like this to your vimrc file:

```vim
let g:syntastic_svelte_checkers = ['javascript/eslint', 'html/htmlhint']
```

## Contributing

If your language is not getting highlighted open an issue or a PR with the fix.
You only need to add a line to the `syntax/svelte.vim` file.

Don't forget to write [Vader](https://github.com/junegunn/vader.vim) tests for
the code you write. You can run the tests by executing `make test` in the
terminal.

## FAQ

### Where is Jade?

[Jade has been renamed to pug](https://github.com/pugjs/jade/issues/2184).
Therefore you have to replace all your `jade` occurrences with `pug`. The new
plugin for `pug` can be found on [the same repository](https://github.com/digitaltoad/vim-pug)
(the name has already been updated).

### My syntax highlighting stops working randomly

This is because Vim tries to highlight text in an efficient way. Especially in
files that include multiple languages, it can get confused. To work around
this, you can run `:syntax sync fromstart` when it happens.

You can also setup an autocmd for this, so that every time a Vue file is
opened, `:syntax sync fromstart` will be executed pre-emptively:

```vim
autocmd FileType svelte syntax sync fromstart
```

See `:h :syn-sync-first` and [this article](http://vim.wikia.com/wiki/Fix_syntax_highlighting)
for more details.

### How to use commenting functionality with multiple languages in Vue files?

#### [caw.vim](https://github.com/tyru/caw.vim)

caw.vim features built-in support for file context through [context_filetype.vim](https://github.com/Shougo/context_filetype.vim). Just install both plugins and context-aware commenting will work in most files. The fenced code is detected by predefined regular expressions.

### _Vim slows down when using this plugin_ How can I fix that?

Add `let g:svelte_disable_pre_processors=1` in your .vimrc to disable checking for prepocessors. When checking for preprocessor languages, multiple syntax highlighting checks are done, which can slow down vim. This variable prevents vim-svelte from supporting **every** pre-processor language highlighting.
