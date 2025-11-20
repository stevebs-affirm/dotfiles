#!/usr/bin/env bash
set -euo pipefail

sym() {
  local dotdir="$1"
  # Symlink any *.symlink files to ~/.<name without .symlink>
  while IFS= read -r -d '' filename; do
    local dest="$HOME/.${filename##*/}"
    dest="${dest%.symlink}"
    ln -sf "$filename" "$dest"
    echo "Linked $filename -> $dest"
  done < <(find "$dotdir" -name "*.symlink" -print0)
}

dotfs="$(cd "$(dirname "$0")" && pwd)"

# Create symlinks
sym "$dotfs"

# Ensure ~/.zshrc sources ~/.zshrc.local (idempotent)
ZSHRC="$HOME/.zshrc"
SRC_LINE='[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local'
touch "$ZSHRC"
if ! grep -Fq "$SRC_LINE" "$ZSHRC"; then
  printf '\n%s\n' "$SRC_LINE" >> "$ZSHRC"
  echo "Added source line to $ZSHRC"
fi

echo "Done. Open a new terminal or 'exec zsh' to load aliases."
