scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim 7.4
"
" Last Change: 23-Mar-2016.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor
unlet s:path

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=8
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set nonumber
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    set term=builtin_linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
endif

" vimproc: 同梱のvimprocを無効化する
if kaoriya#switch#enabled('disable-vimproc')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
endif

" go-extra: 同梱の vim-go-extra を無効化する
if kaoriya#switch#enabled('disable-go-extra')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]golang$"'), ',')
endif


"---------------------------
" Start Neobundle Settings.
"---------------------------
" bundleで管理するディレクトリを指定
set runtimepath+=C:\Users\tsumura/.vim/bundle/neobundle.vim/
 
" Required:
call neobundle#begin(expand('C:\Users\tsumura/.vim/bundle/'))
 
" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'
 
" NERDTreeを設定
NeoBundle 'scrooloose/nerdtree'

" neobundle自体をneobundleで管理
NeoBundle "ctrlpvim/ctrlp.vim"

NeoBundle "Shougo/unite.vim"

NeoBundle "Shougo/neoyank.vim"
 
NeoBundle 'tomtom/tcomment_vim'

NeoBundle 'junegunn/vim-easy-align'

NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundle 'mattn/emmet-vim'

NeoBundle 'w0rp/ale'

NeoBundle 'xsbeats/vim-blade'

NeoBundle 'tpope/vim-surround'

NeoBundle 'tpope/vim-fugitive'

 
call neobundle#end()
 
" Required:
filetype plugin indent on
 
" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
" 毎回聞かれると邪魔な場合もあるので、この設定は任意です。
NeoBundleCheck
 
"-------------------------
" End Neobundle Settings.
"-------------------------



""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
"call plug#begin(expand('C:\Users\tsumura/.vim/plugged/'))

" インデントに色を付けて見やすくする
"Plug 'nathanaelkane/vim-indent-guides'

"call plug#end()
"-------------------------
" End plug Settings.
"-------------------------

"-------------------------
" Setting Start.
"-------------------------
set nocompatible
filetype off

"set rtp+=C:\Users\tsumura/.vim/bundle/Vundle.vim " vundleのインストール先
"call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'

" Directory Tree View
" usage enter :NERDTree in ex mode
"Plugin 'scrooloose/nerdtree'

" Indent Seeing
"Plugin 'nathanaelkane/vim-indent-guides'

"call vundle#end()
filetype plugin indent on

set tabstop=2
set shiftwidth=4
set expandtab
set autoindent
set number
set clipboard=unnamed,autoselect

" indent guide options
colorscheme default
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" map
inoremap jj <ESC>
noremap <CR> o<ESC>
noremap <silent> <S-T> :NERDTreeToggle<CR>


"if has('win32')
"    if has('gui_running')
"        let &termencoding = &encoding
"        set encoding=utf-8
"    else
"        set encoding=cp932
"    endif
"endif
"set tenc=cp932
"set enc=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932
set encoding=utf-8
"set encoding=utf-822-jp,euc-jp,sjis,utf-8
":set shiftwidth=4
set tabstop=2
set shiftwidth=4
set expandtab
set autoindent

if has('gui') || has('xterm_clipboard')
    set clipboard=unnamed
endif

if has('spell') && has('syntax')
    nnoremap <silent><Leader>s :setlocal spell!<CR>:setlocal spell?<CR>
endif



" ## 検索ウィンドウの設定 start ---------------
" :help g:ctrlp_match_window
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:50'

" ルートパスと認識させるためのファイル
"let g:ctrlp_root_markers = ['bootstrap.php']
let g:ctrlp_root_markers = ['projectdir']

" カレントディレクトリを基準に検索
nnoremap <silent> <Space>cf :CtrlPCurWD<CR>

" カレントバッファのルートディレクトリを基準に検索(root:自動認識)
nnoremap <silent> <Space>cF :CtrlPRoot<CR>

" 最近使ったファイルから検索
nnoremap <silent> <Space>cr :CtrlPMRUFiles<CR>
" ## 検索ウィンドウの設定 end -----------------


" ## cTags キーバインド start ---------------
nnoremap <C-[>     :pop<CR>
nnoremap <C-]> g<C-]>
" ## cTags キーバインド end -----------------


" ## Unit.vim  start ---------------
"unite prefix key.
nnoremap [unite] <Nop>
nmap <Space>f [unite]
 
"unite general settings
"インサートモードで開始
let g:unite_enable_start_insert = 1
"最近開いたファイル履歴の保存数
let g:unite_source_file_mru_limit = 50
"現在開いているファイルのディレクトリ下のファイル一覧。
"開いていない場合はカレントディレクトリ
"nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
"バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"ブックマーク一覧
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
"ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
"uniteを開いている間のキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
	"ESCでuniteを終了
	nmap <buffer> <ESC> <Plug>(unite_exit)
	"入力モードのときjjでノーマルモードに移動
	imap <buffer> jj <Plug>(unite_insert_leave)
	"入力モードのときctrl+wでバックスラッシュも削除
	imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
	"ctrl+jで縦に分割して開く
	nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
	inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
	"ctrl+jで横に分割して開く
	nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
	inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
	"ctrl+oでその場所に開く
	nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
	inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
endfunction"}}}






"nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
let g:unite_source_history_yank_enable =1  "history/yankの有効化
nnoremap <silent> ,gy :<C-u>Unite history/yank<CR>
" ## Unit.vim  end -----------------


" ## QuickFix  start ---------------
"set modifiable
"set write
" ## QuickFix  end -----------------


" ## VimGrep  start ---------------
"set wildignore=*.dll,*.exe,tags,*.zip
"set wildignore+=obj/**,.git/**,.svn/**
let s:ignore_list  = ',.git/**,.svn/**,obj/**'
let s:ignore_list .= ',tags,GTAGS,GRTAGS,GPATH'
let s:ignore_list .= ',*.o,*.obj,*.exe,*.dll,*.bin,*.so,*.a,*.out,*.jar,*.pak'
let s:ignore_list .= ',*.zip,*gz,*.xz,*.bz2,*.7z,*.lha,*.lzh,*.deb,*.rpm,*.iso'
let s:ignore_list .= ',*.pdf,*.png,*.jp*,*.gif,*.bmp,*.mp*'
let s:ignore_list .= ',*.od*,*.doc*,*.xls*,*.ppt*,*.log*'

if exists('+wildignore')
  autocmd QuickFixCmdPre  * execute 'setlocal wildignore+=' . s:ignore_list
  autocmd QuickFixCmdPost * execute 'setlocal wildignore-=' . s:ignore_list
endif
" ## VimGrep  end -----------------

" # ALT + v で貼り付け
map <A-v> "+gP
imap <A-v> <ESC><ESC>"+gPa

" # ゴミファイル(「*.un~」「*~」)を作成しない
set noundofile
set nobackup


" # インデント可視化[vim] NERDTreeのメニューにvimdiffオプションをつける。 [vim] NERDTreeのメニューにvimdiffオプションをつける。 
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size = 2

"-------------------------
" Setting End.
"-------------------------

""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
"imap { {}<LEFT>
"imap [ []<LEFT>
"imap ( ()<LEFT>
""""""""""""""""""""""""""""""

" # emmet-vim
let g:user_emmet_leader_key='<c-t>'


" EasyAlign キーバインド
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Copyright (C) 2009-2016 KaoriYa/MURAOKA Taro
