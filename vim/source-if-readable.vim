" Conditionally source a file if it exists and is readable
function! SourceIfReadable(filename)
  if filereadable(a:filename)
    exec 'source ' . a:filename
  endif
endfunction

function! SourceDotfile(filename)
  call SourceIfReadable(g:dotfile_home . '/' . a:filename)
endfunction

function! SourceLocalDotfile(filename)
  call SourceIfReadable(g:dotfile_local_home . '/' . a:filename)
endfunction

