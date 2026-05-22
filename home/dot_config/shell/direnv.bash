# direnv shell hook — loaded only if direnv is installed
# See issue #7 (Add CLI quality-of-life package set)
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
