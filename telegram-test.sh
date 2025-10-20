#!/bin/sh

# Simple Telegram Test
BOT_TOKEN="7486821705:AAHvGPpMbuM5MxxK5ya9G13oCBTnOdIlkCg"
CHAT_ID="-4852490091"
GATEWAY_UP="Gateway UP 🟢"
GATEWAY_DOWN="Gateway DOWN 🔴"

MESSAGE="✅ pfSense Test Notification
This is a test message from pfSense
Time: $(date '+%Y-%m-%d %H:%M:%S')
If you see this, Telegram is working!"

curl -s -X POST \
  "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d text="${MESSAGE}" \
  > /dev/null 2>&1

echo "Test message sent to Telegram!"