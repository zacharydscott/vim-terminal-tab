" Vim Terminal Tab
" Author: Zachary Scott
" Version: 0.1

if exists("g:vim_terminal_tab_loader")
  finish
endif

let s:old_cpo = &cpoptions
set cpoptions&vim

let g:vim_terminal_tab_loader = 1
let s:terminals = []
let s:initializing = 0

function! s:Clear_Closed_Terminals()
  let new_terms = []
  for terml in s:terminals
    let nr = bufnr(terml.buf_id)
    if nr > 0
      let terml.cur_nr = nr
      call add(new_terms,terml)
    endif
  endfor
  let s:terminals = new_terms
endfunction

" returns if any terminal was open before
function s:Terminal_Tab_Close()
  call s:Clear_Closed_Terminals()
  let was_open = 0
  for terml in s:terminals
    let win_nrs = win_findbuf(terml.cur_nr)
    if len(win_nrs)
      let was_open = 1
    endif
    for window in win_nrs
      call win_gotoid(window)
      hide
    endfor
  endfor
  return was_open
endfunction

" No need for a third function for toggle, as the behavior is cleanly split
" in the commands
function! s:Terminal_Tab_Open_Toggle(force_open)
  if s:Terminal_Tab_Close() && a:force_open == 0
    return
  endif

  tabnew Terminal Tabs
  " if any buffers are open, set the list to the remaining ones and jump to
  " them. 
  if len(s:terminals)
    let is_first = 1
    for terml in s:terminals
      if is_first
        let is_first = 0
      else
        vsplit
      endif
      execute 'b ' . terml.buf_id
    endfor
  else
    "Otherwise, all tabs are closed on uninitiated. Discard the new list and
    "initiaize or reinitialize.
    if exists('g:terminal_tab_config')
      let s:terminals = deepcopy(g:terminal_tab_config)
    else
      let s:terminals = [{}]
    endif
    let is_first = 1
    let s:initializing = 1
    for terml in s:terminals
      if is_first
        let is_first = 0
      else
        vsplit
      endif
      terminal
      let terml.buf_id = bufname()
      let terml.chan_id = b:terminal_job_id
      if exists('terml.load_command')
        call chansend(terml.chan_id, terml.load_command . "\<CR>")
      endif
    endfor
    let s:initializing = 0
  endif
endfunction

function! s:Add_Tab()
  if s:initializing == 0
    let new_term = {}
    let new_term.buf_id = bufname()
    let new_term.chan_id = b:terminal_job_id
    call add(s:terminals, new_term)
  endif
endfunction

augroup TERMINAL_TAB_INTERNAL
  autocmd!
  autocmd TermOpen * call <SID>Add_Tab()
augroup END

command! TerminalTabToggle call <SID>Terminal_Tab_Open_Toggle(0)
command! TerminalTabOpen call <SID>Terminal_Tab_Open_Toggle(1)
command! TerminalTabClose call <SID>Terminal_Tab_Close()

let &cpoptions = s:old_cpo
unlet s:old_cpo
