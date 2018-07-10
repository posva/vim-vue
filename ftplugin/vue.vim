" Vim filetype plugin
" Language: Vue.js
" Maintainer: Eduardo San Martin Morote
" Author: Adriaan Zonnenberg

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/html.vim

setlocal suffixesadd+=.vue

if !exists('g:no_plugin_maps') && !exists('g:no_vue_maps')
  nnoremap <silent> <buffer> [[ :call search('^<\(template\<Bar>script\<Bar>style\)', 'bW')<CR>
  nnoremap <silent> <buffer> ]] :call search('^<\(template\<Bar>script\<Bar>style\)', 'W')<CR>
  nnoremap <silent> <buffer> [] :call search('^</\(template\<Bar>script\<Bar>style\)', 'bW')<CR>
  nnoremap <silent> <buffer> ][ :call search('^</\(template\<Bar>script\<Bar>style\)', 'W')<CR>
endif

" Run only ESLint and stylelint for Vue files by default.
" linters specifically for Vue can still be loaded.
let b:ale_linter_aliases = ['vue', 'javascript', 'css']
let b:ale_linters = ['eslint', 'stylelint']
