if exists('g:loaded_graft') || &cp | finish | endif
let g:loaded_graft = 1
let g:graft_plugins = {}

let g:graft_open_command = get(g:, "graft_open_command", "edit")
let g:graft_call_through = get(g:, "graft_call_through", 1)
let g:graft_create_missing_dirs = get(g:, "graft_create_missing_dirs", 1)

function! g:RunGraft(...)
  let view = a:0 > 0 ? a:1 : g:graft_open_command
  let filetypes = split(&filetype, '\.')
  let plugins = []
  for ft in filetypes
    if has_key(g:graft_plugins, ft)
      let plugins += g:graft_plugins[ ft ]
    endif
  endfor

  if len(plugins) > 0
    let file = ""
    for plugin in plugins
      execute "let file = graft#" . plugin . "#load()"
      if type(file) != 0 && !empty(file)
        if type(file) == 1
          silent execute view file
          break
        elseif type(file) == 3
          silent execute view file[0]
          if !empty(file[1])
            call file[1]()
            "call search("\\(exports\\.\\|export.*\\)\\zs" . file[1] . "\\ze = ")
            "call matchadd("Search", file[1])
          endif
          break
        endif
      elseif plugin == plugins[-1] && g:graft_call_through
        call s:CallThrough()
      endif
    endfor
  elseif g:graft_call_through
    call s:CallThrough()
  endif
endfunction

function! g:RegisterGraftLoader(name, filetype)
  if !exists("g:graft_plugins." . a:filetype)
    let g:graft_plugins[ a:filetype ] = []
  endif
  call add(g:graft_plugins[ a:filetype ], a:name)
endfunction

function! s:CallThrough()
  normal! gf
endfunction

nnoremap <silent> <Plug>GraftEdit :call g:RunGraft()<CR>
nnoremap <silent> <Plug>GraftVsplit :call g:RunGraft("vsplit")<CR>
nnoremap <silent> <Plug>GraftSplit :call g:RunGraft("split")<CR>
nnoremap <silent> <Plug>GraftTabe :call g:RunGraft("tabedit")<CR>

if !hasmapto("<Plug>GraftEdit")
  nmap gf <Plug>GraftEdit
endif

if !hasmapto("<Plug>GraftVsplit")
  nmap K <Plug>GraftVsplit
endif

if !hasmapto("<Plug>GraftSplit")
  nmap <leader>gf <Plug>GraftSplit
endif

if !hasmapto("<Plug>GraftTabe")
  nmap <leader>K <Plug>GraftTabe
endif
