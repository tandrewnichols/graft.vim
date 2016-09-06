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
