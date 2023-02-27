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
zplug "peco/peco", as:command, from:github       # ctrl + r の強化版みたいな
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

# prompt
precmd() {
  local current_branch=`git branch --contains 2> /dev/null | grep "* " | perl -ple 's/\* //g'`
  local parent_branch=`git show-branch 2> /dev/null | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)" | head -1 | awk -F'[]~^[]' '{print $2}'`
  PROMPT="%K{233}%F{028}%D{%m/%d %T}%k%f %F{033}%K{233}【%n@%m】%f%k %K{233}%F{098}%~%f%k %K{233}%F{220}($parent_branch)%f%k => %K{233}%F{198}($current_branch)%f%k %K{233}%F{202}%#%f%k "
}

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

# anyenv
if [ ! -d "$HOME/.anyenv" ]; then
	echo "install anyenv..."
	git clone https://github.com/anyenv/anyenv "$HOME/.anyenv" 
        export PATH="$HOME/.anyenv/bin:$PATH"
	anyenv init
	anyenv install --init
	for env in plenv rbenv pyenv nodenv crenv goenv
	do
		anyenv install $env
	done
fi

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# rakuenv
if [ ! -d "$HOME/.rakuenv" ]; then
	git clone https://github.com/skaji/rakuenv ~/.rakuenv
fi

export PATH="$HOME/.rakuenv/bin:$PATH"
eval "$(rakuenv init -)"

# Rust
source "$HOME/.cargo/env"

# deno
export PATH="$HOME/.deno/bin:$PATH"

