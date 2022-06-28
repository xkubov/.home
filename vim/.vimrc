set noautochdir
set nocompatible

set encoding=utf-8

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'GEverding/vim-hocon'
Plugin 'cespare/vim-toml'
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
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jceb/vim-orgmode'
Plugin 'honza/vim-snippets'
Plugin 'neoclide/coc.nvim'
Plugin 'MaskRay/ccls'
Plugin 'vimwiki/vimwiki'
Plugin 'yaunj/vim-yara'
Plugin 'rust-analyzer/rust-analyzer'
Plugin 'udalov/kotlin-vim'
" Themes
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'ajmwagar/vim-deus'
Plugin 'morhetz/gruvbox'
Plugin 'dag/vim-fish'
Plugin 'junegunn/goyo.vim'
Plugin 'w0ng/vim-hybrid'
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
Plugin 'fatih/vim-go'
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
"function! ShowDocIfNoDiagnostic(timer_id)
"  if (coc#util#has_float() == 0)
"    silent call CocActionAsync('doHover')
"  endif
"endfunction
"
"function! s:show_hover_doc()
"  call timer_start(500, 'ShowDocIfNoDiagnostic')
"endfunction
"
"autocmd CursorHoldI * :call <SID>show_hover_doc()
"autocmd CursorHold * :call <SID>show_hover_doc()
"
"autocmd CursorHoldI * :call <SID>show_hover_doc()
"autocmd CursorHold * :call <SID>show_hover_doc()

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
" set statusline+=%{SyntasticStatuslineFlag()}
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
"let g:PaperColor_Theme_Options = {
"  \   'theme': {
"  \     'default': {
"  \       'transparent_background': 1
"  \     }
"  \   },
"  \   'language': {
"  \     'python': {
"  \       'highlight_builtins' : 1
"  \     },
"  \     'cpp': {
"  \       'highlight_standard_library': 1
"  \     },
"  \     'c': {
"  \       'highlight_builtins' : 1
"  \     }
"  \   }
"  \ }

let g:hybrid_custom_term_colors = 1
set background=dark
colorscheme hybrid

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

" set background=dark
" colorscheme PaperColor

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype yaml setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype cmake setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype javascript setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype vimwiki setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype toml setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype conf setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype hocon setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype json setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gp <Plug>(coc-diagnostic-prev)

function CopySystem() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")))
endfunction

xnoremap <leader>gy <esc>:'<,'>call CopySystem()<CR>

nnoremap <leader>s :set invspell spelllang=sk<CR>
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"  \ pumvisible() ? "\<C-n>” :
"  \ <SID>check_back_space() ? "\<TAB>” :
"  \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>” : "\<C-h>”
function! s:check_back_space() abort
 let col = col('.') — 1
 return !col || getline('.')[col — 1] =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected”] != "-1” ? "\<C-y>” : "\<C-g>u\<CR>”
" else
"  inoremap <expr> <cr> pumvisible() ? "\<C-y>” : "\<C-g>u\<CR>”
" endif
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
 if (index(['vim','help'], &filetype) >= 0)
 execute 'h '.expand('<cword>')
 else
 call CocAction('doHover')
 endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
augroup mygroup
 autocmd!
 " Setup formatexpr specified filetype(s).
 autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
 " Update signature help on jump placeholder.
 autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current line.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p :<C-u>CocListResume<CR>
