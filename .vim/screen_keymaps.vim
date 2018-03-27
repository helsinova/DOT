" Source this file if running under screen virtual terminal

" Hint: To create new key maps in vim, use <C-v>YOURKEY in **insert-mode**
" to have vim pick-up the key-code and insert it at cursor-position.


"
" ============
" Overall mode
" ============
"Meta key - Ctrl
map [6;5~ <C-PageDown>
map [5;5~ <C-PageUp>
map [1;5C <C-Right>
map [1;5D <C-Left>
map [1;5A <C-Up>
map [1;5B <C-Down>

"Meta key - Shift
map [1;2C <S-Right>
map [1;2D <S-Left>
map [1;2A <S-Up>
map [1;2B <S-Down>
map [5;2~ <S-PageUp>
map [6;2~ <S-PageDown>
map O2k <S-+>
map O2m <S-->

"Meta key - Shift+Ctrl
map [1;6C <S-C-Right>
map [1;6D <S-C-Left>
map [1;6A <S-C-Up>
map [1;6B <S-C-Down>
map [5;6~ <S-C-PageUp>
map [6;6~ <S-C-PageDown>

"Meta key - Shift+Alt
map [1;4C <S-A-Right>
map [1;4D <S-A-Left>
map [1;4A <S-A-Up>
map [1;4B <S-A-Down>
map [6;4~ <S-A-PageUp>
map [5;4~ <S-A-PageDown>
map O4k <S-A-+>
map O4m <S-A-->

" ============
" Insert-mode
" ============
"Meta key - Ctrl
imap [6;5~ <C-PageDown>
imap [5;5~ <C-PageUp>
imap [1;5C <C-Right>
imap [1;5D <C-Left>
imap [1;5A <C-Up>
imap [1;5B <C-Down>

"Meta key - Shift
imap [1;2C <S-Right>
imap [1;2D <S-Left>
imap [1;2A <S-Up>
imap [1;2B <S-Down>
imap [5;2~ <S-PageUp>
imap [6;2~ <S-PageDown>
imap O2k <S-+>
imap O2m <S-->

"Meta key - Shift+Ctrl
imap [1;6C <S-C-Right>
imap [1;6D <S-C-Left>
imap [1;6A <S-C-Up>
imap [1;6B <S-C-Down>
imap [5;6~ <S-C-PageUp>
imap [6;6~ <S-C-PageDown>

"Meta key - Shift+Alt
imap [1;4C <S-A-Right>
imap [1;4D <S-A-Left>
imap [1;4A <S-A-Up>
imap [1;4B <S-A-Down>
imap [6;4~ <S-A-PageUp>
imap [5;4~ <S-A-PageDown>
imap O4k <S-A-+>
imap O4m <S-A-->

" ===================
" F-keys Overall mode
" ===================
"Meta key - Ctrl
map O5P <C-F1>
map O5Q <C-F2>
map O5R <C-F3>
map O5S <C-F4>
map [15;5~  <C-F5>
map [17;5~ <C-F6>
map [18;5~ <C-F7>
map [19;5~ <C-F8>
map [20;5~ <C-F9>
map [20;5~ <C-F10>
map [23;5~ <C-F11>
map [24;5~ <C-F12>

"Meta key - Alt
map O3P <A-F1>
map O3Q <A-F2>
map O3R <A-F3>
map O3S <A-F4>
map [15;3~ <A-F5>
map [17;3~ <A-F6>
map [18;3~ <A-F7>
map [19;3~ <A-F8>
map [20;3~ <A-F9>
map [21;3~ <A-F10>
map [23;3~ <A-F11>
map [24;3~ <A-F12>

"Meta key - Shift
map O2P <S-F1>
map O2Q <S-F2>
map O2R <S-F3>
map O2S <S-F4>
map [15;2~ <S-F5>
map [17;2~ <S-F6>
map [18;2~ <S-F7>
map [19;2~ <S-F8>
map [20;2~ <S-F9>
map [21;2~ <S-F10>
map [23;2~ <S-F11>
map [24;2~ <S-F12>

"Meta key - Shift+Ctrl
map O6P <S-C-F1>
map O6Q <S-C-F2>
map O6R <S-C-F3>
map O6S <S-C-F4>
map [15;6~ <S-C-F5>
map [17;6~ <S-C-F6>
map [18;6~ <S-C-F7>
map [19;6~ <S-C-F8>
map [20;6~ <S-C-F9>
map [21;6~ <S-C-F10>
map [23;6~ <S-C-F11>
map [24;6~ <S-C-F12>

"Meta key - Shift+Alt
map O4P <S-A-F1>
map O4Q <S-A-F2>
map O4R <S-A-F3>
map O4S <S-A-F4>
map [15;4~ <S-A-F5>
map [17;4~ <S-A-F6>
map [18;4~ <S-A-F7>
map [19;4~ <S-A-F8>
map [20;4~ <S-A-F9>
map [21;4~ <S-A-F10>
map [23;4~ <S-A-F11>
map [24;4~ <S-A-F12>

" ===================
" F-keys Insert-mode
" ===================
"Meta key - Ctrl
imap O5P <C-F1>
imap O5Q <C-F2>
imap O5R <C-F3>
imap O5S <C-F4>
imap [15;5~  <C-F5>
imap [17;5~ <C-F6>
imap [18;5~ <C-F7>
imap [19;5~ <C-F8>
imap [20;5~ <C-F9>
imap [20;5~ <C-F10>
imap [23;5~ <C-F11>
imap [24;5~ <C-F12>

"Meta key - Alt
imap O3P <A-F1>
imap O3Q <A-F2>
imap O3R <A-F3>
imap O3S <A-F4>
imap [15;3~ <A-F5>
imap [17;3~ <A-F6>
imap [18;3~ <A-F7>
imap [19;3~ <A-F8>
imap [20;3~ <A-F9>
imap [21;3~ <A-F10>
imap [23;3~ <A-F11>
imap [24;3~ <A-F12>

"Meta key - Shift
imap O2P <S-F1>
imap O2Q <S-F2>
imap O2R <S-F3>
imap O2S <S-F4>
imap [15;2~ <S-F5>
imap [17;2~ <S-F6>
imap [18;2~ <S-F7>
imap [19;2~ <S-F8>
imap [20;2~ <S-F9>
imap [21;2~ <S-F10>
imap [23;2~ <S-F11>
imap [24;2~ <S-F12>

"Meta key - Shift+Ctrl
imap O6P <S-C-F1>
imap O6Q <S-C-F2>
imap O6R <S-C-F3>
imap O6S <S-C-F4>
imap [15;6~ <S-C-F5>
imap [17;6~ <S-C-F6>
imap [18;6~ <S-C-F7>
imap [19;6~ <S-C-F8>
imap [20;6~ <S-C-F9>
imap [21;6~ <S-C-F10>
imap [23;6~ <S-C-F11>
imap [24;6~ <S-C-F12>

"Meta key - Shift+Alt
imap O4P <S-A-F1>
imap O4Q <S-A-F2>
imap O4R <S-A-F3>
imap O4S <S-A-F4>
imap [15;4~ <S-A-F5>
imap [17;4~ <S-A-F6>
imap [18;4~ <S-A-F7>
imap [19;4~ <S-A-F8>
imap [20;4~ <S-A-F9>
imap [21;4~ <S-A-F10>
imap [23;4~ <S-A-F11>
imap [24;4~ <S-A-F12>

