if exists('g:autoloaded_graft') || &cp
  finish
endif
let g:autoloaded_graft = 1

let handlers = {}

function! graft#add(match, str)
  handlers[ match ] = str
endfunction
