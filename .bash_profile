export PATH=/usr/local/bin:$PATH:$HOME/go/bin:$HOME/Library/Python/3.6/bin
export EDITOR=vim
export GOPATH=$HOME/go

alias ll="ls -lah"
alias gs='git status'
alias gd='tig status'
alias gb='git branch'
alias gc='git checkout'
alias st='git stash'
alias b='tig refs'
alias c='git checkout $(git branch | fzf)'
alias B='git checkout --track -b'
alias dev='git checkout develop'
alias gf='git fetch --all'
# http://stackoverflow.com/questions/6127328/how-can-i-delete-all-git-branches-which-have-been-merged
alias git-cleanup-merged-branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias git-nuke='git reset --hard && git clean -df'
alias t='tig'

alias d='cd ~/dotfiles'
alias oss='cd ~/oss'
alias jck='cd ~/oss/jeremyckahn'
alias D='cd ~/Desktop'
alias grep='grep --color=auto'
alias less='less -r'
alias ni="npm install --save"
alias nu="npm uninstall --save"
alias nid="npm install --save-dev"
alias nud="npm uninstall --save-dev"
alias nh="npm home"
alias nd="npm docs"
alias ios='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias nom='npm' # nom all the things
alias mf='misfit'
alias sudio="say There\'s this girl that\'s been on my mind All the time, Sussudio oh oh Now she don\'t even know my name But I think she likes me just the same Sussudio oh oh  Oh if she called me I\'d be there I\'d come running anywhere She\'s all I need, all my life I feel so good if I just say the word Sussudio, just say the word Oh Sussudio  Now I know that I\'m too young My love has just begun Sussudio oh oh Ooh give me a chance, give me a sign I\'ll show her anytime Sussudio oh oh  Ah, I\'ve just got to have her, have her now I\'ve got to get closer but I don\'t know how She makes me nervous and makes me scared But I feel so good if I just say the word Sussudio just say the word Oh Sussudio, oh  Ah, she\'s all I need all of my life I feel so good if I just say the word Sussudio I just say the word Oh Sussudio I just say the word Oh Sussudio I\'ll say the word Sussudio oh oh oh Just say the word"
alias word-diff='git diff --word-diff=color'
alias cs='cat $(ack -l "") | fzf'
alias clean_ds_store='find ./ -name ".DS_Store" -depth -exec rm {} \;'

# https://remysharp.com/2018/08/23/cli-improved#fzf--ctrlr
# brew install bat
function preview () {
  rg --files --hidden --glob '!.git/*' | fzf --preview 'bat --color always {}'
}

# Requires asciinema and svg-term
# brew install asciinema
# npm install -g svg-term-cli
alias record="asciinema rec /tmp/temp.cast --overwrite && cat /tmp/temp.cast | svg-term > recording.svg"

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

  if [ "$1" ]; then
    SERVER_PORT=$1
  fi

  live-server --port="${SERVER_PORT}" --ignore=.git
}

# Prints the machine's broadcasting network IP
function ip () {
  ifconfig | grep broadcast | awk '{print $2}' | head -n1
}

function git-kill-branch () {
  # http://stackoverflow.com/a/6482403
  if [ -z "$1" ]; then
    echo "Please specify a branch."
    return 1
  fi

  git branch -D "$1"
  git push origin :"$1"
}

function git-kill-tag () {
  # https://nathanhoad.net/how-to-delete-a-remote-git-tag
  if [ -z "$1" ]; then
    echo "Please specify a tag"
    return 1
  fi

  git tag -d "$1"
  git push origin :refs/tags/"$1"
}

source ~/dotfiles/helpers/git-completion.bash

# Push the current branch
function PS () {
  git push origin -u `git branch | grep \* | sed 's/\* //'`
}

# Force push the current branch
function FORCE_PUSH () {
  git push --force-with-lease origin -u `git branch | grep \* | sed 's/\* //'`
}

# Pull the current branch
function PL () {
  git pull origin `git branch | grep \* | sed 's/\* //'`
}

# Find and replace all files recursively in the current directory.
function find_and_replace () {
  grep -rl $1 ./ | xargs sed -i s/$1/$2/
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
    return
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
    return
  fi

  mv $1 ${1:1}
}

# The bash-powerline fork doesn't work well on Linux
if [ "$(uname)" == "Darwin" ]; then
  source ~/dotfiles/bash-powerline/bash-powerline.sh
fi

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
    return
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
  if [ "$(uname)" == "Darwin" ]; then
    if [ -z "$1" ];
    then
      open ./
    else
      open $1
    fi
  else
    if [ -z "$1" ];
    then
      xdg-open ./
    else
      xdg-open $1
    fi
  fi
}

# https://gist.github.com/intel352/9761288
function git-show-base-branch () {
  branch=`git rev-parse --abbrev-ref HEAD`
  git show-branch | ack '\*' | ack -v "$branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

function _github_repo () {
  echo $(git remote -v show | head -n1 | grep -o ":.*\.git" | sed "s/^.//;s/.git//")
}

# Open the Github repo for the current directory
function GH () {
  REPO=$(_github_repo)
  open "https://github.com/$REPO"
}

function PR () {
  REPO=$(_github_repo)
  BASE_BRANCH=$(git-show-base-branch)
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  open "https://github.com/$REPO/compare/$BASE_BRANCH...$CURRENT_BRANCH"
}

# Usage:
#
#   dl-yt-audio-chunk [youtube-url] [start-time] [duration] [filename]
#
#  start-time and duration must be in HH:MM:SS format, and filename must not
#  have a file type suffix.
#
# Requires youtube-dl and ffmpeg
function dl-yt-audio-chunk () {
  ffmpeg -ss "$2" -i $(youtube-dl -f best --get-url "$1") -t "$3" -c:v copy -c:a copy "/tmp/$4.mp4"
  ffmpeg -i "/tmp/$4.mp4" -vn -acodec copy "$4.aac"
}

nr () {
  if [ -z "$1" ];
  then
    npm run $(node -e "Object.keys(require('./package.json').scripts).forEach(script => console.log(script))" | fzf)
  else
    npm run "$1"
  fi
}

function __new_project () {
  PROJECT_TYPE="$1"
  PROJECT_NAME="$2"

  if [ -z "$PROJECT_NAME" ];
  then
    echo "Must specify a project name as the first argument"
    return
  else
    git clone --depth=1 "https://github.com/jeremyckahn/$PROJECT_TYPE.git" "$PROJECT_NAME"
    cd "$PROJECT_NAME" || return
    rm -rf .git
    find . -type f -exec sed -i "" "s/$PROJECT_TYPE/$PROJECT_NAME/g" {} \;
    git init
    git add --all
    git commit -m "Initial commit"
    npm install
  fi
}

function new_cli_tool () {
  __new_project node-cli-boilerplate "$1"
}

function new_js_project() {
  __new_project js-project-starter "$1"
}

function new_react_project() {
  __new_project react-starter "$1"
}

# https://tomlankhorst.nl/brew-bundle-restore-backup/
backup_brew () {
  pushd ~/dotfiles
  brew bundle dump --force
}

#https://stackoverflow.com/a/41199625
backup_npm () {
  npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > ~/dotfiles/npm_backup
}
restore_npm () {
  xargs npm install --global < ~/dotfiles/npm_backup
}

function v () {
  if [ "$(jobs | grep -c vim)" == 0 ];
  then
    if [ -z "$1" ];
    then
      vim
    else
      vim "$1"
    fi
  else
    fg $(jobs | grep vim | grep -o "\d")
  fi
}

function mirror_from_to () {
  if [ -z "$1" ] || [ -z "$2" ];
  then
    echo "Requires a \"from\" and \"to\" file"
  else
    nodemon --watch "$1" --exec "cp $1 $2"
  fi
}
