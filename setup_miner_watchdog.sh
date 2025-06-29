#!/bin/bash

# Ścieżka do skryptu watchdog
WATCHDOG_PATH="/root/miner_watchdog.sh"
ENV_PATH="/root/.env"
LOG_FILE="/var/log/miner_watchdog.log"

echo "🔧 Rozpoczynanie konfiguracji Miner Watchdog..."

# === 1. Sprawdzenie i instalacja wymaganych pakietów (bez aktualizacji systemu) ===

REQUIRED_PKGS=(cron curl iputils-ping)
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "📦 Instalacja brakującego pakietu: $pkg"
        apt-get install -y "$pkg"
    fi
done

# === 2. Upewnij się, że cron działa ===
systemctl enable cron
systemctl start cron

# === 3. Pobierz dane od użytkownika ===
read -rp "🔌 IP radia Heltec lub LAN (np. router): " RADIO_IP
read -rp "🌐 IP do pingów Internet (np. 8.8.8.8): " INTERNET_IP
read -rp "📦 Nazwa kontenera Docker (domyślnie miner): " CONTAINER_NAME
read -rp "🤖 TOKEN bota Telegrama: " BOT_TOKEN
read -rp "🆔 CHAT_ID Telegrama: " CHAT_ID

# === 4. Zapisz dane do pliku .env ===
cat > "$ENV_PATH" <<EOF
RADIO_IP=$RADIO_IP
INTERNET_IP=$INTERNET_IP
CONTAINER_NAME=$CONTAINER_NAME
BOT_TOKEN=$BOT_TOKEN
CHAT_ID=$CHAT_ID
EOF

chmod 600 "$ENV_PATH"
echo "✅ Utworzono plik .env z ograniczonym dostępem."

# === 5. Upewnij się, że watchdog ma prawa wykonywania ===
chmod +x "$WATCHDOG_PATH"
echo "✅ Nadano +x dla $WATCHDOG_PATH"

# === 6. Przygotowanie logów ===
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"
chown root:root "$LOG_FILE"
echo "✅ Plik logów przygotowany: $LOG_FILE"

# === 7. Ustawienie crona ===
CRON_TEMP=$(mktemp)

cat > "$CRON_TEMP" <<EOF
0 0 * * * tail -n 500 /var/log/miner_watchdog.log > /var/log/miner_watchdog.tmp && mv /var/log/miner_watchdog.tmp /var/log/miner_watchdog.log
* * * * * /bin/bash $WATCHDOG_PATH >> /var/log/miner_watchdog.log 2>&1
EOF

crontab "$CRON_TEMP"
rm -f "$CRON_TEMP"

echo "📅 Ustawiono zadania crontaba:"
crontab -l

echo "✅ Konfiguracja zakończona pomyślnie!"
