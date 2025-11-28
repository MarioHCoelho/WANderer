#!/bin/sh

BOT_TOKEN="telegram_bot_api"
CHAT_ID="-telegram_chat_id"

TITLE="$1"
MESSAGE="$2"
HOSTNAME=$(hostname -f)
DATA_ATUAL=$(date '+%d/%m/%Y')
HORA_ATUAL=$(date '+%H:%M:%S')

# Simple message without complex formatting
FULL_MESSAGE="Alerta Gateway ✅🚨
$HOSTNAME  
$TITLE
$MESSAGE
Data: $DATA_ATUAL
Hora: $HORA_ATUAL"


curl -s -X POST \
  "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${FULL_MESSAGE}" \
  > /dev/null 2>&1

echo "Telegram sent: $TITLE" >> /tmp/telegram-debug.log