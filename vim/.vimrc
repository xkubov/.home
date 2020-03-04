set noautochdir
set nocompatible

set encoding=utf-8

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'duythinht/vim-coffee'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-eunuch'
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'w0rp/ale'
Plugin 'mattn/emmet-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/fzf.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'honza/vim-snippets'
Plugin 'MaskRay/ccls'
" Themes
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'ajmwagar/vim-deus'
Plugin 'morhetz/gruvbox'
Plugin 'dag/vim-fish'
call vundle#end()
filetype plugin indent on

set nu
syntax on
filetype plugin indent on
set t_Co=256

" This is important as nvim will not turn check spell
set nospell
nnoremap <leader>s :set invspell spelllang=sk<CR>
nnoremap <leader>e :set invspell spelllang=en_us<CR>
nnoremap <leader>m :!(make \|\| build)<CR>

set ruler
set hlsearch
set autoindent
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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:deoplete#enable_at_startup = 1

let g:airline_theme='bubblegum'

let g:ale_warn_about_trailing_whitespace = 1
let g:ale_completion_enabled = 1
let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '/tmp/ccls/cache'
\   }
\ }

nnoremap <leader>d :ALEGoToDefinition<cr>
nnoremap <leader>r :ALEFindReferences<cr>
nnoremap <leader>a :ALESymbolSearch<cr>
nnoremap <leader>h :ALEHover<cr>

if !empty(glob('~/.vimrc_local'))
	so ~/.vimrc_local
endif

" Shortcuts for vim templates
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let t:is_transparent = 0

let g:ycm_rust_src_path = '/Users/kubov/projects/rustc/src'
let g:rust_src_path = '/Users/kubov/projects/rustc/src'

"hi Normal ctermbg=none
"let t:is_tranparent = 1
"

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
