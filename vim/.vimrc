"
"TODO: Separate colors from commands
"TODO: Separate vundle installations
"

set noautochdir
set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'itchyny/lightline.vim'
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'duythinht/vim-coffee'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-eunuch'
Plugin 'w0rp/ale'
Plugin 'mattn/emmet-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'junegunn/fzf.vim'
Plugin 'ajmwagar/vim-deus'
call vundle#end()
filetype plugin indent on

set nu
syntax on
set t_Co=256

"colorscheme happy_hacking
"colorscheme space_vim_theme
"colorscheme deus

" This is important as nvim will not turn check spell
set nospell 
nnoremap <leader>s :set invspell spelllang=sk<CR>
nnoremap <leader>e :set invspell spelllang=en_us<CR>
nnoremap <leader>m :!(make \|\| build)<CR>

set ruler
set hlsearch
set autoindent
set relativenumber
set wildmode=longest,list
set number
set mouse=v

set rtp+=~/.fzf
set laststatus=2

nmap <C-w>1 :tabn 1<CR>
nmap <C-w>2 :tabn 2<CR>
nmap <C-w>3 :tabn 3<CR>
nmap <C-w>4 :tabn 4<CR>
nmap <C-w>5 :tabn 5<CR>
nmap <C-w>6 :tabn 6<CR>
nmap <C-w>7 :tabn 7<CR>
nmap <C-w>8 :tabn 8<CR>
nmap <C-w>9 :tabn 9<CR>

map <C-e> :NERDTreeToggle<CR>
map ; :Files<CR>

nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<CR>
nnoremap tn  :tabnext<space>
nnoremap td  :tabclose<CR>

let g:NERDTreeNodeDelimiter = "\u00a0"
let g:gitgutter_max_signs=9999

if !empty(glob('~/.vimrc_local'))
	so ~/.vimrc_local
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }
