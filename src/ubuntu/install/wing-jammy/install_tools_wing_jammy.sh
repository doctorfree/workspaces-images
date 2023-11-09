#!/usr/bin/env bash

apt-get update
apt-get install -y jq
apt-get install -y fzf

# Remove the GPG keyring file associated with the old repository
rm -f /etc/apt/keyrings/nodesource.gpg
# Remove the old repository's list file
rm -f /etc/apt/sources.list.d/nodesource.list

# Define the desired Node.js major version
# Currently supported major versions:
# NODE_MAJOR=16
# NODE_MAJOR=18
# NODE_MAJOR=20
# NODE_MAJOR=21
NODE_MAJOR=20

# Update local package index
apt-get update
# Install necessary packages for downloading and verifying new repository information
apt-get install -y ca-certificates curl gnupg
# Create a directory for the new repository's keyring, if it doesn't exist
mkdir -p /etc/apt/keyrings
# Download the new repository's GPG key and save it in the keyring directory
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
  gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
# Add the new repository's source list with its GPG key for package verification
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Update local package index to recognize the new repository
sudo apt-get update
# Install Node.js from the new repository
sudo apt-get install -y nodejs

have_npm=$(type -p npm)
[ "${have_npm}" ] && npm install -g winglang