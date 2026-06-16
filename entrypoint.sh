#!/bin/sh

echo "[$(date)] Starting Xray..."
/usr/local/bin/xray run -c /etc/xray/config.json 2>&1 &

echo "[$(date)] Waiting for Xray to initialize..."
sleep 5

echo "[$(date)] Starting Nginx..."
exec /usr/local/openresty/bin/openresty -g 'daemon off;'
