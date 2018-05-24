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
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# prompt
PROMPT="%K{233}%F{028}[%D{%m/%d %T}]%k%f %F{033}%K{233}[%n@%m]%f%k %K{233}%F{098}%~%f%k %K{233}%F{052} %# %f%k "

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
