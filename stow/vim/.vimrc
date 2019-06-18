syntax on
set number
set title

 " redefine tabs
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set colorcolumn=80

nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
nnoremap <C-P>     :NERDTreeFocus<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

 " For Makefile
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
