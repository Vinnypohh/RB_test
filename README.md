1. Descriere
Acest script automatizează procesul de ștergere a fișierelor mai vechi de 180 de zile dintr-un anumit director (în acest caz, /var/log/journal/840a77eab87d47178f49c58704927e66) și setează un job în crontab pentru a rula zilnic la ora 2:00 AM.

2. Pași de instalare și configurare
a) Creează și configurează scriptul de automatizare
Deschide terminalul și creează un nou fișier pentru scriptul de configurare:
touch script.sh
Adaugă următorul conținut în fișier:

!/bin/bash
Creare director /opt/cleanup
if [ ! -d "/opt/cleanup" ]; then
mkdir /opt/cleanup
echo "Created /opt/cleanup directory"
fi
Creare fișier auto_cleanup.sh
if [ ! -f "/opt/cleanup/auto_cleanup.sh" ]; then
cat < /opt/cleanup/auto_cleanup.sh
!/bin/bash
Directorul pentru fișierele de șters
DIRECTOR="/var/log/journal/840a77eab87d47178f49c58704927e66"
Șterge fișierele mai vechi de 180 de zile
find "\$DIRECTOR" -type f -mtime +180 -exec rm -f {} \;
echo "Deleted all files older than 180 days"
EOL
chmod +x /opt/cleanup/auto_cleanup.sh
echo "Created /opt/cleanup/auto_cleanup.sh script"
fi
Creare director /tmp/cleanup
if [ ! -d "/tmp/cleanup" ]; then
mkdir /tmp/cleanup
echo "Created /tmp/cleanup directory"
fi
Creare fișier cleanup.log
if [ ! -f "/tmp/cleanup/cleanup.log" ]; then
touch /tmp/cleanup/cleanup.log
echo "Created /tmp/cleanup/cleanup.log file"
fi
Adăugare intrare în crontab
CRON_JOB="0 2 * * * /opt/cleanup/auto_cleanup.sh >> /tmp/cleanup/cleanup.log 2>&1"
Verificare dacă intrarea există deja în crontab
(crontab -l | grep -q "$CRON_JOB") || (crontab -l; echo "$CRON_JOB") | crontab -
echo "Crontab entry added for cleanup task"
b) Facem scriptul executabil
chmod +x script.sh
c) Rularea scriptului
sh script.sh

d) Verificarea și monitorizarea
Fișierul de log: Toate acțiunile efectuate de scriptul de cleanup sunt salvate în fișierul /tmp/cleanup/cleanup.log. Verifică acest fișier pentru a te asigura că scriptul rulează corect.

3) Verificarea și monitorizarea
ișierul de log: Toate acțiunile efectuate de scriptul de cleanup sunt salvate în fișierul /tmp/cleanup/cleanup.log. Verifică acest fișier pentru a te asigura că scriptul rulează corect.

Crontab: Verifică dacă intrarea a fost adăugată corect în crontab rulând:
crontab -l
Trebuie sa vezi ceva de gen dat

“0 2 * * * /opt/cleanup/auto_cleanup.sh >> /tmp/cleanup/cleanup.log 2>&1”
