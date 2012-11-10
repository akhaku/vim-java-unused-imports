
let linenr = 0 
:highlight unusedimport ctermbg=darkred guibg=darkred

while linenr < line("$") 
  let linenr += 1
  let line = getline(linenr) 
  let lis = matchlist(line, 'import \(\w\+\.\)\+\(\w\+\);')
  if len(lis) > 0
    let s = lis[2]
    let searchStr = '\.\@<!\<' . s . '\>'
    echom searchStr
    let linefound = search(searchStr, 'nw')
    echom linefound
    if linefound == 0
      let _ = matchadd('unusedimport', line)
    endif
  endif
endwhile 
