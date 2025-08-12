#!/bin/bash

set -e

# 1. Dodaj archiwalne repozytorium Debiana Stretch do sources.list.d
ARCHIVE_LIST="/etc/apt/sources.list.d/archive-debian.list"

echo "deb http://archive.debian.org/debian stretch main contrib non-free" | sudo tee $ARCHIVE_LIST
echo "deb-src http://archive.debian.org/debian stretch main contrib non-free" | sudo tee -a $ARCHIVE_LIST

# 2. Wyłącz weryfikację ważności podpisów repozytorium archiwalnego (bo może być nieaktualna)
echo 'Acquire::Check-Valid-Until "false";' | sudo tee /etc/apt/apt.conf.d/99no-check-valid-until

# 3. Odśwież listę pakietów
sudo apt-get update -o Acquire::Check-Valid-Until=false

# 4. Zainstaluj pakiet cron z archiwum (architektura arm64)
sudo apt-get install -y cron

# 5. Włącz i uruchom usługę cron
sudo systemctl enable cron
sudo systemctl start cron

# 6. Sprawdź status usługi cron
sudo systemctl status cron --no-pager

echo "Instalacja i konfiguracja cron zakończona."
echo "Sprawdź crontab dla bieżącego użytkownika poleceniem: crontab -l"
