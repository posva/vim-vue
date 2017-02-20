setlocal suffixesadd+=.vue

" Add compatibility with vim-closetag
if exists('g:closetag_filenames')
  if empty(g:closetag_filenames)
    let g:closetag_filenames = '*.vue'
  else
    let g:closetag_filenames .= ',*.vue'
  endif
endif
