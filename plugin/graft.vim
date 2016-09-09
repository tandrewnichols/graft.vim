if exists('g:loaded_graft') || &cp | finish | endif

let g:loaded_graft = 1
let g:graft_plugins = {}

let g:graft_edit_mapping = get(g:, "graft_edit_mapping", "gfe")
let g:graft_vsplit_mapping = get(g:, "graft_vsplit_mapping", "gfv")
let g:graft_split_mapping = get(g:, "graft_split_mapping", "gfs")
let g:graft_tabe_mapping = get(g:, "graft_tabe_mapping", "gft")

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
          endif
          break
        endif
      elseif plugin == plugins[-1]
        call s:CallThrough()
      endif
    endfor
  else
    call s:CallThrough()
  endif
endfunction

function! g:RegisterGraftLoader(name, filetype)
  if !has_key(g:graft_plugins, a:filetype)
    let g:graft_plugins[ a:filetype ] = []

    " Setup a filetype autocommand for this filetype to add
    " buffer specific key mappings
    execute "augroup GraftMappings_" a:filetype
      au!
      execute "au FileType " a:filetype " call graft#defineMappings()"
    augroup END
  endif

  call add(g:graft_plugins[ a:filetype ], a:name)
endfunction

function! s:CallThrough()
  if g:graft_call_through
    normal! gf
  endif
endfunction

nnoremap <silent> <Plug>GraftEdit :call g:RunGraft()<CR>
nnoremap <silent> <Plug>GraftVsplit :call g:RunGraft("vsplit")<CR>
nnoremap <silent> <Plug>GraftSplit :call g:RunGraft("split")<CR>
nnoremap <silent> <Plug>GraftTabe :call g:RunGraft("tabedit")<CR>
