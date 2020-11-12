set number
set ruler

" searching
set ignorecase
set showmatch

set autoindent
set tabstop=4
set shiftwidth=4

set showmode
set noflash

" save file with leader w
map ,w :w

" format current file and reload
map go :!gofmt -s -w %:e

" source .exrc when edited
map ,s :so $HOME/.exrc

" edit .exrc file
map ,e :e $HOME/.exrc
