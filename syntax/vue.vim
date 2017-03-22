" Vim syntax file
" Language: Vue.js
" Maintainer: Eduardo San Martin Morote

if exists("b:current_syntax")
  finish
endif

""
" Get the pattern for a HTML {name} attribute with {value}.
function! s:attr(name, value)
  return a:name . '=\("\|''\)[^\1]*' . a:value . '[^\1]*\1'
endfunction

""
" Check whether a syntax file for a given {language} exists.
function! s:syntax_available(language)
  return !empty(globpath(&runtimepath, 'syntax/' . a:language . '.vim'))
endfunction

""
" Register {language} for a given {tag}.
" If [omit_attr] is 1, the 'lang' attribute may be omitted.
" If [attr_override] is given and not empty, it will be used for the attribute pattern.
function! s:register_language(language, tag, ...)
  let omit_attr = a:0 ? a:1 : 0
  let attr_override = a:0 >= 2 ? a:2 : ''

  if omit_attr
    let start_pattern = ''
  else
    let start_pattern = ' \_[^>]*'
    let start_pattern .= !empty(attr_override) ? attr_override : s:attr('lang', a:language)
  endif

  if s:syntax_available(a:language)
    execute 'syntax include @' . a:language . ' syntax/' . a:language . '.vim'
    unlet! b:current_syntax
    execute 'syntax region vue_' . a:language
          \ 'keepend'
          \ 'matchgroup=Delimiter'
          \ 'start=/^<' . a:tag . start_pattern . '\_[^>]*>/'
          \ 'end="^</' . a:tag . '>"'
          \ 'contains=@' . a:language
          \ 'fold'
  endif
endfunction

call s:register_language('html', 'template', 1)
call s:register_language('pug', 'template', 0, s:attr('lang', '\%(pug\|jade\)'))
call s:register_language('slm', 'template')
call s:register_language('handlebars', 'template')
call s:register_language('javascript', 'script', 1)
call s:register_language('typescript', 'script', 0, '\%(lang=\("\|''\)[^\1]*\(ts\|typescript\)[^\1]*\1\|ts\)')
call s:register_language('coffee', 'script')
call s:register_language('css', 'style', 1)
call s:register_language('stylus', 'style')
call s:register_language('sass', 'style')
call s:register_language('scss', 'style')
call s:register_language('less', 'style')

let b:current_syntax = "vue"
