" Traitement des fichiers Allout.
" Copyright (C) Progiciels Bourbeau-Pinard, inc.
" Fran�ois Pinard, 2003-12.

if exists('loaded_allout')
  finish
endif
let loaded_allout = 1

setlocal foldmethod=expr
setlocal foldexpr=AlloutFoldExpr(v:lnum)
setlocal foldtext=AlloutFoldText()
setlocal shiftwidth=1

function AlloutFoldExpr(line)
  let text = getline(a:line)
  if text =~ '^[*.]'
    if text[0] == '*'
      return 1
    endif
    let text2 = substitute(text, '^\.\( *\)[-*+@#.:,;].*', '\1', '')
    if text != text2
      return  strlen(text2) + 2
    endif
  endif
  return &foldnestmax
endfunction

function AlloutFoldText()
  return v:folddashes . ' ' . (v:foldend-v:foldstart) . ' lines '
endfunction

if !has('python')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

python <<EOF
try:
    import allout
except ImportError:
    import Allout.vim as allout

allout.register_key_bindings(vim.eval('maplocalleader'), 0x02)
EOF

let &cpo = s:save_cpo
