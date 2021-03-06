"set verbose=20
"""
""" Version $Id: .vimrc,v 1.7 2005/06/14 14:26:29 fma Exp $
""" (C) Copyright 2000 CCI-Europe. Author : fma
"""
""" Revision History """
""" End of Revisions """
"
" My .vimrc file
" 2000.11.14/LCH: To run vim at home under windows you need:
"   /net/sccs10/Local/Sun4OS5/share/vim/{vimrc,cciscripts.vim,ccisyntax.vim,newfmgr.vim,utils.vim}
"   /net/sccs10/Local/Sun4OS5/share/vim/stuff/{cciist.exe,vimls.exe}
"   $HOME/{.vimrc,.vimrc.priv,.vimrc.syntax}
" Download vim from http://www.vim.org and install it in e.g. C:\Programmer\Vim
" Put all the above files there, while substituting a leading . with an _
" e.g. .vimrc -> _vimrc
" Create the folder C:/temp/preserve for the swap files.
" You may also download the 'fixed' font: http://www.hassings.dk/lars/fonts.html
"
let loaded_vimspell = 1 " Too much fuss right now
let loaded_explorer = 1 " Don't want plugin/explorer.vim
let loaded_netrw    = 1 " Don't want plugin/netrw stuff

if has("win32")
   " Use CCI standard setup. This happens automatically on UNIX
   if filereadable($VIM . "/vimrc")
      source $VIM/vimrc
   endif
else
   " Use CCI standard setup. If system vimrc is /etc/vimrc (Linux) we must source manually
   " The CCI $VIM/vimrc sets the variable vimrcdir
   if !exists("vimrcdir")
      " The CCI $VIM/vimrc has not been run yet
      if filereadable($VIM . "/vimrc")
         source $VIM/vimrc
      endif
   endif
endif

" Setup my own color preferences for syntax highlighting
let tmppath = $HOME . "/" . ".vimrc.syntax"
"On Win98 HOME is not set, so vim defaults it to C:/
"and tmppath becomes C://.vimrc.syntax
"This takes 30 seconds to process, apparently a host file is searched for...
let tmppath = substitute($HOME . "/" . ".vimrc.syntax", "^C://", "C:/", "")
if filereadable(tmppath)
   let usersyntaxfile = tmppath
else
   "Typically case on PC's at home, $VIM is C:\Programmer\Vim
   let tmppath = $VIM . "/" . "_vimrc.syntax"
   if filereadable(tmppath)
      let usersyntaxfile = tmppath
   endif
endif
unlet tmppath

" We are ready to enable the syntax system now
syntax on
if v:version >= 600 | filetype plugin indent on |endif
if v:version >= 700 | set completeopt= |endif
augroup filetype
autocmd BufEnter *.r set ft=xdefaults
"LCH 2008.05.29 added filetyp objc for *.m
"autocmd BufRead *.m,*.mm set ft=objc
augroup END

let CurPath = getcwd()
while strlen(CurPath) > 3
   if filereadable(CurPath."/tags")
      exe "set tags+=".CurPath."/tags"
   endif
   if strlen(glob(CurPath."/include"))
      exe "set path+=".CurPath."/include"
   endif
   if strlen(glob(CurPath."/*.h"))
      exe "set path+=".CurPath
   endif
   if filereadable(CurPath."/.glimpse_index")
      let g:GlimpsePath = CurPath
   endif
   let CurPath = substitute(CurPath, '[/\\]\+[^/\\]*$', "", "")
endwhile

" My initialization has set TAGLIST an INCDIRS from the $SCCSPATH
if exists("$TAGLIST")
   " Presumably includes /SccsBin/HelpFiles/$REL.$LEV/vimtags
   execute "set tags+=".$TAGLIST
endif
let g:incdirs = ""
if exists("$INCDIRS")
   " For finding file under cursor with gf and searching include files with [i
   " Presumably set to /SccsHome/$REL.$LEV/include for all levels in $SCCSPATH
   " You might want to include ccsshell and ccs/DbaTools as well
   let g:incdirs = &path.",".$INCDIRS
   execute "set path+=".$INCDIRS
endif

if has("win32")
   behave xterm
   set directory=C:/temp/preserve//   " Home of the swap files_
   if filereadable('C:\Programs\NT_SFU\Shell\grep.EXE')
      set grepprg=grep\ -n            " Use POSIX grep if available
   endif

   " Let VIM know about VisualC++ include files
   if exists("$include")
      let more = substitute($include, ';', ',', 'g')
      let more = substitute(more, ' ', '\\\\\\ ', 'g')
      execute "set path+=" . more
      let g:incdirs = g:incdirs.",".more

      let more = substitute($include, ';', '\\\\\\tags,', 'g')
      execute "set tags+=" . substitute(more, ' ', '\\\\\\ ', 'g') . '\\tags'
      unlet more
   endif

   if exists("$SCCSHOME")
      " Can not handle '/' to '\' conversion otherwise
      let $SCCSHOME = $SCCSHOME . "/"
   endif

   if has("gui_running")
      " http://www.hassings.dk/lars/fonts/fixed613.fon
      set guifont=fixed613,Courier_New:h9
      " System menu and quick minimize
      map <M-Space> :simalt ~<CR>
      map <M-n> :simalt ~n<CR>
      " Size the GUI window. Delay positioning until window is created
      set lines=50
      set columns=80
      augroup AutoPos
      autocmd BufEnter * winp 200 50 | autocmd! AutoPos
      augroup END
   endif
else
   if (&term == "cygwin") " This seem to have some quirks, work around some
      set directory=/var/preserve/
      "let &t_@7="\<Esc>[4~"   " Make <End> work
      "let &t_kh="\<Esc>[1~"   " Make <Home> work
   else
      set directory=/var/preserve/$USER//
      if has("gui_running")
         set guifont=fixed
      else
         " Uncomment line below to use :emenu. Adds ~1 second to startup time
         source $VIMRUNTIME/menu.vim

         " Make <End> work - Some options cannot be assigned to with 'let'
         exe "set t_@7=\<Esc>OF"

         " Must be _very_ slow to handle triple clicks
         set mousetime=1500
         if &ttymouse == "xterm2"
            " The xterm2 mode will flood us with messages
            set ttymouse=xterm
         endif

         " Save and restore the "shell" screen on enter and exit
         let &t_ti = "\<Esc>7\<Esc>[?47h"
         let &t_te = "\<Esc>[2J\<Esc>[?47l\<Esc>8"

         " Make <Del> mappings work
         exe "set t_kb=\010"
         exe "set t_kD=\177"

         " Make shifted cursor keys work.
         " For the necessary xmodmap commands, see  :help hpterm
         map  <t_F3>   <S-Up>
         map! <t_F3>   <S-Up>
         map  <t_F6>   <S-Down>
         map! <t_F6>   <S-Down>
         map  <t_F8>   <S-Left>
         map! <t_F8>   <S-Left>
         map  <t_F9>   <S-Right>
         map! <t_F9>   <S-Right>
         " To make the shift-Tab <S-Tab> key work, see :help suffixes
         cmap <Esc>[1~ <C-P>
         cmap <Esc>[1;2~ <C-P>
      endif
   endif
endif
if has("gui_running")
    set title icon
    set titlestring=%F%(\ --\ %a%)
    set iconstring=%f
    set guioptions+=a
else
    set notitle noicon         " Do _not_ mess with title string of my xterm
endif
set showcmd                    " Show chars for command in progress on ruler
set exrc                       " Allow .vimrc in current dir
set hidden                     " Dont unload buffers BEWARE OF :q! and :qa! !!!
set backspace=indent,eol       " Can ^H/^W/^U across lines in insert
set sidescroll=5
set scrolloff=4
set equalprg=Csb               " Use '=' to filter through. == -> current line
if has("win32")
   if $USERDOMAIN != "CCIEUROPE" && !executable("Csb")
      if executable($VIM."/cciist.exe")
         set equalprg=$VIM/cciist.exe
      endif
   endif
endif
set keywordprg=Sym             " Use 'k' to see usage of sym under cursor
set textwidth=75
set whichwrap=h,l,<,>,[,]      " Do not backspace/space across line boundaries
set autoindent
set winheight=10               " Make new windows this high
set cmdheight=2                " status line area height - higher for quickfix
set laststatus=2               " always with statusline
set showmatch
set autowrite                  " write files back at ^Z, :make etc.
"set ignorecase
"set shiftwidth=3              " These are now handled at SetBufOpts
"set softtabstop=3
"set expandtab
set mouse=nv                   " Use xterm mouse mode in insert/cmdline/prompt
set clipboard=autoselect       " Visual to/from clipboard
set fileformats=unix,dos,mac
set showbreak=________         " Show me where long lines break
set showfulltag                " Insert function prototype in ^X^]
set incsearch nohlsearch       " Search while typing, 'zx' toggles highlighting
set helpheight=100             " Maximize help windows
set shortmess=ato              " Brief messages to avoid 'Hit Return' prompts
set formatoptions=crtqlo        " Comment handling / Dont break while typing
set history=100
set viminfo='20,\"500          " Keep history listings across sessions
set wildmenu                   " Show completion matches on statusline
set wildmode=longest:list,full " Show all candidates & extend before enumerating
set complete=.,w,b,u,]         " Complete from windows, buffers(+unloaded), tags

" LCH preferences begin
set clipboard=exclude:.*       " Never connect to X server
set scrolljump=1
set nowrapscan
set ignorecase
"set expandtab
"map <C-N> :n<CR>
map <C-N> :call NextOcc()<CR>
map !C !! Csb<CR>
map !I :r! Ip %<CR>
map !RM :r /SccsHome/SccsHeaders/mod.hdr<CR>
map !RP :r /SccsHome/SccsHeaders/prog.hdr<CR>
map !RS :r /SccsHome/SccsHeaders/static.hdr<CR>
map !U I/* <Esc>A */<Esc>
map !u ^^3x$xxx
nmap <C-C> yiw
nnoremap g<C-V> <C-V>
nmap <C-V> ciw<C-R>0<Esc>
nmap 1<C-V> "vdiwmv
nmap 2<C-V> diw"vP`vP
"nmap <C-V> :call SwapIt(0)<CR>
"vnoremap g<C-V> <C-V>
"vmap <C-V> :call SwapIt(1)<CR>
"vmap 1<C-V> "sdms
vmap D "sdms
vmap S d"sP`sP
vmap { gm{
vmap } gm}
" LCH preferences end

" Various utility keys
nmap (     :bprev<CR>
nmap )     :bnext<CR>
nmap F     :files<CR>

if v:version >= 600
   nmap Q     :bwipeout<CR>
   nmap !Q    :bwipeout!<CR>
else
   nmap Q     :bdelete<CR>
   nmap !Q    :bdelete!<CR>
endif
nmap [f    :bunload<CR>
nmap zx    :set invhlsearch<CR>
nmap [s    :exe "g/".@/."/p"<CR>

" These seem to be suitable for hitting all keys in mapping within timeout
set timeoutlen=500
set ttimeoutlen=50
" Currently switched off for mappings
set notimeout ttimeout

" Make cursor keys jump out of insert. Your preference may differ
imap <Left>     <Esc>
imap <Right>    <Esc>
imap <Up>       <Esc>
imap <Down>     <Esc>
imap <S-Left>   <Esc>
imap <S-Right>  <Esc>
imap <S-Up>     <Esc>
imap <S-Down>   <Esc>

" Movement with "2x3" block navigation keys. Customize to your liking
nmap <PageUp>   <C-U>
nmap <PageDown> <C-D>
nmap <Home>     <C-Y>
nmap <xHome>    <C-Y>
nmap <End>      <C-E>
nmap <Insert>   [[z.
nmap <Del>      ]]z.
nmap <S-Up>     {
nmap <S-Down>   }

" Insert some standard blobs
map <F2> <C-\><C-N>:r $SCCSHOME/SccsHeaders/static.hdr<CR>

map <F11> :let @l="/*=****************************************************************************\n**\n** DESCRIPTION   : \n**\n** RETURN VALUE  : \n**                                                                           */\n/*=***************************************************************************/\n"<CR>0"lPjjA
"F10 is faster to type than gcP
nmap <F10> yiw?#include<CR>:r !FindProto -is <C-R>0<CR>
nmap gcD yiw?#include<CR>:r !Look -l <C-R>0 \| sed 's,.*/include/,,' \| awk '{print "\#include <" $1 ">"}'<CR>
map <F5> [[{jV]]%=
"map <S-F5> [[{jV]]%!FormatHdr -csb<CR>
map <S-F5> :let LchLineNo=line(".")<CR>[[{jV]]%!FormatHdr -csb<CR>:execute LchLineNo<CR>
map <F6> :%!FormatHdr -csb<CR>G
nmap <F3> n
nmap <S-F3> N
nmap <C-F3> *
nmap <F4> gcn
nmap <S-F4> gcp
nmap <Esc>[2~   <Insert>
nmap <Esc>[3~   <Del>
nmap <Esc>[25~   <S-F5>

" Always delete to left of cursor
inoremap <Del> <C-H>
cnoremap <Del> <C-H>

" List multiple matches at CTRL-]
nmap <C-]>      :T <C-R><C-W><CR>
nmap <F9>       :T <C-R><C-W><CR>
nmap gt         :T <C-R><C-W><CR>
nmap g<F9>      g<C-]>

" Some coloring. These are _my_ preferences
hi statusLine     term=bold,reverse cterm=NONE ctermbg=7 gui=NONE guibg=grey
hi statusLineNC   term=reverse      cterm=NONE ctermbg=8 gui=NONE guibg=darkgrey
hi NonText                                     ctermfg=lightgray
hi Visual                           cterm=Inverse ctermfg=grey ctermbg=black

" Use :T instead of :ta to see file names in ^D complete-lists
command! -complete=tag_listfiles -nargs=1 T tjump <args>|
                                           \call histadd("cmd", "T <args>")

" Append date to files with .LOG in first line
augroup LchLogfile
   au!
   autocmd BufReadPost * call AppendDateIfLog()
augroup end

function! AppendDateIfLog()
   if getline(1) ==# '.LOG'
      call append(line("$"), strftime("%Y%m%d %H:%M"))
      call append(line("$"), "")
      call cursor(line("$"),1)
      set modified
   endif
endfunction

" File type dependent settings
augroup Private
   autocmd FileType tcl,postscr,c,cpp,perl,java call SetSrcOpts()
   autocmd BufNewFile * call SetBufOpts(expand("<afile>:p"))
   autocmd BufReadPre * call SetBufOpts(expand("<afile>:p"))
   autocmd BufNewFile,BufRead *.cp setfiletype objcpp
augroup end

function! SetLocalOpt(Str)
   if v:version >= 600
      exe "setlocal ".a:Str
   else 
      exe "set ".a:Str
   endif
endfunc
command -nargs=* -bar SetLocalOpt call SetLocalOpt("<args>")

function! SetBufOpts(fpath)
   if a:fpath =~ '\f\/src\f'
      " Probably editing some PD stuff, save original, prepare for diff -u
      SetLocalOpt patchmode=.orig
      SetLocalOpt noexpandtab shiftwidth=4 softtabstop=4
   elseif a:fpath =~ '\f\/Documents\f'
      " Probably editing some PD stuff, save original, prepare for diff -u
      "SetLocalOpt patchmode=.orig
      SetLocalOpt noexpandtab shiftwidth=4 softtabstop=4
   else
      " Assume CCI source code
      if $LEV == 12 || $LEV == 36
         SetLocalOpt makeprg=lmake
      else
         SetLocalOpt makeprg=VimMake
      endif
      SetLocalOpt expandtab shiftwidth=3 tabstop=3
   endif
endfunc
" Initial settings.  When called wo. arguments
call SetBufOpts(getcwd())

function! SetSrcOpts()
   " NO autowrap while typing in source code files
   setlocal formatoptions-=t

   if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'java'
      " Dont highligh this as an error
      hi link cCommentStartError Comment
      " Use cindent for C files.
      if version < 600 | SetLocalOpt cindent | endif
      SetLocalOpt cinoptions=(0,w1,u0,:1,=2
      if &filetype == 'java'
         SetLocalOpt shiftwidth=4 tabstop=4
         SetLocalOpt errorformat=%E%f:%l:%m,%Z%p
         SetLocalOpt makeprg=ant\\ -emacs
      endif
   elseif &filetype == 'tcl' || &filetype == 'postscr' || &filetype == 'perl'
      if version < 600
         " No auto 'filetype' indent in version < 600
         " Avoid '#-in-1.-column' problem with cindent & smartindent
         inoremap <buffer> # X<BS>#
         SetLocalOpt smartindent
      endif
   endif
   if &filetype == 'perl'
      highlight link perlFunctionName AltCode
   endif

   let fpath = expand("<afile>:p")
   if fpath !~ '\f\/src\f'
      " Assume CCI source code

      if  exists("*PathStr") && exists("g:incdirs")
         " Set up path for private include files
         let fpath = fnamemodify(PathStr(expand("<afile>:p")), ":h")
         let SccsPath = $SCCSPATH
         let locdirs = ""
         while strlen(SccsPath) > 0
            let spc = match(SccsPath, " ")
            if spc >= 0
               let Part = strpart(SccsPath, 0, spc)
               let SccsPath = strpart(SccsPath,  spc + 1, 1000)
            else
               let Part = SccsPath
               let SccsPath = ""
            endif
            if strlen(Part) > 0
               let locdirs = locdirs.",".$SCCSHOME."/".$REL.".".Part."/".fpath
            endif
         endwhile
         if strlen(locdirs) > 1
            let &l:path = ".,".strpart(locdirs, 1, 1000).",".g:incdirs
         endif
      endif
   endif
endfunc


" Pick a status line, or craft one yourself
" statusline #1, two expressions -- Use a continuation line & quote SCCS keys
set statusline=%<%f%=\ %([%1*%M\%*%n%R\%Y%{VarExists(',GZ','b:zipflag')}
              \]%)\ %02c%V(%02B)C\ %3l/%LL\ %P
" statusline #2, zero expressions
"set statusline=%<%f%=\ %([%n%Xm%Xr%&,HL&h]%)\ %-19(%3l,%02c%'%o%)'%02Xb'
" statusline #3, the default one
"set statusline&

" Coloring of the modified flag
highlight User1 cterm=bold ctermfg=red ctermbg=gray gui=bold guifg=red guibg=gray

" Testing
"set title titlestring=%<%F%=%l/%L-%P titlelen=70
"set rulerformat=%l,%c%_%t-%P

function! VarExists(s,v)
   if exists(a:v)
      return a:s
   else
      return ""
   endif
endfunction

function! Show_g_CTRLG()
   let col   = col(".")
   let vcol  = virtcol(".")
   let line  = line(".")
   let lline = line("$")
   exe "normal $"
   let cole  = col(".")
   let vcole = virtcol(".")
   exe "normal " vcol . "|"

   let out_str = "Col " . col
   if col != vcol
      let out_str = out_str . "-" . vcol
   endif
   let out_str = out_str . " of " . cole
   if cole != vcole
      let out_str = out_str . "-" . vcole
   endif
   let out_str = out_str . "; Line " . line . " of " . lline
   let out_str = out_str . " (" . (line * 100 / lline) . "%)"
   let byte = line2byte(line) + col - 1
   let out_str = out_str . "; Char " . byte
   let lbyte = line2byte(lline) + strlen(getline(lline))
   let out_str = out_str . " of " . lbyte . " (" . (byte * 100 / lbyte) . "%)"

   let F = expand("%")
   if !filereadable(F) 
      echo "File not saved yet"
   else
      echo "Modified: ".strftime("%Y%m%d %T", getftime(F))
   endif
   echo out_str
endfunction
" This is _much_ faster than g<C-G> on large files. And it is more verbose
map g<C-G> :call Show_g_CTRLG()<CR>

func! NextOcc()
   let v:errmsg = ""
   silent! normal n
   if v:errmsg != ""
      "Pattern not found, try next file
      while 1
         let v:errmsg = ""
         silent! next +1    "+1: Start at top of new file
         if v:errmsg != ""
            echohl ErrorMsg | echo "No more matches." | echohl None
            break
         endif
         echohl ErrorMsg | echo "Trying file: ".expand("%") | echohl None
         let v:errmsg = ""
         silent! normal n
         if v:errmsg == ""
            echohl ErrorMsg | echo "New file: ".expand("%") | echohl None
            break
         endif
      endwhile
   endif
endfunc

if filereadable(substitute($HOME."/.vimrc.priv", "^C://", "C:/", ""))
   source $HOME/.vimrc.priv
else
   "Typically case on PC's at home, $VIM is C:\Programmer\Vim
   if filereadable($VIM."/_vimrc.priv")
      source $VIM/_vimrc.priv
   endif
endif

func! MatchObjC()
   source $VIMRUNTIME/macros/matchit.vim
  "if b:match_words =~ ":"
   "let b:match_words = b:match_words . ',@interface\>:@end\>,@implementation\>:@end\>'
   let b:match_words = b:match_words . ',@\(interface\|implementation\)\>:@end\>'
endfunc

augroup LchMatch
"let b:match_words = b:match_words . ',#if\%(def\)\=:#else\>:#elif\>:#endif\>'
   "autocmd BufNewFile,BufRead *.m source $VIMRUNTIME/macros/matchit.vim
   "autocmd BufNewFile,BufRead *.m let b:match_words = b:match_words . ',@interface\>:@end\>,@implementation\>:@end\>'
   "autocmd BufReadPost *.m source $VIMRUNTIME/macros/matchit.vim
   "autocmd BufReadPost *.m let b:match_words = b:match_words . ',@interface\>:@end\>,@implementation\>:@end\>'
   autocmd BufReadPost *.m,*.h call MatchObjC()
augroup end

" echo "DONE sourcing"







func! SwapIt(VisualMode)
"nmap <C-V> ciw<C-R>0<Esc>
"vmap D "sdms
"vmap S d"sP`sP
   "echohl ErrorMsg | echo "VisualMode: ".a:VisualMode." count: ".v:count." register s: ".@s | echohl None
   if (v:count)
      "mark
      if (a:VisualMode)
         normal gv"sdms
      else
         normal "sdiwms
      endif
   else
      "swap (if something in buffer s) or paste
      if @s != ""
         if (a:VisualMode)
            normal gvd"sP`sP
         else
            normal diw"sP`sP
         endif
         let @s = ""
      else
         "Nothing in swap-buffer, just paste
         "normal ciw\<C-R>0\<Esc>
         exe "normal ciw\<C-R>0\<Esc>"
      endif
   endif
endfunc

"vmap h  <ESC>g'<O<C-U>#ifdef UNCOMMENTED_BY_LCH<ESC>g'>o<C-U>#endif<ESC>



