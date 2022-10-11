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

" define the cluster that will be applied inside the template tag where
" javascript is ran by vue, this is defined so it can be redefined with other
" scripting languages such as typescript if the .vue file uses a lang="ts"
syntax cluster TemplateScript contains=@jsAll

" template_script_in_* region {{{
"""""
" if you want to add script highlighting support for a specific template
" language, you should do it in this region (marked by the {{{fold marks}}})
" named "s:template_script_in_<language>", the "<language>" must match the name
" declared on the "s:languages" array (later in the file) and add a key in the
" language object referring to the language you want to include highlighting for

function! s:template_script_in_html()
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
  syn region vueTemplateScript start=/\(\s\([@#:]\|v-\)\([-:.0-9_a-z]*\|\[.*\]\)=\)\@<="/ms=e+1 keepend end=/"/me=s-1 contains=@TemplateScript containedin=ALLBUT,htmlComment
  syn region vueTemplateScript start=/\(\s\([@#:]\|v-\)\([-:.0-9_a-z]*\|\[.*\]\)=\)\@<='/ms=e+1 keepend end=/'/me=s-1 contains=@TemplateScript containedin=ALLBUT,htmlComment
  " This one is for #[thisHere] @[thisHereToo] :[thisHereAlso]
  syn region vueTemplateScript matchgroup=htmlArg start=/[@#:]\[/ keepend end=/\]/ contains=@TemplateScript containedin=ALLBUT,htmlComment
endfunction
" }}}

" Eager load template script highlighting for html because it's already being
" loaded as the base for the .vue syntax highlighting.
call s:template_script_in_html()

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
  let s:attr_pattern = has_key(s:language, 'attr_pattern') ? s:language.attr_pattern : s:attr('lang', s:language.name)
  let s:start_pattern = '<' . s:language.tag . '\>\_[^>]*' . s:attr_pattern . '\_[^>]*>'

  if s:should_register(s:language.name, s:start_pattern)
    execute 'syntax include @' . s:language.name . ' syntax/' . s:language.name . '.vim'
    unlet! b:current_syntax
    execute 'syntax region vue_' . s:language.name
          \ 'keepend'
          \ 'start=/' . s:start_pattern . '/'
          \ 'end="</' . s:language.tag . '>"me=s-1'
          \ 'contains=@' . s:language.name . ',vueSurroundingTag'
          \ 'fold'

    if (s:language.tag == 'script')
      syntax clear @TemplateScript
      execute 'syntax cluster TemplateScript contains=@'.s:language.name
    endif

    if has_key(s:language, 'template_script_syntax')
      execute 'call s:template_script_in_' . s:language.name . '()'
    endif
  endif
endfor

syn region  vueSurroundingTag   contained start=+<\(script\|style\|template\)+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent
syn keyword htmlSpecialTagName  contained template
syn keyword htmlArg             contained scoped ts
syn match   htmlArg "[@#v:a-z][-:.0-9_a-z]*\>" contained

" for mustaches quotes (`{{` and `}}`)
syn region vueTemplateScript matchgroup=htmlSpecialChar start=/{{/ keepend end=/}}/ contains=@TemplateScript containedin=ALLBUT,htmlComment

syntax sync fromstart

let b:current_syntax = "vue"

" vim: et tw=80 sts=2 fdm=marker
