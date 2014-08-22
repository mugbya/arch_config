
" 设置当文件被改动时自动载入
set autoread

set nocompatible "不要vim模仿vi模式，建议设置，否则会有很多不兼容的问题
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示 
filetype off 

" -----------------------------------------------------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Plugin 'Powerline' 不好用啊
Plugin 'The-NERD-tree'

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'SirVer/ultisnips'


call vundle#end()            " required
filetype plugin indent on    " required
" -----------------------------------------------------




syntax enable
syntax on "打开高亮
"autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
"autocmd InsertEnter * se cul    " 用浅色高亮当前行  

set number              "显示行号
set tabstop=4        "让一个tab等于4个空格
"set go=             " GUI时，不要菜单工具条

set wrap           "自动换行(编辑时)

"set cul	

set t_Co=256
set term=xterm

"colorscheme murphy
"colorscheme 256-jungle 
"colorscheme beauty256
colorscheme ron

set showcmd         " 输入的命令显示出来，看的清楚些 
set novisualbell    " 不要闪烁(不明白)  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=1    " 启动显示状态行(1),总是显示状态行(2)  
 

set autoindent "vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进）

set cindent "（cindent是特别针对C语言语法自动缩进）

set smartindent "依据上面的对齐格式，智能的选择对齐方式，对于类似C语言编写上有用 

"set cursorline=0 不行啊

" let g:NERDTreeHighlightCursorline=0


"hi Normal  ctermfg=252 ctermbg=none

"hi Normal ctermbg=none ctermfg=none  



set hlsearch "高亮显示结果

set incsearch "在输入要搜索的文字时，vim会实时匹配

set backspace=indent,eol,start whichwrap+=<,>,[,] "允许退格键的使用



"字体的设置  ---占时为空


set tags+=./tags
set tags+=/home/mugya/tags
set tags+=/usr/include/tags
set tags+=/usr/include/c++/tags 

nnoremap <F2> :exe 'NERDTreeToggle'<CR>  " 树的快捷键
autocmd vimenter * NERDTree  " 打开vim时，自动打开树当只剩NERDTree时，则自动关闭vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif 

" 折叠
"set foldenable 
"set foldlevel=9999
"set foldmethod=syntax 
"set foldmethod=indent
"set foldmethod=manual
"nnoremap <space> @=((foldclosed(line(',')) < 0) ? 'zc' : 'zo') <CR> 

 set foldenable
" set foldmethod=indent
" nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>




