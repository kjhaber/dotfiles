" Conditionally source a file if it exists and is readable
function! SourceIfReadable(filename)
  if filereadable(a:filename)
    exec 'source ' . a:filename
  endif
endfunction

function! SourceNvimDotfile(filename)
  call SourceIfReadable($HOME . '/.config/nvim/' . a:filename)
endfunction

function! SourceLocalNvimDotfile(filename)
  call SourceIfReadable($HOME . '/.config-local/nvim/' . a:filename)
endfunction

