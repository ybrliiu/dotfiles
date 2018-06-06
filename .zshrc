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
  echo `git branch --contains 2> /dev/null | perl -E 'chomp(my $s = <>); print substr($s, 2)'`
}

function liiu_git_parent_branch() {
  echo `git show-branch 2> /dev/null | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)" | head -1 | awk -F'[]~^[]' '{print $2}'`
}

# prompt
_LIIU_PROMPT_CACHE=`pwd`
precmd() {
  if [ $_LIIU_PROMPT_CACHE != `pwd` ]; then
    _LIIU_PROMPT_CACHE=`pwd`
    PROMPT="%K{233}%F{028}%D{%m/%d %T}%k%f %F{033}%K{233}【%n@%m】%f%k %K{233}%F{098}%~%f%k %K{233}%F{220}($(liiu_git_parent_branch))%f%k ~~> %K{233}%F{198}($(liiu_git_current_branch))%f%k %K{233}%F{202}%#%f%k "
  fi
}

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=500000
setopt hist_ignore_all_dups # 同じコマンドをヒストリに保存しない
setopt hist_reduce_blanks   # 無駄なスペースを消してヒストリに保存する
setopt share_history        # ヒストリを共有

# Perl5
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
