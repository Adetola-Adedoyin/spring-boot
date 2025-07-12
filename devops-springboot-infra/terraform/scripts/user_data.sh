#!/bin/bash

# Update system packages
apt update -y
apt upgrade -y

# Install Docker
apt install -y docker.io
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -a -G docker ubuntu

# Install Java 11
apt install -y openjdk-11-jdk

# Install Maven
apt install -y maven

# -----------------------------------------
# Install Prometheus
# -----------------------------------------
# Create user
useradd --no-create-home --shell /bin/false prometheus

# Create directories
mkdir -p /etc/prometheus /var/lib/prometheus
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/prometheus-2.51.2.linux-amd64.tar.gz
tar xvf prometheus-2.51.2.linux-amd64.tar.gz
cd prometheus-2.51.2.linux-amd64

# Copy binaries and configs
cp prometheus promtool /usr/local/bin/
cp -r consoles console_libraries /etc/prometheus

# Create config file
cat > /etc/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'springboot-app'
    static_configs:
      - targets: ['localhost:8080']
EOF

# Permissions
chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Systemd service
cat > /etc/systemd/system/prometheus.service << 'EOF'
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start Prometheus
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# Install Grafana
apt-get install -y software-properties-common
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
apt-get update
apt-get install -y grafana

# Start Grafana
systemctl enable grafana-server
systemctl start grafana-server

# Firewall Rules already handled by SG (Terraform)


# Install Git
apt install -y git

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y unzip
unzip awscliv2.zip
./aws/install

# Create application directory
mkdir -p /opt/app
chown ubuntu:ubuntu /opt/app

# Create a simple health check endpoint
cat > /opt/app/health.sh << 'EOF'
#!/bin/bash
echo "Health check endpoint - $(date)"
EOF
chmod +x /opt/app/health.sh

# Create systemd service for Spring Boot app (template)
cat > /etc/systemd/system/springboot-app.service << 'EOF'
[Unit]
Description=Spring Boot Application
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=ubuntu
ExecStart=/usr/bin/docker run --rm --name springboot-app -p 8080:8080 springboot-app:latest
ExecStop=/usr/bin/docker stop springboot-app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable the service (but don't start it yet - will be started by CI/CD)
systemctl daemon-reload
systemctl enable springboot-app.service

# Create log directory
mkdir -p /var/log/springboot
chown ubuntu:ubuntu /var/log/springboot

# Signal that user data script is complete
echo "User data script completed at $(date)" > /var/log/user-data.log