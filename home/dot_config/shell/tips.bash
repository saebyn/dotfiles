# Terminal tips framework
# See issue #2 (Add interactive terminal tips framework)
# See issue #3 (Add contextual terminal tips for current workspace state)

_TIPS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/tips.tsv"

# Print a random tip matching a given topic prefix
_tip_for_topic() {
  local topic="$1"
  local -a matches=()
  while IFS=$'\t' read -r t text; do
    [[ "$t" == "$topic" ]] && matches+=("$text")
  done < "$_TIPS_FILE"
  local count=${#matches[@]}
  [[ "$count" -eq 0 ]] && return 1
  printf '💡 %s\n' "${matches[$((RANDOM % count))]}"
}

# Collect contextual topics based on current directory and shell state.
# All checks are shallow — no recursive scans.
_contextual_topics() {
  local -a topics=()
  # Git repo
  [[ -d ".git" || -f ".git" ]] && topics+=("ctx:git")
  # direnv
  [[ -f ".envrc" ]] && topics+=("ctx:envrc")
  # Nix flake
  [[ -f "flake.nix" ]] && topics+=("ctx:flake")
  # Node project
  [[ -f "package.json" ]] && topics+=("ctx:package")
  # Godot project
  [[ -f "project.godot" ]] && topics+=("ctx:godot")
  # dotfiles repo
  [[ -f ".chezmoiroot" ]] && topics+=("ctx:dotfiles")
  # Stream mode
  [[ "${STREAM_MODE:-0}" == "1" ]] && topics+=("ctx:stream")

  printf '%s\n' "${topics[@]}"
}

# Show one tip: contextual if possible, random generic otherwise
terminal_tip() {
  [[ "${TERMINAL_TIPS:-1}" == "0" ]] && return
  [[ ! -f "$_TIPS_FILE" ]] && return

  local -a topics
  mapfile -t topics < <(_contextual_topics)

  if [[ "${#topics[@]}" -gt 0 ]]; then
    # Pick a random contextual topic and show a tip from it
    local topic="${topics[$((RANDOM % ${#topics[@]}))]}"
    _tip_for_topic "$topic" && return
  fi

  # Fallback: random generic tip (exclude ctx: topics)
  local -a lines=()
  while IFS=$'\t' read -r topic text; do
    [[ "$topic" == ctx:* ]] && continue
    lines+=("$text")
  done < "$_TIPS_FILE"
  local count=${#lines[@]}
  [[ "$count" -eq 0 ]] && return
  printf '💡 %s\n' "${lines[$((RANDOM % count))]}"
}

# Search tips by topic: tip <query>
tip() {
  [[ ! -f "$_TIPS_FILE" ]] && { echo "No tips file found at $_TIPS_FILE"; return 1; }
  if [[ -z "${1-}" ]]; then
    while IFS=$'\t' read -r topic text; do
      printf '%-16s %s\n' "[$topic]" "$text"
    done < "$_TIPS_FILE"
  else
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
