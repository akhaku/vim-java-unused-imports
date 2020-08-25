" ============================================================================
" File:         unsued-imports.vim
" Version:      1.1.1
" Description:  vim script to highlight java unused imports
" Maintainer:   Ammar Khaku
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

highlight default link unusedimport Error
let s:matches_so_far = []

function! s:highlight_unused_imports(remove)
  call s:reset_unused_highlights()

  " save current position to set it back later
  let startLine = line(".")
  let startCol = col(".")

  let linenr = 0
  " where does the class definition start (= where the imports end)
  call cursor(1, 1)
  let classStartLine = search('\v(^\s*import\s+)@<!(<fun>|<class>|<object>|<interface>|\@)')
  while linenr < classStartLine
    let linenr += 1
    let line = getline(linenr)
    " assemble non static imports for removal
    let lis = matchlist(line, '\v^\s*import\s+(\w+\.)+([a-zA-Z0-9_]+)\s*;?\s*$')
    if len(lis) == 0
      " assemble static imports for removal
      let lis = matchlist(line, '\v^\s*import static\s+(\w+\.)+([a-zA-Z0-9_]+)\s*;?\s*$')
    endif
    if len(lis) > 0
      let s = lis[2]
      let searchPattern = '\v(//.*)@<!<' . s . '>'

      " start searching from the class definition
      call cursor(classStartLine, 1)
      let linefound = search(searchPattern, 'nW')

      if linefound == 0
        if a:remove
          exec linenr . 'd _'
          let linenr -= 1
          let classStartLine -= 1
        else
          call add(s:matches_so_far, matchadd('unusedimport', '^' . line . '$'))
        endif
      endif
    endif
  endwhile

  " set cursor back to initial position
  call cursor(startLine, startCol)
endfunction

function! s:reset_unused_highlights()
  for id in s:matches_so_far
    call matchdelete(id)
  endfor
  let s:matches_so_far = []
endfunction

command! UnusedImports call s:highlight_unused_imports(0)
command! UnusedImportsRemove call s:highlight_unused_imports(1)
command! UnusedImportsReset call s:reset_unused_highlights()
