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

" If not exist, set the default value
if !exists('g:vue_pre_processors')
  let g:vue_pre_processors = 'detect_on_enter'
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

function! s:should_register(language, start_pattern)
  " Check whether a syntax file for {language} exists
  if empty(globpath(&runtimepath, 'syntax/' . a:language . '.vim'))
    return 0
  endif

  if exists('g:vue_pre_processors')
    if type(g:vue_pre_processors) == v:t_list
      return index(g:vue_pre_processors, s:language.name) != -1
    elseif g:vue_pre_processors is# 'detect_on_enter'
      return search(a:start_pattern, 'n') != 0
    endif
  endif

  return 1
endfunction

" If you want to add a js_values_syntax for a language, you need to add a
" function named 's:js_values_for_<name of the language>' in this file
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

function! s:js_values_for_html()
  " Prevent 0 length vue dynamic attributes (:id="") from overflowing from
  " the area described by two quotes ("" or '') this works because syntax
  " defined earlier in the file have priority.
  syn match htmlString /\(\([@#:]\|v-\)[-:.0-9_a-z\[\]]*=\)\@<=""/ containedin=ALLBUT,htmlComment
  syn match htmlString /\(\([@#:]\|v-\)[-:.0-9_a-z\[\]]*=\)\@<=''/ containedin=ALLBUT,htmlComment

  " Actually provide the JavaScript syntax highlighting.

  " for double quotes (") and for single quotes (')
  " It's necessary to have both because we can't start a region with double
  " quotes and it with a single quote, and removing `keepend` would result in
  " side effects.
  syn region vueJavascriptInTemplate start=/\(\s\([@#:]\|v-\)\([-:.0-9_a-z]*\|\[.*\]\)=\)\@<="/ms=e+1 keepend end=/"/me=s-1 contains=@jsAll containedin=ALLBUT,htmlComment
  syn region vueJavascriptInTemplate start=/\(\s\([@#:]\|v-\)\([-:.0-9_a-z]*\|\[.*\]\)=\)\@<='/ms=e+1 keepend end=/'/me=s-1 contains=@jsAll containedin=ALLBUT,htmlComment
  " This one is for #[thisHere] @[thisHereToo] :[thisHereAlso]
  syn region vueJavascriptInTemplate matchgroup=htmlArg start=/[@#:]\[/ keepend end=/\]/ contains=@jsAll containedin=ALLBUT,htmlComment
endfunction

" Eager load html, because it's not a pre-processor, and being loaded since the
" start (for the tags), it's kinda counter intuitive that you need to load the
" html pre-processor if the syntax is already mostly correct.
call s:js_values_for_html()

for s:language in s:languages
  let s:attr_pattern = has_key(s:language, 'attr_pattern') ? s:language.attr_pattern : s:attr('lang', s:language.name)
  let s:start_pattern = '<' . s:language.tag . '\>\_[^>]*' . s:attr_pattern . '\_[^>]*>'

  if s:should_register(s:language.name, s:start_pattern)
    " Skip the syntax loading for html because it's already loaded as base
    if (s:language.name != 'html')
      execute 'syntax include @' . s:language.name . ' syntax/' . s:language.name . '.vim'
      unlet! b:current_syntax
      execute 'syntax region vue_' . s:language.name
            \ 'keepend'
            \ 'start=/' . s:start_pattern . '/'
            \ 'end="</' . s:language.tag . '>"me=s-1'
            \ 'contains=@' . s:language.name . ',vueSurroundingTag'
            \ 'fold'
    endif

    if has_key(s:language, 'js_values_syntax')
      execute 'call s:js_values_for_' . s:language.name . '()'
    endif
  endif
endfor

syn region  vueSurroundingTag   contained start=+<\(script\|style\|template\)+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syn keyword htmlSpecialTagName  contained template
syn keyword htmlArg             contained scoped ts
syn match   htmlArg "[@#v:a-z][-:.0-9_a-z]*\>" contained

" for mustaches quotes (`{{` and `}}`)
syn region vueJavascriptInTemplate matchgroup=htmlSpecialChar start=/{{/ keepend end=/}}/ contains=@jsAll containedin=ALLBUT,htmlComment

syntax sync fromstart

let b:current_syntax = "vue"

" vim: et tw=2 sts=2
