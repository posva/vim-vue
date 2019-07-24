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

""
" Register {language} for a given {tag}. If [attr_override] is given and not
" empty, it will be used for the attribute pattern.
function! s:register_language(language, tag, ...)
  let attr_override = a:0 ? a:1 : ''
  let attr = !empty(attr_override) ? attr_override : s:attr('lang', a:language)

  if s:syntax_available(a:language)
    execute 'syntax include @' . a:language . ' syntax/' . a:language . '.vim'
    unlet! b:current_syntax
    execute 'syntax region vue_' . a:language
          \ 'keepend'
          \ 'start=/<' . a:tag . '\>\_[^>]*' . attr . '\_[^>]*>/'
          \ 'end="</' . a:tag . '>"me=s-1'
          \ 'contains=@' . a:language . ',vueSurroundingTag'
          \ 'fold'
  endif
endfunction

let s:language_config = [
      \ {'lang': 'less',       'args': ['less', 'style']},
      \ {'lang': 'pug',        'args': ['pug', 'template', s:attr('lang', '\%(pug\|jade\)')]},
      \ {'lang': 'slm',        'args': ['slm', 'template']},
      \ {'lang': 'handlebars', 'args': ['handlebars', 'template']},
      \ {'lang': 'haml',       'args': ['haml', 'template']},
      \ {'lang': 'typescript', 'args': ['typescript', 'script', '\%(lang=\("\|''\)[^\1]*\(ts\|typescript\)[^\1]*\1\|ts\)']},
      \ {'lang': 'coffee',     'args': ['coffee', 'script']},
      \ {'lang': 'stylus',     'args': ['stylus', 'style']},
      \ {'lang': 'sass',       'args': ['sass', 'style']},
      \ {'lang': 'scss',       'args': ['scss', 'style']},
      \ ]
let s:language_dict = {}
for item in s:language_config
  let s:language_dict[item.lang] = item.args
endfor

if exists("g:vue_pre_processors")
  let pre_processors = g:vue_pre_processors
else
  let pre_processors = map(copy(s:language_config), {k, v -> v.lang})
endif

for language in pre_processors
  if has_key(s:language_dict, language)
    call call("s:register_language", get(s:language_dict, language))
  endif
endfor

syn region  vueSurroundingTag   contained start=+<\(script\|style\|template\)+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syn keyword htmlSpecialTagName  contained template
syn keyword htmlArg             contained scoped ts
syn match   htmlArg "[@v:][-:.0-9_a-z]*\>" contained

let b:current_syntax = "vue"
