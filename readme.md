# vim-vue [![CircleCI](https://img.shields.io/circleci/project/github/posva/vim-vue.svg)](https://circleci.com/gh/posva/vim-vue)

Vim syntax highlighting for [Vue
components](https://vuejs.org/v2/guide/single-file-components.html).

This was initially forked from
[darthmall/vim-vue](https://github.com/darthmall/vim-vue). I already have an
implementation for this but found his code much cleaner. That's why I created a
new version instead of a PR.

## Installation

### Install with [Vundle](https://github.com/VundleVim/Vundle.vim)

```viml
Plugin 'posva/vim-vue'
```

### Install with [Pathogen](https://github.com/tpope/vim-pathogen)

```bash
cd ~/.vim/bundle && \
git clone https://github.com/posva/vim-vue.git
```

### Install without a plugin manager (Vim 8)

```bash
git clone https://github.com/posva/vim-vue.git ~/.vim/pack/plugins/start/vim-vue
```

### Integration with [Syntastic](https://github.com/scrooloose/syntastic) or [ALE](https://github.com/w0rp/ale)

Currently only `eslint` is available. Please make sure
[eslint](http://eslint.org/) and
[eslint-plugin-vue](https://github.com/vuejs/eslint-plugin-vue) are installed
and properly [configured](https://github.com/vuejs/eslint-plugin-vue#rocket-usage):

```bash
npm i -g eslint eslint-plugin-vue
```

## Contributing

If your language is not getting highlighted open an issue or a PR with the fix.
You only need to add a line to the `syntax/vue.vim` file.

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
autocmd FileType vue syntax sync fromstart
```

See `:h :syn-sync-first` and [this article](http://vim.wikia.com/wiki/Fix_syntax_highlighting)
for more details.

### How can I use existing configuration/plugins in Vue files?

If you already have some configuration for filetypes like html, css and
javascript (e.g. linters, completion), an easy way to use them in Vue files is
by setting compound filetypes like this:

```vim
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
```

:warning: This may cause problems, because some plugins will then treat the
whole buffer as html/javascript/css instead of only the part inside the tags.
Ideally, you should configure everything that you want to use in Vue files
individually.

### How to use commenting functionality with multiple languages in Vue files?

#### [caw.vim](https://github.com/tyru/caw.vim)

caw.vim features built-in support for file context through [context_filetype.vim](https://github.com/Shougo/context_filetype.vim). Just install both plugins and context-aware commenting will work in most files. The fenced code is detected by predefined regular expressions.

#### [NERDCommenter](https://github.com/scrooloose/nerdcommenter)

<details>
<summary>
To use NERDCommenter with Vue files, you can use its "hooks" feature to
temporarily change the filetype. <em>Click for an example.</em>
</summary>

```vim
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction
```

</details>

### _Vim slows down when using this plugin_ How can I fix that?

Add `let g:vue_disable_pre_processors=1` in your .vimrc to disable checking for prepocessors. When checking for preprocessor languages, multiple syntax highlighting checks are done, which can slow down vim. This variable prevents vim-vue from supporting **every** pre-processor language highlighting.
