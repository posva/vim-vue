" Vim syntax file
" Language: Vue.js
" Maintainer: Eduardo San Martin Morote

if exists("b:current_syntax")
  finish
endif

syntax include @HTML syntax/html.vim
unlet b:current_syntax
syntax region template keepend start=/<template>/ end="</template>" contains=@HTML fold

syntax include @JADE syntax/jade.vim
unlet b:current_syntax
syntax region jade keepend start=/<template lang="[^"]*jade[^"]*">/ end="</template>" contains=@JADE fold

syntax include @JS syntax/javascript.vim
unlet b:current_syntax
syntax region script keepend start=/<script>/ end="</script>" contains=@JS fold

syntax include @COFFEE syntax/coffee.vim
unlet b:current_syntax
" Matchgroup seems to be necessary for coffee
syntax region coffee keepend matchgroup=Delimiter start="<script lang=\"coffee\">" end="</script>" contains=@COFFEE fold

syntax include @CSS syntax/css.vim
unlet b:current_syntax
syntax region style keepend start=/<style\( \+scoped\)\?>/ end="</style>" contains=@CSS fold

syntax include @stylus syntax/stylus.vim
unlet b:current_syntax
syntax region stylus keepend start=/<style lang="[^"]*stylus[^"]*"\( \+scoped\)\?>/ end="</style>" contains=@stylus fold

let b:current_syntax = "vue"
