#bin/Bash
set -e
rm -rf /usr/local/go 
wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
rm go1.21.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin