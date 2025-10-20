#!/bin/sh

# Manual Gateway Test Script
# Usage: /root/scripts/test-gateway-manual.sh [gateway]
# Example: /root/scripts/test-gateway-manual.sh wan1

GATEWAY="${1:-all}"

case "$GATEWAY" in
    "wan1")
        /root/scripts/telegram-notify.sh "Manual Test" "🧪 Manual test of WAN1_DHCP\nIP: 192.168.15.1"
        ;;
    "wan2") 
        /root/scripts/telegram-notify.sh "Manual Test" "🧪 Manual test of WAN2_DHCP\nIP: 192.168.88.1"
        ;;
    "all"|*)
        /root/scripts/telegram-notify.sh "Manual Test" "🧪 Manual test of ALL gateways"
        /root/scripts/gateway-monitor.sh
        ;;
esac

echo "Manual test completed for: $GATEWAY"