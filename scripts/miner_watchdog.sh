#!/bin/bash

# Wczytaj zmienne z pliku .env
ENV_PATH="$(dirname "$0")/.env"
if [ -f "$ENV_PATH" ]; then
    export $(grep -v '^#' "$ENV_PATH" | xargs)
else
    echo "Brak pliku .env w $ENV_PATH"
    exit 1
fi

# Konfiguracja
CONTAINER="$CONTAINER_NAME"
RADIO_IP="$RADIO_IP"
INTERNET_IP="$INTERNET_IP"
LOG="/var/log/miner_watchdog.log"
STATE_DIR="/var/lib/miner_watchdog"
RETRY_FILE="$STATE_DIR/retries"
STATE_FILE="$STATE_DIR/state"
PAUSE_FILE="$STATE_DIR/pause_until"
RETRIES_COUNT_FILE="$STATE_DIR/retries_count"
MAX_RETRIES=3

BOT_TOKEN="$BOT_TOKEN"
CHAT_ID="$CHAT_ID"

mkdir -p "$STATE_DIR"

get_system_info() {
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%
    RAM=$(free | awk '/Mem:/ { printf("%.1f%%", $3/$2 * 100.0) }')

    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp)
        TEMP=$(awk "BEGIN {printf \"%.1f°C\", $TEMP_RAW/1000}")
    else
        TEMP="? "
    fi

    DISK=$(df / | awk 'END { print $(NF-1) }')
    echo -e "CPU: $CPU\nRAM: $RAM\nTemp: $TEMP\nDysk: $DISK"
}

send_telegram() {
    local MESSAGE="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
         -d chat_id="$CHAT_ID" \
         -d text="$MESSAGE" \
         -d parse_mode="Markdown" > /dev/null
}

INFO_MESSAGE=$(cat <<EOF
📡 Sprawdzam stan radia: \`$RADIO_IP\`  
🌐 Sprawdzam połączenie internetowe: \`$INTERNET_IP\`  
🛠️ Przy problemach wykonuję kolejno:
   1️⃣ Restart kontenera *$CONTAINER*  
   2️⃣ Restart interfejsów sieciowych i usług (eth0, wlan0, connman, NetworkManager)  
   3️⃣ Reboot systemu  

⏸️ Po 3 nieudanych próbach pauza rośnie wykładniczo:  
30 min → 1h → 2h → 4h → 8h → 16h → 24h  
EOF
)

if [ ! -f "$STATE_FILE" ]; then
    SYSINFO="$(get_system_info)"
    INTRO_MSG=$(cat <<EOF
🚀 *Miner Watchdog uruchomiony* 🚀
━━━━━━━━━━━━━━━━━━━━━━━
$INFO_MESSAGE

🔄 Połączenie odzyskane — licznik prób i pauz wraca do zera.  
📩 Wszystkie ważne akcje i zmiany stanu są raportowane na Telegram.

📊 *Status systemu*:
$SYSINFO
EOF
)
    send_telegram "$INTRO_MSG"
fi

NOW=$(date +%s)
PAUSE_UNTIL=$(cat "$PAUSE_FILE" 2>/dev/null || echo 0)

# Pingowanie
ping -c 1 -W 1 "$RADIO_IP" > /dev/null && RADIO_OK=1 || RADIO_OK=0
ping -c 1 -W 1 "$INTERNET_IP" > /dev/null && INTERNET_OK=1 || INTERNET_OK=0

CURRENT_STATE="${RADIO_OK}${INTERNET_OK}"
PREV_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "")

# Reset pauzy, jeśli połączenie wróciło
if [ "$NOW" -lt "$PAUSE_UNTIL" ]; then
    if [ "$CURRENT_STATE" = "11" ]; then
        echo "$(date): ✅ Połączenie odzyskane w czasie pauzy. Resetuję pauzę." >> "$LOG"
        SYSINFO="$(get_system_info)"
        MESSAGE=$(cat <<EOF
✅ *Miner Watchdog* — Połączenie odzyskane (w czasie pauzy)
━━━━━━━━━━━━━━━━━━━━
📡 Radio: ✅ Tak  
🌐 Internet: ✅ Tak

🛑 Pauza została przerwana i wyzerowana.

$INFO_MESSAGE

📊 *Status systemu*:
$SYSINFO
EOF
)
        send_telegram "$MESSAGE"
        echo 0 > "$RETRY_FILE"
        echo 0 > "$RETRIES_COUNT_FILE"
        echo 0 > "$PAUSE_FILE"
        echo "$CURRENT_STATE" > "$STATE_FILE"
    else
        echo "$(date): 🕒 Wstrzymane do $(date -d @$PAUSE_UNTIL), ale nadal brak połączenia." >> "$LOG"
    fi
    exit 0
fi

if [ "$CURRENT_STATE" = "11" ]; then
    echo "$(date): ✅ Radio i internet działają" >> "$LOG"
    if [ "$PREV_STATE" != "11" ]; then
        SYSINFO="$(get_system_info)"
        MESSAGE=$(cat <<EOF
✅ *Miner Watchdog* — Połączenie przywrócone
━━━━━━━━━━━━━━━━━━━━
📡 Radio: ✅ Tak
🌐 Internet: ✅ Tak

$INFO_MESSAGE

📊 *Status systemu*:
$SYSINFO
EOF
        )
        send_telegram "$MESSAGE"
        echo 0 > "$RETRY_FILE"
        echo 0 > "$RETRIES_COUNT_FILE"
        echo 0 > "$PAUSE_FILE"
    fi
    echo "$CURRENT_STATE" > "$STATE_FILE"
    exit 0
fi

echo "$(date): ❌ Problem. Radio: $RADIO_OK, Internet: $INTERNET_OK" >> "$LOG"
RETRIES=$(cat "$RETRY_FILE" 2>/dev/null || echo 0)
RETRIES=$((RETRIES + 1))
echo "$RETRIES" > "$RETRY_FILE"

RADIO_STATUS=$([ "$RADIO_OK" -eq 1 ] && echo "✅ Tak" || echo "❌ Nie")
INTERNET_STATUS=$([ "$INTERNET_OK" -eq 1 ] && echo "✅ Tak" || echo "❌ Nie")
SYSINFO="$(get_system_info)"

if [ "$RETRIES" -eq 1 ]; then
    echo "$(date): 🔁 Próba 1 — restart kontenera" >> "$LOG"
    send_telegram "$(cat <<EOF
⚙️ *Miner Watchdog* — Restart kontenera
━━━━━━━━━━━━━━━━━━━━
📡 Radio: $RADIO_STATUS
🌐 Internet: $INTERNET_STATUS

🔄 Restartuję kontener: *$CONTAINER*

📊 *Status systemu*:
$SYSINFO
EOF
)"
    docker restart "$CONTAINER" >> "$LOG" 2>&1

elif [ "$RETRIES" -eq 2 ]; then
    echo "$(date): 🔁 Próba 2 — restart interfejsów" >> "$LOG"
    send_telegram "$(cat <<EOF
♻️ *Miner Watchdog* — Restart sieci
━━━━━━━━━━━━━━━━━━━━
📡 Radio: $RADIO_STATUS
🌐 Internet: $INTERNET_STATUS

🔌 Restartuję interfejsy eth0/wlan0 i usługi

📊 *Status systemu*:
$SYSINFO
EOF
)"
    ip link set eth0 down || true
    ip link set wlan0 down || true
    sleep 3
    ip link set eth0 up || true
    ip link set wlan0 up || true
    systemctl restart connman.service || true
    if systemctl list-unit-files | grep -q '^NetworkManager.service'; then
        systemctl restart NetworkManager.service || true
    fi

elif [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "$(date): 🔁 Próba 3 — reboot" >> "$LOG"
    RETRIES_COUNT=$(cat "$RETRIES_COUNT_FILE" 2>/dev/null || echo 0)
    RETRIES_COUNT=$((RETRIES_COUNT + 1))
    echo "$RETRIES_COUNT" > "$RETRIES_COUNT_FILE"

    # ⏳ Oblicz wykładniczo rosnącą pauzę, maksymalnie 1440 minut (24h)
    EXP_PAUSE=$((30 * 2 ** (RETRIES_COUNT - 1)))
    if [ "$EXP_PAUSE" -gt 1440 ]; then
        EXP_PAUSE=1440
    fi
    PAUSE_MIN=$EXP_PAUSE
    PAUSE_UNTIL=$((NOW + PAUSE_MIN * 60))
    echo "$PAUSE_UNTIL" > "$PAUSE_FILE"
    PAUSE_END_HUMAN=$(TZ="Europe/Warsaw" date -d "@$PAUSE_UNTIL" "+%H:%M")

    send_telegram "$(cat <<EOF
🛑 *Miner Watchdog* — Reboot systemu
━━━━━━━━━━━━━━━━━━━━
📡 Radio: $RADIO_STATUS
🌐 Internet: $INTERNET_STATUS

💣 Uruchamiam ponownie system

⏸️ Pauza: *${PAUSE_MIN} min* (do ${PAUSE_END_HUMAN})

📊 *Status systemu*:
$SYSINFO
EOF
)"
    echo 0 > "$RETRY_FILE"
    sleep 10
    reboot || /sbin/shutdown -r now || systemctl reboot || /sbin/reboot
fi

echo "$CURRENT_STATE" > "$STATE_FILE"
