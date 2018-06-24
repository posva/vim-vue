" Vim indent file
" Language: Vue.js
" Maintainer: Eduardo San Martin Morote
" Author: Adriaan Zonnenberg

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" The order is important here, tags without attributes go last.
" HTML is included for <template> to apply policies set by
" g:vue_indent_open_close_tags and g:vue_indent_first_line. Anything
" outside pairs will also be handled by html.vim
if !exists('g:vue_indent_languages')
  let g:vue_indent_languages = [
        \   {'name': 'pug', 'pairs': ['<template lang="pug"', '</template>']},
        \   {'name': 'html', 'pairs': ['<template', '</template>'], 'first_line': 'html'},
        \   {'name': 'stylus', 'pairs': ['<style lang="stylus"', '</style>']},
        \   {'name': 'css', 'pairs': ['<style', '</style>']},
        \   {'name': 'coffee', 'pairs': ['<script lang="coffee"', '</script>']},
        \   {'name': 'javascript', 'pairs': ['<script', '</script>']},
        \ ]
endif

if !exists('g:vue_indent_open_close_tags')
  " Default of 0 forces open/close tags to the first column. Another
  " reasonable option is 'html' which defers to html.vim to set the
  " indentation.
  let g:vue_indent_open_close_tags = 0
endif

if !exists('g:vue_indent_first_line')
  " Default of -1 defers to autoindent which maintains the same indent as
  " the previous line (the opening tag). During re-indentation, this also
  " maintains whatever indent the user sets for the first line following
  " the opening tag. Other reasonable options are 0 (force first column) or
  " 'html' (defer to html.vim)
  let g:vue_indent_first_line = -1
endif

" Load and return the indentexpr for language, resetting indentexpr to its
" prior value before returning.
function! s:get_indentexpr(language)
  let saved_indentexpr = &indentexpr
  " Default to blank to indicate that this language did not set indentexpr.
  let &l:indentexpr = ''
  if strlen(globpath(&rtp, 'indent/'. a:language .'.vim'))
    unlet! b:did_indent
    execute 'runtime! indent/' . a:language . '.vim'
    let b:did_indent = 1
  endif
  let lang_indentexpr = &indentexpr
  let &l:indentexpr = saved_indentexpr
  return lang_indentexpr
endfunction

let s:html_indent = s:get_indentexpr('html')

setlocal indentexpr=GetVueIndent(v:lnum)

if exists('*GetVueIndent')
  finish
endif

function! GetVueIndent(...)
  let lnum = a:0 ? a:1 : getpos('.')[1]
  let indent = s:get_vue_indent(lnum)
  " NB: Strings compare as equal to 0, so 'html' == 0 is true, whoops.
  return type(indent) == type('html') && indent == 'html' ?
        \ eval(s:html_indent) : indent
endfunction

function! s:get_vue_indent(lnum)
  for language in g:vue_indent_languages
    let opening_tag_line = searchpair(language.pairs[0], '', language.pairs[1], 'bcrW')

    if opening_tag_line
      " If we're on the open/close tag, use g:vue_indent_open_close_tags
      if opening_tag_line == a:lnum
        return g:vue_indent_open_close_tags
      endif
      let closing_tag_line = searchpair(language.pairs[0], '', language.pairs[1], 'crW')
      if closing_tag_line == a:lnum
        return g:vue_indent_open_close_tags
      endif

      " If we're on the first line of the block after the opening tag,
      " use either language.first_line or g:vue_indent_first_line
      if opening_tag_line == prevnonblank(a:lnum - 1)
        return has_key(language, 'first_line') ? language.first_line : g:vue_indent_first_line
      endif

      " Look up the indentexpr for this language. This is cached, even if
      " falsy, so it's only loaded the first time.
      if !has_key(language, 'indentexpr')
        let language.indentexpr = s:get_indentexpr(language.name)
      endif
      if !empty(language.indentexpr)
        return eval(language.indentexpr)
      endif

      break
    endif
  endfor

  " Couldn't match a language, or language didn't provide indentexpr
  return 'html'
endfunction
