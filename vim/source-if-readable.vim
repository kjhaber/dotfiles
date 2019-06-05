" Conditionally source a file if it exists and is readable
function! SourceIfReadable(filename)
  if filereadable(a:filename)
    exec 'source ' . a:filename
  endif
endfunction

function! SourceDotfile(filename)
  call SourceIfReadable($DOTFILE_HOME . '/' . a:filename)
endfunction

function! SourceLocalDotfile(filename)
  call SourceIfReadable($DOTFILE_LOCAL_HOME . '/' . a:filename)
endfunction

