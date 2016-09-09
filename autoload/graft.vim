function graft#defineMappings()
  execute "nmap \<buffer> " . g:graft_edit_mapping . " <Plug>GraftEdit"
  execute "nmap \<buffer> " . g:graft_vsplit_mapping . " <Plug>GraftVsplit"
  execute "nmap \<buffer> " . g:graft_split_mapping . " <Plug>GraftSplit"
  execute "nmap \<buffer> " . g:graft_tabe_mapping . " <Plug>GraftTabe"
endfunction

function graft#lineMatches(test)
  return match(getline('.'), a:test) > -1
endfunction

function graft#cursorIsOnFilename()
  return expand("<cfile>") != expand("<cword>")
endfunction

function graft#hasPathSeparator(path)
  return a:path =~ "/"
endfunction

function graft#resolveRelativeToCurrentFile(file)
  return fnamemodify(expand("%:p:h") . "/" . a:file, ":p")
endfunction

function graft#hasExtension(path)
  return !empty(fnamemodify(a:path, ":e"))
endfunction

function graft#trimTrailingSlash(thing)
  return substitute(a:thing, "/$", "", "")
endfunction

function graft#isRelativeFilepath(path)
  return a:path =~ "^\\."
endfunction

function graft#addExtension(path, ext)
  return fnamemodify(a:path, ":p") . "." . a:ext
endfunction

function graft#createMissingDirs(path)
  let dir = fnamemodify(a:path, ':h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
endfunction

function graft#pathIsRelativeOnly(path)
  return a:path =~ "^[./]\\+$"
endfunction

function graft#createCallback(func, args)
  return function(a:func, a:args)
endfunction

" Find a file up the directory hierarchy from the cwd
function graft#findup(file)
  return graft#findupFrom(getcwd(), a:file)
endfunction

"" Find a file up the directory hierarchy from a given directory
function graft#findupFrom(dir, file)
  let dir = fnamemodify(a:dir, ":p")
  let trypath = dir . a:file
  if dir == "/"
    return ""
  endif
  return graft#pathExists(trypath) ? trypath : graft#findupFrom(fnamemodify(dir, ":p:h:h"), a:file)
endfunction

function graft#pathExists(path)
  return !empty(glob(a:path))
endfunction
