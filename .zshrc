# Set up the prompt
# 
# autoload -Uz promptinit
# promptinit
# prompt adam1

# setopt histignorealldups sharehistory
# 
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# 
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# zplug
source ~/.zplug/init.zsh

# plugins
zplug "zsh-users/zsh-completions"              # 補完強化
zplug "zsh-users/zsh-history-substring-search" # コマンド入力中に上キーや下キーを押した際の履歴の検索を使いやすくする
zplug "zsh-users/zsh-syntax-highlighting"      # コマンドが間違っているときとか赤色で教えてくれる
zplug "peco/peco", as:command, from:gh-r       # ctrl + r の強化版みたいな
zplug "b4b4r07/enhancd", use:init.sh           # cdコマンド ++

zplug check || zplug install
zplug load # --verbose # でプラグインのロードを教えてくれる

# for peco
function peco-history-selection() {
  BUFFER=`history -n -1000 | perl -e 'print reverse <>' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

function liiu_git_current_branch() {
  echo `git branch --contains | grep "* " | perl -ple 's/\* //g'`
}

function liiu_git_parent_branch() {
  echo `git show-branch 2> /dev/null | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)" | head -1 | awk -F'[]~^[]' '{print $2}'`
}

PROMPT="%K{233}%F{028}%D{%m/%d %T}%k%f %F{033}%K{233}【%n@%m】%f%k %K{233}%F{098}%~%f%k %K{233}%F{220}($(liiu_git_parent_branch))%f%k ~~> %K{233}%F{198}($(liiu_git_current_branch))%f%k %K{233}%F{202}%#%f%k "

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=500000
setopt hist_ignore_all_dups # 同じコマンドをヒストリに保存しない
setopt hist_reduce_blanks   # 無駄なスペースを消してヒストリに保存する
setopt share_history        # ヒストリを共有

# ユーザーグローバルに使いたいツールのため
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"

# alias
alias ls=exa

# Perl5
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# Perl6
export PATH="$HOME/.p6env/bin:$PATH"
eval "$(p6env init -)"

# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Crystal
export PATH="$HOME/.crenv/bin:$PATH"
eval "$(crenv init -)"
export CRYSTAL_DIR="$HOME/.crystal"
export PATH="$CRYSTAL_DIR/bin:$PATH"

# Haskell (stack)
export PATH="$HOME/.local/bin:$PATH"
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

# Golang
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"
eval "$(goenv init -)"

# Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# deno
export PATH="$HOME/.deno/bin:$PATH"

# copy from https://github.com/creationix/nvm/Readme.md
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

