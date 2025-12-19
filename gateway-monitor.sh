#!/bin/sh

# --- INFORMAÇÕES DO GATEWAY ---
# Nomes dos Gateways (Exatamente como em System -> Routing -> Gateways)
WAN1_NAME="WAN1_DHCP"
WAN1_OPERATOR="Vivo"
# Nome da Interface Física/Lógica (Ex: pppoe0, em0, igb1)
WAN1_IF_NAME="pppoe1" # <--- PREENCHA AQUI (Ex: pppoe0)

# Nomes dos Gateways
WAN2_NAME="WAN2_DHCP"
WAN2_OPERATOR="Claro"
# Nome da Interface Física/Lógica
WAN2_IF_NAME="igc3"    # <--- PREENCHA AQUI (Ex: igb1 ou em1)

# --- LÓGICA DE VERIFICAÇÃO NATIVA DO PFSENSE (VERSÃO CORRIGIDA) ---
GW_STATUS_OUTPUT=$(/usr/local/sbin/pfSsh.php playback gatewaystatus)

# Verifica o status (usando grep duplo para mais confiabilidade)
if echo "$GW_STATUS_OUTPUT" | grep "$WAN1_NAME" | grep -q "online"; then
    WAN1_STATUS="UP"
else
    WAN1_STATUS="DOWN"
fi

if echo "$GW_STATUS_OUTPUT" | grep "$WAN2_NAME" | grep -q "online"; then
    WAN2_STATUS="UP"
else
    WAN2_STATUS="DOWN"
fi
# --- O RESTO DO SEU SCRIPT (LOGS E ALERTAS) CONTINUA IGUAL ---

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
    # Pega o IP atual da interface SÓ para a notificação
    CURRENT_IP=$(ifconfig $WAN1_IF_NAME | grep 'inet ' | awk '{print $2}')
    
    if [ "$WAN1_STATUS" = "UP" ]; then
        /root/scripts/telegram-notify.sh "WAN1 Subiu" "O link $WAN1_NAME ($WAN1_OPERATOR) está ONLINE. 
IP: $CURRENT_IP"
    else
        /root/scripts/telegram-notify.sh "WAN1 Caiu" "O link $WAN1_NAME ($WAN1_OPERATOR) está OFFLINE."
    fi
fi

if [ "$WAN2_STATUS" != "$OLD_WAN2" ]; then
    # Pega o IP atual da interface SÓ para a notificação
    CURRENT_IP=$(ifconfig $WAN2_IF_NAME | grep 'inet ' | awk '{print $2}')

    if [ "$WAN2_STATUS" = "UP" ]; then
        /root/scripts/telegram-notify.sh "WAN2 Subiu" "O link $WAN2_NAME ($WAN2_OPERATOR) está ONLINE. 
IP: $CURRENT_IP"
    else
        /root/scripts/telegram-notify.sh "WAN2 Caiu" "O link $WAN2_NAME ($WAN2_OPERATOR) está OFFLINE."
    fi
fi

# Save current status
echo "$WAN1_NAME:$WAN1_STATUS" > /tmp/gateway-status.log
echo "$WAN2_NAME:$WAN2_STATUS" >> /tmp/gateway-status.log

echo "$(date): Checked - WAN1:$WAN1_STATUS, WAN2:$WAN2_STATUS" >> /tmp/gateway-monitor.log