let mapleader=","
let maplocalleader="-"

execute pathogen#infect()

filetype plugin indent on
nmap <silent> <localleader>- :view ~/.vim/bundle/vim-orgmode/doc/orgguide.txt<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

let g:ctrlp_working_path_mode = 'r'

nmap <C->p :CtrlP<cr>
nmap <leader>pm :CtrlPMixed<cr>
nmap <leader>pf :CtrlPMRU<cr>
nmap <leader>pb :CtrlPBuffer<cr>
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#fnamemod = ':t'


nmap <leader><PageUp> :bprev<CR>
nmap <leader><PageDown> :bnext<CR>
nmap <C-PageUp> :bprev<CR>
nmap <C-PageDown> :bnext<CR>


set grepprg=ack\ --cpp\ --cc\ --perl\ --python\ --make\ --ld
nmap <silent> <leader>g :grep <C-R>=expand("<cword>")<CR><CR><CR>
map <F7> :botright cwindow<CR>
map <F5> :cprev<CR>
map <F6> :cnext<CR>

nmap <F8> :TagbarToggle<CR>
set nocscopeverbose
if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
 elseif $CSCOPE_DB != ""
     cs add $CSCOPE_DB
endif
nmap <silent> <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
set cscopetag

command! Retag call <SID>recreate_tags()
fun! <SID>recreate_tags()
	!src.ctags_forlang.sh 'c'
	cs reset
endfun
nmap <silent> <leader>t :Retag<CR><CR>

function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()
au BufEnter *.md setlocal foldmethod=expr
au BufEnter *.page setlocal foldexpr=MarkdownLevel()
au BufEnter *.page setlocal foldmethod=expr

set nocompatible
syntax match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell
set syntax=tpp
syntax on

autocmd FileType *	set formatoptions=tcql
	  \ nocindent comments&
autocmd FileType c,cpp set formatoptions=croql
	  \ cindent comments=sr:/*,mb:*,ex:*/,://
autocmd FileType txt set formatoptions=croql
	  \ cindent comments=sr:/*,mb:*,ex:*/,://
autocmd BufNewFile,BufRead *.md set spell
autocmd BufRead,BufNewFile *.page setlocal spell
autocmd BufRead,BufNewFile   *.py,*.spc syntax on setlocal expandtab smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class


set complete+=kspell


augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END

set hlsearch
set incsearch
ab #d #define
ab #i #include
set textwidth=76
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set smarttab
set ruler
set showmatch
set hidden
set nobackup
set noswapfile
set pastetoggle=<F2>
set foldmethod=syntax
highlight Folded guibg=yellow guifg=blue
highlight FoldColumn guibg=darkgrey guifg=white
set switchbuf=usetab

let savemode='all'

fun! <SID>savemode()
	if savemodel == 'all'
		return 1
	endif
	return 0
endfun

let g:autoTags="no"
command! MyAutoTagsToggle call <SID>myAutoTagsToggle()
fun! <SID>myAutoTagsToggle()
	if g:autoTags ==# "no"
		let g:autoTags="yes"
		"Remap shortcut to fit with correct number of CR
		nmap <silent> <leader>m :Mymake<CR><CR><CR>
		nmap <silent> <leader>M :Mymake_install<CR><CR><CR>
		echom ">>>> Auto tags on <<<< "
	else
		set nolist
		let g:autoTags="no"
		"Remap shortcut to fit with correct number of CR
		nmap <silent> <leader>m :Mymake<CR><CR><CR>
		nmap <silent> <leader>M :Mymake_install<CR><CR><CR>
		echom ">>>> Auto tags off <<<< "
	endif
endfunction
nmap <silent> <leader>T :MyAutoTagsToggle<CR>

command! Mymake call <SID>mymake()
fun! <SID>mymake()
	wall
	echo "Saved all buffers prior build"
	if g:autoTags ==# "yes"
		:Retag
	endif

	!_bw_make -j4 mon
	copen
endfunction

command! MymakeInstall call <SID>mymakeInstall()
fun! <SID>mymakeInstall()
	wall
	echo "Saved all buffers prior build"
	if g:autoTags ==# "yes"
		:Retag
	endif

	make install
	copen
endfunction

fun! <SID>bad_mymake()
	if saveall()
		echo "Saving all buffers prior build"
		wall
	else
		echo "Writing local buffer prior build"
		write
	endif

	make
	copen
endfunction

fun! s:wmymake()
	make
endfunction

command! MyToggleSyntax call <SID>mytogglesyntax()
fun! <SID>mytogglesyntax()
	"if g:syntax_on != 1 <- Can't use as variable stops existing
	if !exists( "g:syntax_on" )
		syntax enable
		echom ">>>> Show syntax <<<< "
	else
		syntax off
		echom ">>>> Hide syntax <<<< "
	endif
endfunction
nmap <silent> <localleader>y :MyToggleSyntax<CR>

let g:showSpell="no"
command! DoSpell call <SID>dospell()
fun! <SID>dospell()
	set spell
	let g:showSpell="yes"
		echom ">>>> Do Spell <<<< "
endfunction
command! DontSpell call <SID>dontspell()
fun! <SID>dontspell()
	set nospell
	let g:showSpell="no"
		echom ">>>> Don't Spell <<<< "
endfunction

command! MyToggleSpell call <SID>mytogglespell()
fun! <SID>mytogglespell()
	if g:showSpell ==# "no"
		DoSpell
	else
		DontSpell
	endif
endfunction
nmap <silent> <localleader>s :MyToggleSpell<CR>

let g:showWhites="no"
command! MyToggleWhite call <SID>mytogglewhite()
fun! <SID>mytogglewhite()
	" part of ~/.vimrc
	if g:showWhites ==# "no"
		set listchars=tab:>-,trail:-
		set list
		let g:showWhites="yes"
		echom ">>>> List on <<<< "
	else
		set nolist
		let g:showWhites='no'
		echom ">>>> List off <<<< "
	endif
endfunction
nmap <silent> <leader><TAB> :MyToggleWhite<CR>
let g:useTab="yes"
command! MyToggleTab call <SID>mytoggletab()
fun! <SID>mytoggletab()
	" part of ~/.vimrc
	:if g:useTab ==# "yes"
		set expandtab
		let g:useTab="no"
		echom ">>>> Space will be used in place of all tabs. "
		echom "Use ':retab' change tabs already in use <<<<"
	else
		set noexpandtab
		let g:useTab='yes'
		echom ">>>> <TAB> will be used in place for all tabs. "
		echom "Use ':Respace' change space already in use <<<<"
	endif
endfunction
nmap <silent> <leader><S-TAB> :MyToggleTab<CR>

command! Respace call <SID>myrespace()
fun! <SID>myrespace()
	" part of ~/.vimrc
	if g:useTab ==# "yes"
		echom "Changing all multiple of spaces to tabs"
		:% s/	/\t/g
	endif
endfunction

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

nmap <silent> <leader>m :Mymake<CR><CR><CR>
nmap <silent> <leader>M :MymakeInstall<CR><CR><CR>
nmap <silent> <leader>i :bprev<CR>
nmap <silent> <leader>o :bnext<CR>
nmap <silent> <leader>, :bnext<CR>

nmap <A-Right> zO<CR>
nmap <A-Left> zC<CR>
nmap <Leader><Right> zo<CR>
nmap <Leader><Left> zc<CR>
nmap <S-A-Right> :wincmd l<CR>
nmap <S-A-Left> :wincmd h<CR>
nmap <S-A-Up> :wincmd k<CR>
nmap <S-A-Down> :wincmd j<CR>
if bufwinnr(1)
    nmap <S-PageUp>   <C-W>+
    nmap <S-PageDown> <C-W>-
    nmap <S-->        <C-W><
    nmap <S-+>        <C-W>>
endif

nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>

nnoremap <leader>0 :buffers<CR>:buffer<Space>

set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

if filereadable(".vim.custom")
	so .vim.custom
endif

set showmatch
set showmatch
set scrolloff=3

set t_Co=256
syntax enable

map <C-F11> :e $HOME/.vimrc<enter>

map <F12> /[[:space:]]\+$<enter>
nnoremap <leader>' /[[:space:]]\+$<enter>

map <S-F12> :% s /[[:space:]]\+$//<enter>
nnoremap <leader>+ :% s /[[:space:]]\+$//<enter>


map <C-F12> :%!indent <enter>
map <leader><F12> :%!indent <enter>

map <leader><F11> :.,$ !gcc -fpreprocessed -dD -E -xc -<enter>
map <leader><F10> :%!grep -vEe '^# [1-9]'<enter>
map <leader><F9> :.,$ awk '/^$/{if (blanks<1) print; blanks++}/[[:print:]]/{print; blanks=0}'<enter>

map <leader><C-F12> :%!gcc -fpreprocessed -dD -E -xc -<enter>

set dictionary=/usr/share/dict/words
highlight SpellErrors ctermfg=Red guifg=Red
		   \ cterm=underline gui=underline term=reverse

let spell_executable = "aspell"
let spell_language_list = "english"

set number
set spell
set ttyfast

runtime! ftplugin/man.vim

set t_Co=256
colorscheme industry
set nospell

let term_val = matchstr( $TERM, "screen" )
if term_val == "screen"
	" Note that this setting is to late for colorization handling
	" It's useful for keycodes management below, and for other scripts using
	" $TERM post start-up.
	let $TERM = "screen"
endif	

if $TERM == "screen"
	"echom "Running under screen. Deploying hotfix (see your ~/.vimrc)"
	source  $HOME/.vim/screen_keymaps.vim
endif

