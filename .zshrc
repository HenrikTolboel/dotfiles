# If you come from bash you might have to change your $PATH.
# On a mac, the PATH gets set from the file /etc/paths
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/bin:$PATH

#export PATH="$PATH:/Users/henrik/bin/istio-1.9.4/bin"

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose z macos vi-mode kubectl helm bazel zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#set -xv
if [[ -f .dircolors ]]; then
   eval `gdircolors .dircolors`
fi
if [[ -f .zshrc.local ]]; then
  source .zshrc.local
fi

#set +xv

export LESS=smeqFXR

setopt no_share_history


alias lt="ls -lrt"
alias h=history
alias m=less
alias j="jobs -l"

#alias vi mvim --remote-silent
#alias grepvi='vi `grep -l \$1 \$2`'
#alias greprm 'rm -i `grep -l \!\!:1 \!\!:2`'

function grepvi() {
   # grepvi <search term> <file pattern>
   vim --  `grep -lr $1 $2`
}


alias gw='`upfind -name gradlew`'
#alias chrome="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
alias d=docker
alias k=kubectl

function upfind() {
  # https://superuser.com/questions/455723/is-there-an-upwards-find
  # Usage: upfind -name 'x*'

  curpwd=$PWD

  while [[ $PWD != / ]] ; do
    find "$PWD"/ -maxdepth 1 "$@"
    cd ..
  done
  cd $curpwd
}

function ideaXX() {
   $HOME/bin/idea >& /tmp/idea.log.$$ &
}


function openXX() {
  /mnt/c/Windows/explorer.exe $@
}

function chrome() {
   open -a "Google chrome" $@
}
function finder() {
   open -a "Finder" $@
}


if [[ $OSTYPE == darwin* ]]; then
   ## https://medium.com/notes-for-geeks/java-home-and-java-home-on-macos-f246cab643bd
   #
   # https://adoptium.net/installation/archives/
   # cd /Users/henrik/Library/Java/JavaVirtualMachines
   # fetch new release
   # tar xzf <openjdk_binary>.tar.gz
   # source ~/.zshrc
   #export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
   export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
   export JAVA_17_HOME=$(/usr/libexec/java_home -v17)
   export JAVA_21_HOME=$(/usr/libexec/java_home -v21)
   export JAVA_23_HOME=$(/usr/libexec/java_home -v23)

   #alias java8='export JAVA_HOME=$JAVA_8_HOME'
   alias java11='export JAVA_HOME=$JAVA_11_HOME'
   alias java17='export JAVA_HOME=$JAVA_17_HOME'
   alias java21='export JAVA_HOME=$JAVA_21_HOME'
   alias java23='export JAVA_HOME=$JAVA_23_HOME'

   # default to Java 21
   export JAVA_HOME=$JAVA_21_HOME
fi

#source /Users/henrik/.docker/init-zsh.sh || true # Added by Docker Desktop




#export DOTNET_ROOT=/opt/homebrew/Cellar/dotnet/8.0.1/libexec
#export PATH=$PATH:$DOTNET_ROOT
