" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle
Bundle 'gmarik/Vundle.vim'

" General utilities
Bundle 'tpope/vim-fugitive'
Bundle 'ervandew/supertab'
Bundle 'Lokaltog/vim-powerline'
Bundle 'airblade/vim-gitgutter'
Bundle 'vimwiki/vimwiki'
Bundle 'ctrlpvim/ctrlp.vim'

" Other things
Bundle 'othree/html5.vim'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'nvie/vim-flake8'
Bundle 'vim-javascript'
Bundle 'digitaltoad/vim-jade'
Bundle 'kchmck/vim-coffee-script'
Bundle 'derekwyatt/vim-scala'
Bundle 'rust-lang/rust.vim'
Bundle 'vim-scripts/TLA'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'leafgarland/typescript-vim'
Bundle 'LnL7/vim-nix'

" Clojure stuff
Bundle 'vim-scripts/paredit.vim'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-leiningen'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-fireplace'
Bundle 'dgrnbrg/vim-redl'
Bundle 'typedclojure/vim-typedclojure'


" Theme stuff
Bundle 'altercation/vim-colors-solarized'
" Bundle 'w0ng/vim-hybrid'
call vundle#end()
