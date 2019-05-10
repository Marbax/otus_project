#!/bin/bash
apt-get update && apt-get upgrade -y 
#apt-get install docker -y
apt-get install docker-compose -y
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
usermod -aG docker appuser

# Add systemd-unit for logging
cat <<EOF > /etc/systemd/system/crawler-logging.service
[Unit]
Description=Crawler logging Server
After=network.target
[Service]
Type=simple
User=appuser
Group=appuser
WorkingDirectory=/home/appuser/
ExecStart=/home/appuser/run-logging.sh
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

# Add systemd-unit for monitoring
cat <<EOT > /etc/systemd/system/crawler-monitoring.service
[Unit]
Description=Crawler monitoring Server
After=network.target
[Service]
Type=simple
User=appuser
Group=appuser
WorkingDirectory=/home/appuser/
ExecStart=/home/appuser/run-monitoring.sh
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOT

# Add systemd-unit for crawler-app
cat <<EOS > /etc/systemd/system/crawler-app.service
[Unit]
Description=Crawler app Server
After=network.target
After=crawler-logging.service
[Service]
Type=simple
User=appuser
Group=appuser
WorkingDirectory=/home/appuser/
ExecStart=/home/appuser/run-app.sh
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOS

# Add systemd-unit for gitlab
cat <<EOG > /etc/systemd/system/gitlab.service
[Unit]
Description=gitlab Server
After=network.target
[Service]
Type=simple
User=appuser
Group=appuser
WorkingDirectory=/home/appuser/
ExecStart=/home/appuser/run-gitlab.sh
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOG

systemctl enable crawler-logging.service
systemctl enable crawler-monitoring.service
systemctl enable crawler-app.service
systemctl enable gitlab.service

su appuser
cd /home/appuser
docker-compose -f docker-compose-logging.yml up -d
docker-compose -f docker-compose-monitoring.yml up -d
docker-compose -f docker-compose.yml up -d
docker-compose -f docker-compose-gitlab.yml up -d

