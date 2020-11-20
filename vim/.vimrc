set noautochdir
set nocompatible

set encoding=utf-8

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'itchyny/lightline.vim'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'duythinht/vim-coffee'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-eunuch'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'mattn/emmet-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/fzf.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'honza/vim-snippets'
Plugin 'neoclide/coc.nvim'
Plugin 'MaskRay/ccls'
" Themes
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'ajmwagar/vim-deus'
Plugin 'morhetz/gruvbox'
Plugin 'dag/vim-fish'
Plugin 'junegunn/goyo.vim'
" Javascript/React
Plugin 'pangloss/vim-javascript'
Plugin 'leafgarland/typescript-vim'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'styled-components/vim-styled-components'
Plugin 'jparise/vim-graphql'
Plugin 'neoclide/coc-tsserver'
Plugin 'neoclide/coc-eslint'
Plugin 'neoclide/coc-prettier'
Plugin 'neoclide/coc-json'
Plugin 'neoclide/coc-lists'
call vundle#end()
filetype plugin indent on

set nu
syntax on
filetype plugin indent on
set t_Co=256

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-tsserver'
  \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

nnoremap <silent> K :call CocAction('doHover')<CR>
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>do <Plug>(coc-codeaction)

" This is important as nvim will not turn check spell
set nospell
nnoremap <leader>s :set invspell spelllang=sk<CR>
nnoremap <leader>e :set invspell spelllang=en_us<CR>
nnoremap <leader>m :!make<CR>

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

nmap <C-k> 5k
nmap <C-j> 5j

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

set t_Co=256   " This is may or may not needed.

set background=dark
set laststatus=2
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   },
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

colorscheme PaperColor

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype yaml setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cmake setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype javascript setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gp <Plug>(coc-diagnostic-prev)

function CopySystem() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'| pbcopy')
endfunction

xnoremap <leader>gy <esc>:'<,'>call CopySystem()<CR>

nnoremap <leader>s :set invspell spelllang=sk<CR>
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
