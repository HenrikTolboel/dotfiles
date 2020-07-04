#echo ".cshrc"

## guard: non-interactive
if (! $?prompt) exit

## guard: which(1)
if ("$prompt" == "") exit

#stty intr ^C

setenv LESS smeqFXR

setenv SOURCE /Users/henrik/Documents

set host = `uname -n | tr '[a-z]' '[A-Z]'`

# Status line setup
if ( $TERM == sun ) then
	alias stln 'echo -n "^[]l \!* ^[\"'
else if ( $TERM == xterm ) then
	alias stln 'echo -n "]2; \!* "'
	#alias stln 'echo -n "^[]2; \!* ^G"'
else
	alias stln 'echo "\!*" >/dev/null'
endif

#TCSH:
#alias precmd 'echo -n "\033]0;$cwd\007"'
alias precmd 'echo -n "]0;`pglobal`"'

alias stdir 'stln "-- $host - `/bin/pwd` -- Level `echo $REL.$LEV - $SubSys -$SCCSPATH` --"'

alias plocal  'expr "$cwd" : "$SOURCE/\(.*\)"'
alias pglobal 'expr "$cwd" : "/\(.*\)"'
set Host = `uname -n`
if ( $Host == henrik.local ) set Host = henrik
#alias prompt1 'if "$cwd" =~ "$SOURCE"* set prompt = "`uname -n`($REL.$LEV)(\! )`plocal`% " '
#alias prompt2 'if "$cwd" !~ "$SOURCE"* set prompt = "`uname -n`($REL.$LEV)(\! )`pglobal`% " '
alias prompt1 'if "$cwd" =~ "$SOURCE"* set prompt = "$Host(\!\)`plocal`% " '
alias prompt2 'if "$cwd" !~ "$SOURCE"* set prompt = "$Host(\!\)/`pglobal`% " '
#alias cd 'set olddir = $cwd; chdir \!* && prompt1 && prompt2; stdir'
#alias dc 'set tmpdir = $cwd; chdir $olddir && prompt1 && prompt2; set olddir = $tmpdir; stdir'
alias cd 'set olddir = "$cwd"; chdir \!* && prompt1 && prompt2'
alias dc 'set tmpdir = "$cwd"; chdir "$olddir" && prompt1 && prompt2; set olddir = "$tmpdir"'
alias pushd   'pushd \!* && prompt1 && prompt2'
alias popd    'popd  \!* && prompt1 && prompt2'
cd $cwd

set history = 60
#set filec
set fignore=(.o .H .bak .aux .log .GS .X .CV .0)
set notify

set cdpath = ($SOURCE $SOURCE/*)
foreach obj ($SOURCE/*)
   if (-d "$obj") then
      set cdpath=($cdpath $obj)
   endif
end
unset obj

alias ls ls -F
alias ll ls -l
alias lt ls -lrt
alias lg ls -lg
alias M less
alias h history
alias j jobs -l

alias vi mvim --remote-silent
alias grepvi 'vi `grep -l \!\!:1 \!\!:2`'
alias greprm 'rm -i `grep -l \!\!:1 \!\!:2`'


#echo ".cshrc end"
