#!/bin/sh

BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
CHAT_ID="YOUR_CHAT_ID_HERE"

TITLE="$1"
MESSAGE="$2"
HOSTNAME=$"(hostname -u)"

# Simple message without complex formatting
FULL_MESSAGE="pfSense Alert: $TITLE - $MESSAGE - Time: $(date)"

curl -s -X POST \
  "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${FULL_MESSAGE}" \
  > /dev/null 2>&1

echo "Telegram sent: $TITLE" >> /tmp/telegram-debug.log