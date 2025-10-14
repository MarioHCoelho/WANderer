#!/bin/sh

# Gateway configurations
WAN1_NAME="WAN1_DHCP"
WAN1_IP="192.168.15.1"
WAN2_NAME="WAN2_DHCP"
WAN2_IP="192.168.88.1"

# Check current status with timeout protection
WAN1_STATUS=$(timeout 10 /root/scripts/check-gateway-status.sh "$WAN1_IP" || echo "DOWN")
WAN2_STATUS=$(timeout 10 /root/scripts/check-gateway-status.sh "$WAN2_IP" || echo "DOWN")

# Read previous status
if [ -f /tmp/gateway-status.log ]; then
    OLD_WAN1=$(grep "$WAN1_NAME" /tmp/gateway-status.log | cut -d':' -f2 2>/dev/null || echo "")
    OLD_WAN2=$(grep "$WAN2_NAME" /tmp/gateway-status.log | cut -d':' -f2 2>/dev/null || echo "")
else
    OLD_WAN1=""
    OLD_WAN2=""
fi

# Send alerts if status changed
if [ "$WAN1_STATUS" != "$OLD_WAN1" ]; then
    if [ "$WAN1_STATUS" = "UP" ]; then
        /root/scripts/telegram-notify.sh "Gateway UP" "WAN1_DHCP is now ONLINE - IP: 192.168.15.1"
    else
        /root/scripts/telegram-notify.sh "Gateway DOWN" "WAN1_DHCP is OFFLINE - IP: 192.168.15.1"
    fi
fi

if [ "$WAN2_STATUS" != "$OLD_WAN2" ]; then
    if [ "$WAN2_STATUS" = "UP" ]; then
        /root/scripts/telegram-notify.sh "Gateway UP" "WAN2_DHCP is now ONLINE - IP: 192.168.88.1"
    else
        /root/scripts/telegram-notify.sh "Gateway DOWN" "WAN2_DHCP is OFFLINE - IP: 192.168.88.1"
    fi
fi

# Save current status
echo "$WAN1_NAME:$WAN1_STATUS" > /tmp/gateway-status.log
echo "$WAN2_NAME:$WAN2_STATUS" >> /tmp/gateway-status.log

echo "$(date): Checked - WAN1:$WAN1_STATUS, WAN2:$WAN2_STATUS" >> /tmp/gateway-monitor.log