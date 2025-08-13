#!/bin/bash
set -e

echo "[1/7] Wykrywanie architektury..."
ARCH=$(dpkg --print-architecture)
echo "Architektura: $ARCH"

echo "[2/7] Konfiguracja archiwalnego repozytorium Debian 9 Stretch..."
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s) || true
sudo rm -f /etc/apt/sources.list.d/*
echo "deb http://archive.debian.org/debian stretch main" | sudo tee /etc/apt/sources.list
echo 'Acquire::Check-Valid-Until "false";' | sudo tee /etc/apt/apt.conf.d/99ignore-release-date
echo 'Acquire::https::Verify-Peer "false";' | sudo tee /etc/apt/apt.conf.d/99disable-ssl-verification
sudo apt-get clean
sudo apt-get update

echo "[3/7] Instalacja cron dla $ARCH..."
sudo apt-get install -y cron

echo "[4/7] Naprawa ustawień języka (locale)..."
sudo apt-get install -y locales
sudo locale-gen pl_PL.UTF-8
sudo update-locale LANG=pl_PL.UTF-8
export LANG=pl_PL.UTF-8

echo "[5/7] Uruchamianie i włączanie usługi cron..."
sudo systemctl start cron
sudo systemctl enable cron

echo "[6/7] Sprawdzanie statusu usługi..."
sudo systemctl status cron --no-pager

echo "[7/7] Sprawdzenie crontaba..."
crontab -l || echo "Brak wpisów w crontabie dla użytkownika $(whoami)."

echo "✅ Instalacja i konfiguracja zakończona!"
