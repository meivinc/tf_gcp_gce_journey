#!/bin/bash
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install


# Configure the Ops Agent.
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
logging:
  receivers:
    syslog:
      type: files
      include_paths:
      - /var/log/messages
      - /var/log/syslog
  service:
    pipelines:
      default_pipeline:
        receivers: [syslog]
metrics:
  receivers:
    hostmetrics:
      type: hostmetrics
      collection_interval: 60s
  processors:
    metrics_filter:
      type: exclude_metrics
      metrics_pattern: []
  service:
    pipelines:
      default_pipeline:
        receivers: [hostmetrics]
        processors: [metrics_filter]
EOF

sudo service google-cloud-ops-agent restart
sleep 60


# Function to log messages
log() {
  logger -s -t "startup-script" "$1"
}

# Install NGINX
log "Installing NGINX..."
apt-get update
apt-get install -y nginx jq stress

# Write GCE metadata to the NGINX default HTML file
log "Writing GCE metadata to index.html..."
NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

cat <<EOF > /var/www/html/index.html
<pre>
Name: $NAME
IP: $IP
Metadata: $METADATA
</pre>
EOF
touch /var/www/html/healthz

# Restart NGINX to apply changes
log "Restarting NGINX..."
systemctl restart nginx

log "Startup script completed."
