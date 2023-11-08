#!/usr/bin/env bash

apt-get update
apt-get install -y apt-utils
apt-get install -y jq
apt-get install -y fzf
apt-get install -y ripgrep
apt-get install -y bat
apt-get install -y lsd
apt-get install -y figlet
apt-get install -y lolcat
apt-get install -y libnotify-bin
apt-get install -y xclip
apt-get install -y xsel
apt-get install -y python3
apt-get install -y python3-venv
apt-get install -y ruby
apt-get install -y ruby-dev
apt-get install -y wl-clipboard

# Currently supported major versions:
# NODE_MAJOR=16
# NODE_MAJOR=18
# NODE_MAJOR=20
# NODE_MAJOR=21
NODE_MAJOR=20

# Setup keyring if not already performed
[ -f /etc/apt/keyrings/nodesource.gpg ] || {
  apt-get update
  apt-get install -y ca-certificates curl gnupg
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
      gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
}

[ -f /etc/apt/sources.list.d/nodesource.list ] || {
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \
      tee /etc/apt/sources.list.d/nodesource.list
}

apt-get update
apt-get install nodejs -y

have_npm=$(type -p npm)
[ "${have_npm}" ] && npm install -g winglang
have_code=$(type -p code)
[ "${have_code}" ] && code --install-extension Monada.vscode-wing