" Modeline
" vim: set sw=4 ts=4 sts=4 noexpandtab foldmarker={,} foldlevel=0 foldmethod=marker spell:

set nocompatible			  " be iMproved, required

" Set runtimepath {
	" VIM default is:
	" ~/vimfiles,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/vimfiles/after
	" This makes it use ~/.vim instead of ~/vimfiles
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
" }

" Use bundles config {
	if filereadable(expand("~/.burney-vim/.vimrc.bundles"))
		source ~/.burney-vim/.vimrc.bundles
	endif
" }

" General {
	filetype plugin indent on	" Automatically detect file types.
	syntax on					" Syntax highlighting
	set mouse=a					" Automatically enable mouse usage
	"set mousehide				 " Hide the mouse cursor while typing
	scriptencoding utf-8
	set encoding=utf-8

	if has('clipboard')
		if has('unnamedplus')  " When possible use + register for copy-paste
			set clipboard=unnamed,unnamedplus
		else		 " On mac and Windows, use * register for copy-paste
			set clipboard=unnamed
		endif
	endif

	" Always switch to the current file directory
	" Note: Commented out because it doesn't work with some plugins (ex. fugitive)
	"autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

	set shortmess+=filmnrxoOtT			" Abbrev. of messages (avoids 'hit enter')
	set history=1000					" Store a ton of history (default is 20)
	"set iskeyword-=.					 " '.' is an end of word designator
	"set iskeyword-=#					 " '#' is an end of word designator
	"set iskeyword-=-					 " '-' is an end of word designator

    set gdefault                        " applies substitutions globally on lines

	" Restore cursor {
	" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
	" Restore cursor to file position in previous editing session
	" To disable this, add the following to your .vimrc.before.local file:
	let option_restore_cursor = 1
	if option_restore_cursor > 0
		function! ResCur()
			if line("'\"") <= line("$")
				normal! g`"
				return 1
			endif
		endfunction

		augroup resCur
			autocmd!
			autocmd BufWinEnter * call ResCur()
		augroup END
	endif
	" }
" }

" Setting up the directories {
	set directory=$HOME/.vim/swap	" Centralized place for swap files

	set viewoptions=folds,options,cursor,unix,slash " Use views
	set viewdir=$HOME/.vim/views	" Centralized place for views

	set backup						" Backups are nice ...
	set backupdir=$HOME/.vim/backup " Centralized place for backups

	if has('persistent_undo')
		set undofile				" So is persistent undo ...
		set undodir=$HOME/.vim/undo " Centralized place for undo files
		set undolevels=1000			" Maximum number of changes that can be undone
		set undoreload=10000		" Maximum number lines to save for undo on a buffer reload
	endif
" }

" VIM UI {
	"colorscheme koehler
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
			set statusline+=%{fugitive#statusline()} " Git Hotness
		endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set relativenumber              " Line numbers are relative to cursor (:set nornu to disable)
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set nohlsearch                  " Don't highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    "set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set nolist						" set list displays problematic chars. Don't do this by default
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
    set hidden                      " Allows edited buffers to be hidden without saving first

    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
    endif
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current

    "set matchpairs+=<:>             " Match, to be used with %
    "set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
" }

" Key (re)Mappings {
    " The default leader is '\', but many people prefer ',' as it's in a standard
	let mapleader = ','
	let maplocalleader = '_'

    " Wrapped lines goes down/up to next row, rather than next line in file.
    "noremap j gj
    "noremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    "nmap <leader>f0 :set foldlevel=0<CR>
    "nmap <leader>f1 :set foldlevel=1<CR>
    "nmap <leader>f2 :set foldlevel=2<CR>
    "nmap <leader>f3 :set foldlevel=3<CR>
    "nmap <leader>f4 :set foldlevel=4<CR>
    "nmap <leader>f5 :set foldlevel=5<CR>
    "nmap <leader>f6 :set foldlevel=6<CR>
    "nmap <leader>f7 :set foldlevel=7<CR>
    "nmap <leader>f8 :set foldlevel=8<CR>
    "nmap <leader>f9 :set foldlevel=9<CR>

	" Toggle search highlighting with <leader>/
	nmap <silent> <leader>/ :set invhlsearch<CR>

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Map <leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

	" Buffer mappings
	" F12 is next buffer. Shift-F12 is prev buffer.
	nnoremap <silent> <F12> :bn<CR>
	nnoremap <silent> <S-F12> :bp<CR>
" }

" Plugins {
    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }
	
	" ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
			let g:ctrlp_map = '<c-p>'
			let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            " On Windows use "dir" as fallback command.
			let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
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

			" Auto-clean fugitive buffers
			autocmd BufReadPost fugitive://* set bufhidden=delete
        endif
    " }

	" Syntastic {
        if isdirectory(expand("~/.vim/bundle/syntastic/"))
			set statusline+=%#warningmsg#
			set statusline+=%{SyntasticStatuslineFlag()}
			set statusline+=%*

			let g:syntastic_always_populate_loc_list = 1
			let g:syntastic_auto_loc_list = 1
			let g:syntastic_check_on_open = 1
			let g:syntastic_check_on_wq = 0
		endif
	" }
" }

" Functions {
	" EnsureDirectory() {
		" Creates a directory if it does not exists
		function! EnsureDirectory(directoryPath)
			if exists("*mkdir")
				if !isdirectory(directoryPath)
					call mkdir(directoryPath)
				endif
			endif
			if !isdirectory(directoryPath)
				echo "Warning: Unable to create backup directory: " . directoryPath
				echo "Try: mkdir -p " . directoryPath
			endif
		endfunction
	" }

    " StripTrailingWhitespace() {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }
" }

" Notes {
" Vim Variables
"	$MYVIMRC - tells you what vimrc file it is loading

" Lists all the sourced script names, in the order they were sourced
" :scriptnames

" http://stevelosh.com/blog/2010/09/coming-home-to-vim
" }
