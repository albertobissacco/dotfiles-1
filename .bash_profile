export PATH=/usr/local/bin:$PATH
export EDITOR=vim

alias ll="ls -lah"
alias gs='git status'
alias gd='tig status'
alias gb='git branch'
alias gl='git log'
alias gc='git checkout'
alias st='git stash'
alias B='git checkout --track -b'
alias dev='git checkout develop'
alias gf='git fetch'
alias diffmaster='git diff master -w | tig'
# http://stackoverflow.com/questions/6127328/how-can-i-delete-all-git-branches-which-have-been-merged
alias git-cleanup-merged-branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias git-nuke='git reset --hard && git clean -df'
alias git-lost='git-nuke'
alias ss='svn status'
alias v='vim'
alias t='tig'
alias s='cd ~/Sites'
alias l='cd ~/Sites/lib'
alias a='cd ~/Sites/app'
alias d='cd ~/dotfiles'
alias D='cd ~/Desktop'
alias grep='grep --color=auto'
alias tmux="tmux -2"
alias ni="open http://127.0.0.1:8080/debug?port=5858 && node-inspector"
# Outputs a version of a file that has no blank lines.
#   noblanklines [filename]
alias noblanklines='grep -v "^[[:space:]]*$"'
alias ios='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias nom='npm' # nom all the things
alias nr='npm run'
alias mf='misfit'
alias gurnt='grunt'
alias bumpnbuild='grunt bump && grunt build'
alias sudio="say There\'s this girl that\'s been on my mind All the time, Sussudio oh oh Now she don\'t even know my name But I think she likes me just the same Sussudio oh oh  Oh if she called me I\'d be there I\'d come running anywhere She\'s all I need, all my life I feel so good if I just say the word Sussudio, just say the word Oh Sussudio  Now I know that I\'m too young My love has just begun Sussudio oh oh Ooh give me a chance, give me a sign I\'ll show her anytime Sussudio oh oh  Ah, I\'ve just got to have her, have her now I\'ve got to get closer but I don\'t know how She makes me nervous and makes me scared But I feel so good if I just say the word Sussudio just say the word Oh Sussudio, oh  Ah, she\'s all I need all of my life I feel so good if I just say the word Sussudio I just say the word Oh Sussudio I just say the word Oh Sussudio I\'ll say the word Sussudio oh oh oh Just say the word"

# http://stackoverflow.com/a/21295146/470685
alias ports_in_use='lsof -i -n -P | grep TCP'

# Take whatever JSON data is in the OS X pasteboard, jsonlint it, and pipe it
# into a new Vim buffer.
#
# Requires jsonlint (`npm install -g jsonlint`).
alias json2vim='pbpaste | jsonlint | vim -'

# Temporarily disable BASH history
# http://www.guyrutenberg.com/2011/05/10/temporary-disabling-bash-history/
alias disablehistory="unset HISTFILE"

# Start a simple server.  Provide a port number as an argument or leave it
# blank to use 8080.
#
# Requires Node and http-server:
#   npm install live-server -g
function serve () {
  SERVER_PORT=8080

  if [ $1 ]; then
    SERVER_PORT=$1
  fi

  live-server --port=${SERVER_PORT}
}

# Prints the machine's broadcasting network IP
function ip () {
  ifconfig | grep broadcast | awk '{print $2}' | head -n1
}

# Starts watching a file and `cat`s it whenever the contents change. Ctrl+c to
# quit.
#
# Requires Node and nodemon:
#   npm install -g nodemon
function watch_and_log () {
  nodemon -x cat $1 -w $1
}

function git-kill-branch () {
  # http://stackoverflow.com/a/6482403
  if [ -z "$1" ]; then
    echo "Please specify a branch."
    return 1
  fi

  git branch -D $1
  git push origin :$1
}

DOTFILES=~/dotfiles

source $DOTFILES/helpers/git-completion.bash

# Push the current branch
function psh () {
  git push origin -u `git branch | grep \* | sed 's/\* //'`
}

# Force push the current branch
function PUSH () {
  git push --force origin -u `git branch | grep \* | sed 's/\* //'`
}

alias pushit="psh" # \m/ (>_<) \m/

# Pull the current branch
function pll () {
  git pull origin `git branch | grep \* | sed 's/\* //'`
}

# Find and replace all files recursively in the current directory.
function find_and_replace () {
  grep -rl $1 ./ | xargs sed -i s/$1/$2/
}

function svnaddall () {
  svn status | grep -v "^.[ \t]*\..*" | grep "^?" | awk '{print $2}' | xargs svn add
}

function svndeleteall () {
  svn status | grep -v "^.[ \t]*\..*" | grep '^!' | awk '{print $2}' | xargs svn rm
}

# makes the connection to localhost:8888 really slow.
function goslow () {
  ipfw pipe 1 config bw 4KByte/s
  ipfw add pipe 1 tcp from any to me 8888
}

# makes the connection to localhost:8888 fast again
function gofast () {
  ipfw flush
}


# Compare the contents of a directory tree, recursively.
#
# Usage:
#
#  compare_trees dir_one dir_two
function compare_trees () {
  if [ -z "$1" -o -z "$2" ];
  then
    echo "You need to specify two directories to compare."
    exit 1
  fi

  diff <(pushd $1; ls -R) <(pushd $2; ls -R)
}

function resource () {
  if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
  fi
  if [ -f ~/.bashrc ]; then
    source ~/.bashrc
  fi
}

# Rename file "foo" to "_foo"
#
# Usage: hide [filename]
function hide () {
  if [ -z "$1" ];
  then
    echo "Please specify a file to hide."
    exit 1
  fi

  mv $1 _$1
}

# Rename file "_foo" to "foo"
#
# Usage: unhide [filename]
function unhide () {
  if [ -z "$1" ];
  then
    echo "Please specify a file to unhide."
    exit 1
  fi

  mv $1 ${1:1}
}


# Colors for the command prompt
__BLUE="\[\033[0;34m\]"
__GREEN="\[\033[0;32m\]"
__LIGHT_BLUE="\[\033[1;34m\]"
__LIGHT_GRAY="\[\033[0;37m\]"
__LIGHT_GREEN="\[\033[1;32m\]"
__LIGHT_RED="\[\033[1;31m\]"
__PLAIN="\[\033[0;0m\]"
__RED="\[\033[0;31m\]"
__WHITE="\[\033[1;37m\]"

# Build a custom command prompt
function __prompt_cmd() {
  echo -ne "\033]0;${PWD##*/}\007"
  PS1="$__LIGHT_GRAY[\h]$__LIGHT_BLUE[\W]$__PLAIN "
}
export PROMPT_COMMAND=__prompt_cmd

# Names iTerm2 tab
# http://superuser.com/a/560393
function name_tab () {
  if [ $1 ]; then
    TAB_NAME=$1
  else
    # Get the current directory name if no tab name was specified
    # http://stackoverflow.com/a/1371283
    TAB_NAME=${PWD##*/}
  fi

  str='echo -ne "\033]0;'$TAB_NAME'\007"'
  export PROMPT_COMMAND=$str
  echo "iTerm tab is now \"$TAB_NAME\""
}
alias N='name_tab'

# Setup some of the git command prompt display stuff
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILE=1
export GIT_PS1_SHOWUPSTREAM="auto"

TERM=screen-256color

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Always follow symlinks.
#
# This alias needs to be below the RVM line above, for some crazy reason.
# Syntax errors occur on shell startup, otherwise.
alias cd="cd -P"

function __file_size {
  echo `cat $1 | gzip -9f | wc -c`
}

function file_size {
  echo `__file_size $1` "bytes, gzipped."
}

function minified_js_size {
  echo `__file_size <(uglifyjs $1)` "bytes, minified and gzipped."
}

function mkdir_and_follow {
  mkdir -p $1 && cd $_
}

# Compare current Git branch to another brand and view it in Tig's friendly
# pager.  Usage
#
#   diffbranch develop
function diffbranch () {
  if [ -z "$1" ];
  then
    echo "You need to specify a branch."
    exit 1
  fi

  BRANCH=$1
  git diff $BRANCH -w | tig
}

# https://gist.github.com/meltedspork/b553985f096ab4520a2b
function killport () {
  lsof -i tcp:$1 | awk '{ if($2 != "PID") print $2}' | xargs kill -9;
}

function checkpoint () {
  git commit -am "$(echo "puts Time.new.inspect" | ruby)"
}

function o () {
  if [ -z "$1" ];
  then
    open ./
  else
    open $1
  fi
}

# Open the Github repo for the current directory
function gh () {
  REPO=$(git remote -v show | head -n1 | grep -o ":.*\.git" | sed "s/^.//;s/.git//")
  open "https://github.com/$REPO"
}
