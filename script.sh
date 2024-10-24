#!/bin/bash

# Creare director /opt/cleanup
if [ ! -d "/opt/cleanup" ]; then
  mkdir /opt/cleanup
  echo "Created /opt/cleanup directory"
fi

# Creare fișier auto_cleanup.sh
if [ ! -f "/opt/cleanup/auto_cleanup.sh" ]; then
  cat <<EOL > /opt/cleanup/auto_cleanup.sh
#!/bin/bash

# Directorul pentru fișierele de șters
DIRECTOR="/var/log/journal/840a77eab87d47178f49c58704927e66"

# Șterge fișierele mai vechi de 180 de zile
find "\$DIRECTOR" -type f -mtime +180 -exec rm -f {} \;

echo "Deleted all files older than 180 days"
EOL
  chmod +x /opt/cleanup/auto_cleanup.sh
  echo "Created /opt/cleanup/auto_cleanup.sh script"
fi

# Creare director /tmp/cleanup
if [ ! -d "/tmp/cleanup" ]; then
  mkdir /tmp/cleanup
  echo "Created /tmp/cleanup directory"
fi

# Creare fișier cleanup.log
if [ ! -f "/tmp/cleanup/cleanup.log" ]; then
  touch /tmp/cleanup/cleanup.log
  echo "Created /tmp/cleanup/cleanup.log file"
fi

# Adăugare intrare în crontab
CRON_JOB="0 2 * * * /opt/cleanup/auto_cleanup.sh >> /tmp/cleanup/cleanup.log 2>&1"

# Verificare dacă intrarea există deja în crontab
(crontab -l | grep -q "$CRON_JOB") || (crontab -l; echo "$CRON_JOB") | crontab -

echo "Crontab entry added for cleanup task"
