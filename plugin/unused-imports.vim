" ============================================================================
" File:         unsued-imports.vim
" Description:  vim script to highlight java unused imports
" Maintainer:   Ammar Khaku <ammar.khaku at gmail dot com>
" Last Change:  9 Dev, 2012
" License:      This program is free software. It comes without any warranty,
"               to the extent permitted by applicable law.
" Installation: Install this file as plugin/unused-imports.vim
" Usage:        :UnusedImports will highlight the unused imports
"               :UnusedImportsReset will clear the hightlights
"               :UnusedImportsRemove will remove all unused imports
"
" ============================================================================

if exists('g:loaded_unused_imports')
  finish
endif
let g:loaded_unused_imports = '0.1'

if v:version < 700
    echoerr "unused-imports: this plugin requires vim >= 7."
    finish
endif

let s:matches_so_far = []

function! s:highlight_unused_imports(remove)
  let linenr = 0 
  :highlight unusedimport ctermbg=darkred guibg=darkred
  while linenr < line("$") 
    let linenr += 1
    let line = getline(linenr) 
    let lis = matchlist(line, 'import \(\w\+\.\)\+\(\w\+\);')
    if len(lis) > 0
      let s = lis[2]
      let searchStr = '\(\/\/.*\)\@<!\.\@<!\<' . s . '\>'
      let linefound = search(searchStr, 'nw')
      if linefound == 0
        if a:remove
          :exec linenr . 'd _'
        else
          call add(s:matches_so_far, matchadd('unusedimport', line))
        endif
      endif
    endif
  endwhile 
endfunction

function! s:reset_unused_highlights()
  for id in s:matches_so_far
    call matchdelete(id)
  endfor
endfunction

command! UnusedImports call s:highlight_unused_imports(0)
command! UnusedImportsRemove call s:highlight_unused_imports(1)
command! UnusedImportsReset call s:reset_unused_highlights()
