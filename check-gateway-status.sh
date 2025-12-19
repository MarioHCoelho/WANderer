
#!/bin/sh

GATEWAY_IP="$1"

# Use ping with proper error handling
if ping -c 2 -W 3 "$GATEWAY_IP" > /dev/null 2>&1; then
    echo "UP"
else
    echo "DOWN"
fi

# Always return success exit code
exit 0