" syn keyword TodoKeyword contained TODO

syn match HeaderLine "^#.*" contains=TodoKeyword
syn match HeaderLine "\s#.*"ms=s+1 contains=TodoKeyword
hi HeaderLine ctermfg=green

syn match SubLine "^>>.*"
syn match SubLine "\s>>.*"ms=s+1
hi SubLine ctermfg=cyan

" hi TodoKeyword ctermfg=black ctermbg=yellow
