" Vim filetype plugin
" Language: Svelte
" Maintainer: Eduardo San Martin Morote
" Author: Adriaan Zonnenberg

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/html.vim

setlocal suffixesadd+=.svelte

if !exists('g:no_plugin_maps') && !exists('g:no_svelte_maps')
  nnoremap <silent> <buffer> [[ :call search('^<\(script\<Bar>style\)', 'bW')<CR>
  nnoremap <silent> <buffer> ]] :call search('^<\(script\<Bar>style\)', 'W')<CR>
  nnoremap <silent> <buffer> [] :call search('^</\(script\<Bar>style\)', 'bW')<CR>
  nnoremap <silent> <buffer> ][ :call search('^</\(script\<Bar>style\)', 'W')<CR>
endif
