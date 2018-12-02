call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter', { }
Plug 'altercation/vim-colors-solarized', {  }
Plug 'pearofducks/ansible-vim', { 'for': ['ansible'] }
Plug 'ctrlpvim/ctrlp.vim', {  }
Plug 'ekalinin/Dockerfile.vim', { }
Plug 'lervag/vimtex', { 'for': ['tex'] }
Plug 'luochen1990/rainbow', {  }
Plug 'mattn/emmet-vim', { 'for': ['html'] }
Plug 'mbbill/undotree', {  }
Plug 'nathanaelkane/vim-indent-guides', {  }
Plug 'nvie/vim-flake8', { 'for': ['python'] }
Plug 'python-mode/python-mode', { 'for': ['python'] }
Plug 'scrooloose/nerdcommenter', {  }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeToggle'] }
Plug 'sheerun/vim-polyglot', { }
Plug 'spf13/vim-autoclose', {  }
Plug 'tjdevries/overlength.vim', { }
Plug 'tpope/vim-fugitive', {  }
Plug 'tpope/vim-sensible', {  }
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround', {  }
Plug 'Valloric/YouCompleteMe', { 'do': ['./install.py'] }
Plug 'vim-airline/vim-airline', {  }
Plug 'vim-airline/vim-airline-themes', {  }
Plug 'vim-syntastic/syntastic', {  }
Plug 'w0rp/ale', { }

call plug#end()

" General
set nocompatible
syntax enable

" Airline plugin
set background=dark
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:solarized_termcolors=256
let g:solarized_termtrans = 1
let g:solarized_contrast = 'normal'
let g:solarized_visibility = 'normal'
color solarized

set showmode                    " Display the current mode

set cursorline                  " Highlight current line

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode


filetype plugin indent on
let mapleader = ','

set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
scriptencoding utf-8

set virtualedit=onemore             " Allow for cursor beyond last character

set modeline


set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespaceV

" Formating
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set breakindent
set gdefault
set autoread
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv

" Backup/Undo
let dir_list = {
    \ 'backup': 'backupdir',
    \ 'views': 'viewdir',
    \ 'swap': 'directory',
    \ 'undo': 'undodir' }

for [dirname, settingname] in items(dir_list)
    let directory = $HOME . '/.vim/' . dirname .'/'
    if !isdirectory(directory)
        call mkdir(directory)
    endif
    let directory = substitute(directory, " ", "\\\\ ", "g")
    exec "set " . settingname . "=" . directory
endfor

set hidden
set undolevels=1000
set undoreload=10000

autocmd Filetype html,javascript setlocal ts=2 sts=2 sw=2
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css


" CtrlP
if executable('ag')
  let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
else
  let s:ctrlp_fallback = 'find %s -type f'
endif

" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>

" Ident guide
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" NerdTree
map <C-e> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" Python
au BufRead,BufNewFile *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

let python_highlight_all=1

if !has('python') && !has('python3')
    let g:pymode = 0
endif

let g:pymode_lint_checkers = ['pyflakes']
let g:pymode_trim_whitespaces = 0
let g:pymode_options = 0
let g:pymode_rope = 0

" UndoTree
nnoremap <F5> :UndotreeToggle<cr>

" Overlength
let overlength#default_overlength = 0 " Trick, == disable everywhere
call overlength#set_overlength('python', 80)

" vim-polyglot
let g:polyglot_disabled = ['latex']
