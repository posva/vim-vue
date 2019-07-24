" Vim syntax file
" Language: Vue.js
" Maintainer: Eduardo San Martin Morote

if exists("b:current_syntax")
  finish
endif

" Convert deprecated variable to new one
if exists('g:vue_disable_pre_processors') && g:vue_disable_pre_processors
  let g:vue_pre_processors = []
endif

runtime! syntax/html.vim
syntax clear htmlTagName
syntax match htmlTagName contained "\<[a-zA-Z0-9:-]*\>"
unlet! b:current_syntax

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

let s:languages = [
      \ {'name': 'less',       'tag': 'style'},
      \ {'name': 'pug',        'tag': 'template', 'attr_pattern': s:attr('lang', '\%(pug\|jade\)')},
      \ {'name': 'slm',        'tag': 'template'},
      \ {'name': 'handlebars', 'tag': 'template'},
      \ {'name': 'haml',       'tag': 'template'},
      \ {'name': 'typescript', 'tag': 'script', 'attr_pattern': '\%(lang=\("\|''\)[^\1]*\(ts\|typescript\)[^\1]*\1\|ts\)'},
      \ {'name': 'coffee',     'tag': 'script'},
      \ {'name': 'stylus',     'tag': 'style'},
      \ {'name': 'sass',       'tag': 'style'},
      \ {'name': 'scss',       'tag': 'style'},
      \ ]

for s:language in s:languages
  if !exists("g:vue_pre_processors") || index(g:vue_pre_processors, s:language.name) != -1
    let s:attr_pattern = has_key(s:language, 'attr_pattern') ? s:language.attr_pattern : s:attr('lang', s:language.name)

    if s:syntax_available(s:language.name)
      execute 'syntax include @' . s:language.name . ' syntax/' . s:language.name . '.vim'
      unlet! b:current_syntax
      execute 'syntax region vue_' . s:language.name
            \ 'keepend'
            \ 'start=/<' . s:language.tag . '\>\_[^>]*' . s:attr_pattern . '\_[^>]*>/'
            \ 'end="</' . s:language.tag . '>"me=s-1'
            \ 'contains=@' . s:language.name . ',vueSurroundingTag'
            \ 'fold'
    endif
  endif
endfor

syn region  vueSurroundingTag   contained start=+<\(script\|style\|template\)+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syn keyword htmlSpecialTagName  contained template
syn keyword htmlArg             contained scoped ts
syn match   htmlArg "[@v:][-:.0-9_a-z]*\>" contained

let b:current_syntax = "vue"
