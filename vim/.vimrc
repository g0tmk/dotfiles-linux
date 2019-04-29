" my .vimrc. Heavily influenced by vim-sensible.
" Use :help 'option' to see the documentation for the given option.
"
" TODO: lookup matchit.vim to make % key more useful


if !exists("g:syntax_on")
    syntax enable
endif


" turn on line numbers + relative numbers, but disable relative numbers when in insert mode or when the buffer leaves focus (ie when switching to another vimsplit)
set number
set relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

if has('autocmd')
  filetype plugin indent on
endif

set autoindent
" allow backspace in insert mode
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

" lower timeout for escape keys so leaving insert mode via ESC is much quicker
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" enable incremental search so search results are displayed as query is typed
set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" always show status bar
set laststatus=2
set ruler

" enable command line completion (try :color <tab>)
set wildmenu
set wildmode=longest:full,full

" show at least 1 line above/below cursor and 5 colums to the side
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif

" if a line is too long to be shown completely, show it anyways instead of
" replacing with @@@ symbols
:set display+=lastline

" use utf-8 encoding always. might need to change this if it causes issues
set encoding=utf-8

" use custom characters for list mode `:set list`
if &listchars ==# 'eol:$'
  set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+
  "set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 
endif

set vb t_vb= " Turn off visual bell, error flash

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" use ctags file if it exists
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" increase history depth / max number of tabs
if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif

" use viminfo file
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" vim:set ft=vim et sw=2:



