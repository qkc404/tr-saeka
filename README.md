# Trojan-Go WebSocket TLS - Google Cloud Run

Automated Trojan-Go deployment with Nginx reverse proxy and TLS termination on Google Cloud Run.

## Features

🔐 **Trojan-Go Protocol** - Ultra-fast, reliable tunneling  
🌐 **WebSocket Support** - ws:// over TLS  
🎭 **Decoy Website** - masquerade as legitimate domain  
⚡ **Ultra-fast** - OpenResty + Trojan-Go  
🚀 **Cloud Run Ready** - fully containerized, auto-scaling  
✨ **Smart Routing** - Health checks + fallback handling  

## Quick Start

### Prerequisites

```bash
# Install Google Cloud SDK
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Deploy

```bash
chmod +x deploy.sh
./deploy.sh
```

The script will:
1. Verify GCP authentication and APIs
2. Prompt for region and configuration
3. Build Docker image with Cloud Build
4. Deploy to Cloud Run
5. Output connection details

## Configuration

### During Deployment

- **Region**: Choose from 5 global regions
- **Service Name**: Unique identifier (auto-sanitized)
- **Password**: Auto-generated or custom
- **CPU/Memory**: 1 vCPU/512Mi to 2 vCPU/4Gi

### Output Example

```
Address:    trojan-go-abcd.run.app
Port:       443
Password:   GeneratedPassword123
Path:       /saeka-tojirp
Protocol:   Trojan-Go
Transport:  WebSocket (WS)
Security:   TLS (Auto)
Region:     us-central1

Trojan URI:
trojan://GeneratedPassword123@trojan-go-abcd.run.app:443
```

## File Structure

- **Dockerfile** - Multi-stage build with Trojan-Go and OpenResty
- **nginx.conf** - Reverse proxy, WebSocket, decoy routing
- **trojan-go-config.json** - Trojan protocol configuration
- **entrypoint.sh** - Container startup script with dynamic port
- **deploy.sh** - GCP deployment automation

## Architecture

```
Client (Trojan)
   ↓ (TLS/WS)
Cloud Run Service (Port 8080)
   ↓
Nginx (Reverse Proxy)
   ├→ /saeka-tojirp → Trojan-Go (Port 4433) → Freedom Outbound
   ├→ /health → Health Check Response
   └→ / → smart.com.ph (Decoy)
```

## Client Configuration

### On Trojan-Go / Clash

```yaml
proxies:
  - name: Trojan-WS-TLS
    type: trojan
    server: cloud-run-domain.run.app
    port: 443
    password: YOUR_PASSWORD
    sni: cloud-run-domain.run.app
    skip-cert-verify: false
    network: ws
    ws-opts:
      path: /saeka-tojirp
```

## Troubleshooting

### Build Failed
- Check Cloud Build API is enabled
- Verify Dockerfile syntax

### Connection Issues
- Ensure health check passes: `curl https://SERVICE_URL/health`
- Check Cloud Run logs: `gcloud run services logs SERVICE_NAME`
- Verify password in config

### High Latency
- Select region closest to your location
- Increase CPU/Memory allocation

## Security Notes

⚠️ **Important**: This is for educational purposes only.

- Change default password to something strong
- Use legitimate decoy domains
- Monitor Cloud Run logs for suspicious activity
- Comply with local laws and regulations

## License

MIT
