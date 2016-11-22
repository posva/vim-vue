# vim-vue

Vim syntax highlighting for [Vue
components](https://vuejs.org/v2/guide/single-file-components.html).

This was initially forked from
[darthmall/vim-vue](https://github.com/darthmall/vim-vue). I already have an
implementation for this but found his code much cleaner. That's why I created a
new version instead of a PR.

## Installation

### Install with [Vundle](https://github.com/VundleVim/Vundle.vim)

`Plugin 'posva/vim-vue'`

### Install with [Pathogen](https://github.com/tpope/vim-pathogen)

```
cd ~/.vim/bundle && \
git clone https://github.com/posva/vim-vue.git
```

### Integration with [Syntastic](https://github.com/scrooloose/syntastic)

Currently only `eslint` is available. Please make sure `eslint` and
`eslint-plugin-vue` are installed:

```bash
npm i -g eslint eslint-plugin-vue
```

## Contributing

If your language is not getting highlighted open an issue or a PR with the fix.
You only need to add some lines to the `syntax/vue.vim` file.

## FAQ

Where is Jade?

[Jade has been renamed to pug](https://github.com/pugjs/jade/issues/2184).
Therefore you have to replace all your `jade` occurrences with `pug`. The new
plugin for `pug` can be found on [the same repository](https://github.com/digitaltoad/vim-pug) (the name has already been updated).
