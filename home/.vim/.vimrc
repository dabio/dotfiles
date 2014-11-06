" Forget being compatible with good ol' vi
set nocompatible

filetype off                   " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Plugin 'tpope/vim-sensible'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'fatih/vim-go'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'airblade/vim-gitgutter'
Plugin 'Keithbsmiley/swift.vim'
Plugin 'wting/rust.vim'

call vundle#end()

" Turn on that syntax highlighting
" syntax on

" Why is this not a default
" set hidden

" Don't update the display while executing macros
" set lazyredraw

" At least let yourself know what mode you're in
" set showmode

" Set new mapleader default key.
" let mapleader=","

" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
" nmap <silent> <leader>ev :e $MYVIMRC<cr>

"set modelines=0
"
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
"set pastetoggle=<F2>

set visualbell
set cursorline
set ttyfast

""set undofile

"nnoremap / /\v
"vnoremap / /\v
set ignorecase
set smartcase
"" set gdefault
"set showmatch
"set hlsearch
"nnoremap <leader><space> :noh<cr>
"nnoremap <tab> %
"vnoremap <tab> %

"set wrap
"" set textwidth=79
"set formatoptions=qrn1

"set list

set relativenumber
set colorcolumn=80

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
"noremap j gj
"noremap k gk

"inoremap <F1> <ESC>
"nnoremap <F1> <ESC>
"vnoremap <F1> <ESC>

"noremap ; :

au FocusLost * :wa

" Re-source .vimrc on save so changes are effective immediately:
if has('autocmd')
    autocmd! BufWritePost .vimrc source %
endif

"nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
"nnoremap <leader>a :Ack
"nnoremap <leader>ft Vatzf
"nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
"nnoremap <leader>q gqip
"nnoremap <leader>c V`]

"nnoremap <leader>w <C-w>v<C-w>l
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

colorscheme Tomorrow-Night

autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType scss setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType eruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Syntax highlighing for .md files.
au BufRead,BufNewFile *.md set filetype=markdown
