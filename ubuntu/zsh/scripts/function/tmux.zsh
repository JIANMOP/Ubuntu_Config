# ta: 选择 tmux 会话（使用 tmux 原生 ID）
ta() {
  local sessions=$(tmux ls 2>/dev/null)
  if [[ -z $sessions ]]; then
    echo "No tmux sessions running."
    return 1
  fi

  echo "==== TMUX SESSIONS ===="
  echo "0) Exit"
  echo "$sessions" | awk -F: '{print NR ") " $1}'

  echo -n "Enter session ID: "
  read -r num || return 0

  if [[ -z $num || $num -eq 0 ]]; then
    return 0
  fi

  local session_name=$(echo "$sessions" | sed -n "${num}p" | cut -d: -f1)
  if [[ -z $session_name ]]; then
    echo "Invalid selection"
    return 1
  fi

  tmux attach -t "$session_name"
}

# tc: 创建会话
tc() {
  echo -n "Enter session name: "
  read -r name || return 0
  if [[ -z $name ]]; then
    return 0
  fi
  tmux new -s "$name"
}

# td: 删除会话（使用 tmux 原生 ID）
td() {
  local sessions=$(tmux ls 2>/dev/null)
  if [[ -z $sessions ]]; then
    echo "No tmux sessions running."
    return 1
  fi

  echo "==== DELETE TMUX SESSION ===="
  echo "0) Exit"
  echo "$sessions" | awk -F: '{print NR ") " $1}'

  echo -n "Enter session ID to delete: "
  read -r num || return 0

  if [[ -z $num || $num -eq 0 ]]; then
    return 0
  fi

  local session_name=$(echo "$sessions" | sed -n "${num}p" | cut -d: -f1)
  if [[ -z $session_name ]]; then
    echo "Invalid selection"
    return 1
  fi

  tmux kill-session -t "$session_name"
  echo "Deleted: $session_name"
}
