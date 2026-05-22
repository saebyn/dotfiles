# Navigation helpers: zoxide, fzf project picker
# See issue #4 (Add zoxide and fzf-based project navigation helpers)

# zoxide — smarter cd with frecency tracking
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# repos — fzf picker for projects under ~/Documents/MyRepos
repos() {
  local dir
  dir=$(find ~/Documents/MyRepos -mindepth 1 -maxdepth 1 -type d | sort | fzf --prompt="repo> ")
  [[ -n "$dir" ]] && cd "$dir"
}
