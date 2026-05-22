# Terminal tips framework
# See issue #2 (Add interactive terminal tips framework)
# See issue #3 (Add contextual terminal tips for current workspace state)

_TIPS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/tips.tsv"

# Show a random tip from tips.tsv
terminal_tip() {
  [[ "${TERMINAL_TIPS:-1}" == "0" ]] && return
  [[ ! -f "$_TIPS_FILE" ]] && return
  local count line
  count=$(wc -l < "$_TIPS_FILE")
  [[ "$count" -eq 0 ]] && return
  line=$(sed -n "$((RANDOM % count + 1))p" "$_TIPS_FILE")
  local text="${line#*	}"
  printf '💡 %s\n' "$text"
}

# Search tips by topic: tip <query>
tip() {
  [[ ! -f "$_TIPS_FILE" ]] && { echo "No tips file found at $_TIPS_FILE"; return 1; }
  if [[ -z "${1-}" ]]; then
    # No argument: print all tips
    while IFS=$'\t' read -r topic text; do
      printf '%-16s %s\n' "[$topic]" "$text"
    done < "$_TIPS_FILE"
  else
    # Filter by topic or text match
    local found=0
    while IFS=$'\t' read -r topic text; do
      if [[ "$topic" == *"$1"* || "$text" == *"$1"* ]]; then
        printf '%-16s %s\n' "[$topic]" "$text"
        found=1
      fi
    done < "$_TIPS_FILE"
    [[ "$found" -eq 0 ]] && echo "No tips found for: $1"
  fi
}

# Show a tip on interactive shell startup
if [[ $- == *i* ]]; then
  terminal_tip
fi
