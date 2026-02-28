#!/data/data/com.termux/files/usr/bin/bash
#
# ADB Install Script - Install APK on Android device
#
# Usage: ./install.sh [apk_path] [device_ip] [device_port]
#

set -e

APK_PATH="${1:-$HOME/SquareApp-debug.apk}"
DEVICE_IP="${2:-}"
DEVICE_PORT="${3:-5555}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    log_error "APK not found: $APK_PATH"
    exit 1
fi

# Check ADB
command -v adb >/dev/null 2>&1 || { log_error "adb not found. Install: pkg install android-tools"; exit 1; }

log_info "=== ADB Install Script ==="
log_info "APK: $APK_PATH"

# If IP provided, try wireless connect
if [ -n "$DEVICE_IP" ]; then
    log_info "Connecting to $DEVICE_IP:$DEVICE_PORT..."
    adb connect "$DEVICE_IP:$DEVICE_PORT" || log_warn "Connection failed, trying anyway..."
fi

# Show connected devices
log_info "Connected devices:"
adb devices

# Install
log_info "Installing APK..."
adb install -r "$APK_PATH" && log_info "Installation complete!" || {
    log_error "Installation failed"
    log_info "Fallback: Copy to Downloads for manual install"
    if [ -d ~/storage/downloads ]; then
        cp "$APK_PATH" ~/storage/downloads/
        log_info "APK copied to ~/storage/downloads/"
    fi
}
