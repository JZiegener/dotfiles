#!/usr/bin/env bash
# wireguard-setup.sh
#  • Runs on Debian/Ubuntu
#  • Creates key pair if absent, prints keys
#  • Prompts for B's public key
#  • Generates /etc/wireguard/wg0.conf
#  • Brings up wg0
set -euo pipefail

# ----- install wireguard-tools if needed -----
if ! command -v wg >/dev/null 2>&1; then
    echo "Installing wireguard-tools ..."
    apt-get update
    apt-get install -y wireguard-tools
fi

# ----- key directory and files -----
KEYDIR="~./wireguard"
mkdir -p "$KEYDIR"
chmod 700 "$KEYDIR"
PRIVKEY="$KEYDIR/privatekey"
PUBKEY="$KEYDIR/publickey"

# ----- generate keys only if they don't exist -----
if [ ! -f "$PRIVKEY" ]; then
    wg genkey | tee "$PRIVKEY" | wg pubkey > "$PUBKEY"
    chmod 600 "$PRIVKEY"
    chmod 644 "$PUBKEY"
    echo "Generated key pair."
fi

# ----- print keys -----
echo "===== YOUR KEYS ====="
echo "Public key:"
cat "$PUBKEY"
echo
echo "Private key (keep secret):"
cat "$PRIVKEY"
echo "====================="

# ----- prompt for peer info -----
read -rp "Enter Remote's public key: " PEER_PUB
read -rp "Enter your local WireGuard IP (e.g. 10.0.0.1/24): " MY_IP
read -rp "Enter Remote's endpoint IP or hostname (e.g. 10.0.0.2): " PEER_ENDPOINT

# ----- write wg0.conf -----
cat > "$KEYDIR/wg0.conf" <<EOF
[Interface]
PrivateKey = $(<"$PRIVKEY")
Address = $MY_IP
ListenPort = 51820

[Peer]
PublicKey = $PEER_PUB
Endpoint = $PEER_ENDPOINT:51820
AllowedIPs = 10.0.0.2/32
PersistentKeepalive = 25
EOF

# ----- bring up the interface -----
systemctl restart wg-quick@wg0
echo "wg0 is up. Use 'wg' to verify."
