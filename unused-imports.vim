" ============================================================================
" File:         unsued-imports.vim
" Description:  vim script to highlight java unused imports
" Maintainer:   Ammar Khaku <ammar.khaku at gmail dot com>
" Last Change:  11 Nov, 2012
" License:      This program is free software. It comes without any warranty,
"               to the extent permitted by applicable law."
" Installation: Install this file as autoload/unused-imports.vim
" Usage:        :UnusedImports will highlight the unused imports
"               :UnusedImportsReset will clear the hightlights
"
" ============================================================================

if v:version < 700
    echoerr "unused-imports: this plugin requires vim >= 7."
    finish
endif

let s:matches_so_far = []

function! s:highlight_unused_imports()
  let linenr = 0 
  :highlight unusedimport ctermbg=darkred guibg=darkred
  echom filetype
  while linenr < line("$") 
    let linenr += 1
    let line = getline(linenr) 
    let lis = matchlist(line, 'import \(\w\+\.\)\+\(\w\+\);')
    if len(lis) > 0
      let s = lis[2]
      let searchStr = '\.\@<!\<' . s . '\>'
      let linefound = search(searchStr, 'nw')
      if linefound == 0
        call add(s:matches_so_far, matchadd('unusedimport', line))
      endif
    endif
  endwhile 
endfunction

function! s:reset_unused_highlights()
  for id in s:matches_so_far
    call matchdelete(id)
  endfor
endfunction

command! UnusedImports call s:highlight_unused_imports()
command! UnusedImportsReset call s:reset_unused_highlights()
