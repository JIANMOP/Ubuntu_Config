# OpenClaw Completion
# source "/home/jianmop/.openclaw/completions/openclaw.zsh"
# alias oc='openclaw'

alias hm='hermes'

alias sshai="ssh 100.66.1.5 -p 2213"

alias bat='batcat'
alias batf='bat --paging=never'
alias catf='bat -p --paging=never'
alias cat='bat -p'
alias cd='z'
alias df='duf'

# 使用 eza 代替传统的 ls，添加图标、显示 Git 状态、按目录优先排序
#alias ls='eza --icons --git --group-directories-first'
#alias ll='eza -lh --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons' # 树状显示，洞察项目结构
alias ls='eza --icons --git --group-directories-first --time-style="+%Y-%m-%d %H:%M:%S %a"'
alias ll='eza -lh --icons --git --group-directories-first --time-style="+%Y-%m-%d %H:%M:%S %a"'
