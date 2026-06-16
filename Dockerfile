FROM openresty/openresty:alpine

RUN apk add --no-cache ca-certificates wget unzip netcat-openbsd

RUN wget -qO /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.5.9/Xray-linux-64.zip && \
    unzip -p /tmp/xray.zip xray > /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && rm -rf /tmp/xray.zip

COPY config.json /etc/xray.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
    CMD curl -f http://localhost:8080/health || exit 1

# Use shell form to prevent signal issues
CMD /usr/local/bin/xray run -c /etc/xray.json 2>&1 & \
    echo "Waiting for Xray..." && \
    while ! nc -z 127.0.0.1 10000; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10001; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10002; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10003; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10004; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10005; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10006; do sleep 1; done && \
    while ! nc -z 127.0.0.1 10007; do sleep 1; done && \
    echo "Xray ready. Starting OpenResty..." && \
    /usr/local/openresty/bin/openresty -g 'daemon off;'
