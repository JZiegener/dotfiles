#!/usr/bin/env bash
#
# format-and-mount.sh
#
#   Format a block device as ext4 and add it to /etc/fstab so that it
#   mounts automatically on every boot.
#
#   Usage:
#       sudo ./format-and-mount.sh [-y] <device> [mountpoint]
#
#   <device>          : /dev/sdX or /dev/nvmeXnY
#   [mountpoint]      : optional, defaults to /mnt/<drivename>-backup
#   -y                : bypass all confirmation prompts
#
#   The script performs a series of safety checks before doing anything.
#   It will exit with a non‑zero status if anything goes wrong.
#
#   Requires: mkfs.ext4, mount, findmnt, grep, sed, etc.
#
#   Author: <your name>
#   Date: <date>
#

set -euo pipefail

# ----------- Configuration ----------------------------------------------
readonly SCRIPT_NAME="$(basename "$0")"
readonly DEFAULT_FSTAB="/etc/fstab"
readonly DEFAULT_MOUNT_POINT_BASE="/mnt"

# ----------- Helper functions -------------------------------------------
usage() {
    cat <<EOF
Usage: sudo ${SCRIPT_NAME} [-y] <device> [mountpoint]

  <device>          : /dev/sdX or /dev/nvmeXnY (must be a block device)
  [mountpoint]      : optional, defaults to ${DEFAULT_MOUNT_POINT_BASE}/<drivename>-backup
  -y                : bypass all confirmation prompts

The script will:
  1. Verify the device exists and is not already mounted.
  2. Verify the device is not listed in ${DEFAULT_FSTAB}.
  3. Format the whole device with ext4.
  4. Create the mount point directory if needed.
  5. Mount the device.
  6. Add an entry to ${DEFAULT_FSTAB} so the device is mounted at boot.
EOF
}

# Ask a yes/no question. Returns 0 for yes, 1 for no.
ask() {
    local prompt="$1"
    while true; do
        read -rp "${prompt} [y/n] " yn
        case "$yn" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer y or n." ;;
        esac
    done
}

# Exit with an error message
die() {
    local msg="$1"
    echo "${SCRIPT_NAME}: ERROR: ${msg}" >&2
    exit 1
}

# ----------- Argument parsing --------------------------------------------
opt_force=0

while getopts ":y" opt; do
    case "$opt" in
        y) opt_force=1 ;;
        \?) die "Invalid option: -$OPTARG" ;;
    esac
done
shift $((OPTIND-1))

# At least one argument (device) required
if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

DEVICE="$1"
shift
MOUNTPOINT="$1"

# ----------- Basic checks -----------------------------------------------
# Must run as root
if [[ $EUID -ne 0 ]]; then
    die "This script must be run as root (use sudo)."
fi

# Verify device exists and is a block device
if ! [[ -b "$DEVICE" ]]; then
    die "Device '$DEVICE' does not exist or is not a block device."
fi

# Get device name (basename)
DEV_NAME="$(basename "$DEVICE")"

# Default mount point if not supplied
if [[ -z "$MOUNTPOINT" ]]; then
    MOUNTPOINT="${DEFAULT_MOUNT_POINT_BASE}/${DEV_NAME}-backup"
fi

# Ensure mountpoint is an absolute path
case "$MOUNTPOINT" in
    /*) ;;
    *) die "Mount point must be an absolute path, not '$MOUNTPOINT'." ;;
esac

# Check device is not already mounted
if findmnt -rn -S "$DEVICE" >/dev/null; then
    die "Device '$DEVICE' is already mounted."
fi

# Check that device is not listed in fstab
if grep -E "^[[:space:]]*${DEVICE}[[:space:]]" "$DEFAULT_FSTAB" >/dev/null; then
    die "Device '$DEVICE' already has an entry in $DEFAULT_FSTAB."
fi

# Warn user about formatting (data loss)
echo "You are about to format the entire device '$DEVICE' with ext4."
echo "All data on the device will be permanently lost."
if [[ $opt_force -ne 1 ]]; then
    if ! ask "Are you absolutely sure?"; then
        die "User aborted."
    fi
fi

# ----------- Formatting -----------------------------------------------
echo "Formatting $DEVICE as ext4..."
# -F forces overwrite of existing filesystem
# -L sets the filesystem label
mkfs.ext4 -F -L "backup-${DEV_NAME}" "$DEVICE" || die "mkfs failed."

# ----------- Mount point preparation ------------------------------------
if [[ ! -d "$MOUNTPOINT" ]]; then
    echo "Creating mount point directory '$MOUNTPOINT'..."
    mkdir -p "$MOUNTPOINT" || die "Failed to create mount point."
fi

# ----------- Temporary mount --------------------------------------------
echo "Mounting $DEVICE to $MOUNTPOINT ..."
mount "$DEVICE" "$MOUNTPOINT" || die "Mount failed."

# ----------- fstab entry -----------------------------------------------
echo "Adding entry to $DEFAULT_FSTAB ..."
# Use 'sed' to avoid duplicate entries and maintain file order
# We'll append at the end, but first check again to be safe
if ! grep -E "^[[:space:]]*${DEVICE}[[:space:]]" "$DEFAULT_FSTAB" >/dev/null; then
    # Escape slashes for echo
    printf '%s\n' "${DEVICE} ${MOUNTPOINT} ext4 defaults 0 2" >> "$DEFAULT_FSTAB" \
        || die "Failed to write to $DEFAULT_FSTAB."
else
    echo "Warning: fstab entry already exists (skipping)."
fi

echo "Successfully formatted and mounted $DEVICE at $MOUNTPOINT."
echo "This device will now mount automatically at boot."

exit 0
