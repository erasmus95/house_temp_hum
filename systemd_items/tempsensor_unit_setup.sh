#!/bin/bash

# Create the timer unit
cat <<EOF > /etc/systemd/system/tempsensor.timer
[Unit]
Description=Run my script every 5 minutes

[Timer]
OnCalendar=*:0/5

[Install]
WantedBy=timers.target
EOF

# Create the service unit
cat <<EOF > /etc/systemd/system/tempsensor.service
[Unit]
Description=Run the tempsensor

[Service]
User=pi
WorkingDirectory=/home/pi/GitHub/tempsensors/
ExecStart=sudo python3 /home/pi/GitHub/tempsensors/tempsensor.py

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=autodeploy

[Install]
WantedBy=multi-user.target
EOF

# Change the permissions of the service unit to 644
chmod 644 /etc/systemd/system/tempsensor.service

# Reload the systemd daemon
sudo systemctl daemon-reload
sudo systemctl enable tempsensor.timer

# Prompt for a reboot
echo "Systemd timer and service created. Do you want to reboot now? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  reboot
fi
