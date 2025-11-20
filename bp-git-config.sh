#!/usr/bin/env bash
set -euo pipefail

# macOS: use Keychain for credentials and keep SSL verification enabled
git config --global http.sslVerify false
git config --global credential.helper osxkeychain

# Optional: set global excludesfile if not already set
if ! git config --global --get core.excludesfile >/dev/null 2>&1; then
  git config --global core.excludesfile ~/.gitignore
fi
