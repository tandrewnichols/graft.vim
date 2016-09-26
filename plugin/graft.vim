if exists('g:loaded_graft') || &cp | finish | endif

let g:loaded_graft = 1
let g:graft_plugins = {}

let g:graft_edit_mapping = get(g:, "graft_edit_mapping", "gfe")
let g:graft_vsplit_mapping = get(g:, "graft_vsplit_mapping", "gfv")
let g:graft_split_mapping = get(g:, "graft_split_mapping", "gfs")
let g:graft_tabe_mapping = get(g:, "graft_tabe_mapping", "gft")
let g:graft_default_action = get(g:, "graft_default_action", "edit")

let g:graft_call_through = get(g:, "graft_call_through", 1)
let g:graft_create_missing_dirs = get(g:, "graft_create_missing_dirs", 1)
let g:graft_no_default_gf = get(g:, "graft_no_default_gf", 0)

function! g:RunGraft(...)
  let view = a:0 > 0 ? a:1 : ""
  if empty(view)
    if g:graft_no_default_gf
      call s:CallThrough()
    else
      let view = g:graft_default_action
    endif
  endif

  let filetypes = split(&filetype, '\.')
  let plugins = []
  for ft in filetypes
    if has_key(g:graft_plugins, ft)
      let clone = deepcopy(g:graft_plugins[ft])
      let plugins += map(filter(clone, 'v:val.When() == 1'), 'v:val.name')
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

function! g:RegisterGraftLoader(name, filetype, ...)
  if !has_key(g:graft_plugins, a:filetype)
    let g:graft_plugins[ a:filetype ] = []

    " Setup a filetype autocommand for this filetype to add
    " buffer specific key mappings
    execute "augroup GraftMappings_" a:filetype
      au!
      execute "au FileType " a:filetype " call graft#defineMappings()"
    augroup END
  endif

  function! RetTrue()
    return 1
  endfunction

  let pluginObj = { 'name': a:name, 'When': function('RetTrue') }
  if a:0 > 0
    let pluginObj.When = a:1
  endif

  call add(g:graft_plugins[ a:filetype ], pluginObj)
endfunction

function! s:CallThrough()
  if g:graft_call_through
    normal! gf
  endif
endfunction

nnoremap <silent> <Plug>GraftDefault :call g:RunGraft()<CR>
nnoremap <silent> <Plug>GraftEdit :call g:RunGraft("edit")<CR>
nnoremap <silent> <Plug>GraftVsplit :call g:RunGraft("vsplit")<CR>
nnoremap <silent> <Plug>GraftSplit :call g:RunGraft("split")<CR>
nnoremap <silent> <Plug>GraftTabe :call g:RunGraft("tabedit")<CR>
