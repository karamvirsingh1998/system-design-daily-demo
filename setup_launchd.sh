#!/bin/bash
# Setup script to install launchd service (macOS native scheduler)
# This avoids permission prompts that cron jobs trigger

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

PLIST_NAME="com.systemdesign.daily"
PLIST_FILE="${SCRIPT_DIR}/${PLIST_NAME}.plist"
LAUNCHD_DIR="${HOME}/Library/LaunchAgents"
LAUNCHD_FILE="${LAUNCHD_DIR}/${PLIST_NAME}.plist"

echo "=========================================="
echo "Launchd Service Setup (macOS Native)"
echo "=========================================="
echo ""

# Check if plist file exists
if [ ! -f "$PLIST_FILE" ]; then
    echo "❌ Error: $PLIST_FILE not found!"
    exit 1
fi

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCHD_DIR"

# Check if service is already loaded
if launchctl list | grep -q "$PLIST_NAME"; then
    echo "⚠️  Service is already loaded. Unloading first..."
    launchctl unload "$LAUNCHD_FILE" 2>/dev/null || true
fi

# Copy plist to LaunchAgents
echo "📦 Installing service..."
cp "$PLIST_FILE" "$LAUNCHD_FILE"
echo "✅ Service file installed to: $LAUNCHD_FILE"

# Load the service
echo "🚀 Loading service..."
if launchctl load "$LAUNCHD_FILE"; then
    echo "✅ Service loaded successfully!"
else
    echo "❌ Failed to load service"
    exit 1
fi

# Verify it's running
echo ""
echo "📋 Service Status:"
launchctl list | grep "$PLIST_NAME" || echo "   (Service may not show until first run)"

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Service Details:"
echo "  - Name: $PLIST_NAME"
echo "  - Schedule: Daily at 9:00 AM"
echo "  - Logs: $SCRIPT_DIR/daily_run.log"
echo ""
echo "Management Commands:"
echo "  View status:    launchctl list | grep $PLIST_NAME"
echo "  Unload service: launchctl unload $LAUNCHD_FILE"
echo "  Reload service: launchctl unload $LAUNCHD_FILE && launchctl load $LAUNCHD_FILE"
echo "  View logs:      tail -f $SCRIPT_DIR/daily_run.log"
echo ""
echo "To remove the service:"
echo "  launchctl unload $LAUNCHD_FILE"
echo "  rm $LAUNCHD_FILE"
echo ""
