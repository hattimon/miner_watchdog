# miner_watchdog
Watchdog dla Heltec HT-M2808 Hotspot Helium

# 🛡 miner\_watchdog — watchdog dla Heltec HT-M2808 Hotspot

Skrypt `miner_watchdog` automatycznie monitoruje co minutę:

* 🚀 połączenie z radiem Heltec (`RADIO_IP`)
* 🌍 połączenie z Internetem (`INTERNET_IP`)

Jeśli wykryje problemy, podejmuje **automatyczne akcje naprawcze** w ustalonej kolejności:

1. 🔄 Restart kontenera Docker z minerem
2. ♻️ Restart interfejsów sieciowych (eth0, wlan0) i usług (`connman`, `NetworkManager`)
3. 🔁 Restart systemu
   
⏸️ Po 3 nieudanych próbach pauza rośnie wykładniczo:  
30 min → 1h → 2h → 4h → 8h → 16h → 24h (max) 

🔄 **Reset pauzy:**
Po przywróceniu połączenia pauza zostaje automatycznie wyzerowana, a system sam się przywraca do normalnego trybu pracy.

Wszystkie ważne zdarzenia są raportowane do **Telegrama** przez bota.

## 📋 Wymagania

* System oparty na **Debian/Ubuntu** (np. Debian 9 Stretch) 🔹✅Domyślnie na Heltec
* `docker` z zainstalowanym minerem Helium 🔹✅Domyślnie na Heltec (kontener nazywa się "miner")
* Konto Telegram z botem i chatem
* Urządzenie [HT-M2808 Indoor Hotspot For Helium](https://heltec.org/project/ht-m2808/) z radiem [HT-M01S Indoor LoRa Gateway (Rev.2.0)](https://heltec.org/project/ht-m01s-v2/) lub bez zewnętrznego radia (wtedy podaj stały adres LAN do pingów np. routera)
* **Konieczna prawidlowa lokalizacja skryptów:**
```bash
/
├── root/
│   ├── setup_miner_watchdog.sh
│   ├── miner_watchdog.sh
│   └── .env
```
* [Dostęp do konta ROOT oraz Hardware/Software Linki.](https://github.com/hattimon/miner_watchdog/blob/main/linki.md)

## 🔧 Instalacja z GitHub (zalecana)

Zaloguj się na urządzenie jako `root`, następnie:

* Zainstaluj git (jeśli nie masz) 
```bash
apt-get install -y git
```
* Sklonuj repozytorium
```bash
cd /root
git clone https://github.com/hattimon/miner_watchdog.git
```

* Skopiuj skrypty do katalogu /root (zgodnie z założeniami instalatora)
```bash
cp miner_watchdog/scripts/*.sh /root
```

* Usuń ewentualne znaki Windows
```bash
sed -i 's/\r$//' /root/setup_miner_watchdog.sh
sed -i 's/\r$//' /root/miner_watchdog.sh
```

* Nadaj uprawnienia i uruchom instalację
```bash
chmod +x /root/setup_miner_watchdog.sh
```
```bash
cd /root
./setup_miner_watchdog.sh
```
---

## 🔧 Instalacja krok po kroku

### 1. Przygotuj dane

| Symbol           | Opis                                                                      | Przykład           |
| ---------------- | ------------------------------------------------------------------------- | ------------------ |
| `RADIO_IP`       | IP radia Heltec lub adres LAN (np. IP routera)                            | `192.168.1.20`     |
| `INTERNET_IP`    | IP do sprawdzenia dostępności internetu (np. ping)                        | `8.8.8.8`          |
| `CONTAINER_NAME` | Nazwa kontenera Docker z minerem                                          | `miner`            |
| `BOT_TOKEN`      | Token utworzony przez [@BotFather](https://t.me/BotFather) na Telegramie  | `123456789:ABC...` |
| `CHAT_ID`        | Chat ID Telegrama uzyskany przez [@userinfobot](https://t.me/userinfobot) | `987654321`        |

---
* [Instrukcja telegram_bot](https://github.com/hattimon/miner_watchdog/blob/main/telegram_bot.md)

## 🔧 Alternatywnie: ręczne kopiowanie plików

### 2. Skopiuj pliki na Helium Miner

Zaloguj się przez SSH i skopiuj pliki do katalogu `/root`:

```bash
scp setup_miner_watchdog.sh miner_watchdog.sh root@HOTSPOT_IP:/root
```

Usuń ewentualne znaki Windows `\r`:

```bash
sed -i 's/\r$//' /root/setup_miner_watchdog.sh
sed -i 's/\r$//' /root/miner_watchdog.sh
```

Nadaj prawa wykonywania:

```bash
chmod +x /root/setup_miner_watchdog.sh
```

### 3. Uruchom instalator

```bash
cd /root
./setup_miner_watchdog.sh
```

Wprowadź wymagane dane (IP, tokeny, nazwę kontenera) — zostaną zapisane w `/root/.env`.

---

## 🛠 Co robi instalator?

* Tworzy plik `.env` z Twoimi ustawieniami
* Przygotowuje plik logów `/var/log/miner_watchdog.log`
* Dodaje do crontaba:

```cron
0 0 * * * tail -n 500 /var/log/miner_watchdog.log > /var/log/miner_watchdog.tmp && mv /var/log/miner_watchdog.tmp /var/log/miner_watchdog.log
* * * * * /bin/bash /root/miner_watchdog.sh >> /var/log/miner_watchdog.log 2>&1
```

* Instaluje brakujące pakiety (`cron`, `curl`, `ping`) **bez aktualizowania systemu** (stare repo)
* Umożliwia zdalne śledzenie statusu i awarii z poziomu Telegrama

---
Oto **ogólne podpunkty** pokazujące, **co robi ten skrypt instalacyjny**:

1. **Rozpoczyna konfigurację watchdoga do monitorowania połączenia i kontenera.**

2. **Instaluje brakujące narzędzia potrzebne do działania skryptu (ping, cron, curl).**

3. **Upewnia się, że systemowy harmonogram zadań (`cron`) jest aktywny.**

4. **Pobiera od użytkownika wymagane dane konfiguracyjne (adresy IP, dane Telegrama, nazwa kontenera).**

5. **Zapisuje te dane do pliku `.env` z odpowiednimi uprawnieniami.**

6. **Nadaje skryptowi watchdoga prawo do uruchamiania.**

7. **Tworzy i przygotowuje plik logów, w którym będą zapisywane działania watchdoga.**

8. **Ustawia zadania `cron` do:**

   * uruchamiania watchdoga co minutę,
   * czyszczenia logu raz dziennie jeżeli ma więcej niż 500 linii

9. **Wyświetla aktualny harmonogram zadań i kończy konfigurację.**
---

## 💬 Przykładowe wiadomości Telegram

```
✅ Miner Watchdog — Połączenie przywrócone
━━━━━━━━━━━━━━━━━━━━
📡 Radio: ✅ Tak
🌐 Internet: ✅ Tak

📡 Sprawdzam stan radia: 192.168.0.100  
🌐 Sprawdzam połączenie internetowe: 8.8.8.8  
🛠️ Przy problemach wykonuję kolejno:
   1️⃣ Restart kontenera miner  
   2️⃣ Restart interfejsów sieciowych i usług (eth0, wlan0, connman, NetworkManager)  
   3️⃣ Reboot systemu  

⏸️ Po 3 nieudanych próbach pauza rośnie wykładniczo:  
30 min → 1h → 2h → 4h → 8h → 16h → 24h (max) 

📊 Status systemu:

CPU: 3.1%
RAM: 6.3%
Temp: 50.8°C
Dysk: 27%

📡 Aktywne Hotspot IP:
 🌐 IP Ethernet (eth0): 192.168.0.120 ✅
 📶 IP WiFi (wlan0): brak ❌
```
```
⚙️ Miner Watchdog — Restart kontenera
━━━━━━━━━━━━━━━━━━━━
📡 Radio: ✅ Tak
🌐 Internet: ❌ Nie

🔄 Restartuję kontener: miner

📊 Status systemu:

CPU: 3.1%
RAM: 6.2%
Temp: 48.2°C
Dysk: 27%

📡 Aktywne Hotspot IP:
 🌐 IP Ethernet (eth0): 192.168.0.120 ✅
 📶 IP WiFi (wlan0): brak ❌
```
```
🛑 Miner Watchdog — Reboot systemu
━━━━━━━━━━━━━━━━━━━━
📡 Radio: ❌ Nie
🌐 Internet: ✅ Tak

💣 Uruchamiam ponownie system

⏸️ Pauza: 30 min (do 09:39)

📊 Status systemu:

CPU: 4.1%
RAM: 6.6%
Temp: 45.0°C
Dysk: 27%

📡 Aktywne Hotspot IP:
 🌐 IP Ethernet (eth0): 192.168.0.120 ✅
 📶 IP WiFi (wlan0): brak ❌
```

## 💾 Dane i logi

* Dane stanu i retry znajdują się w: `/var/lib/miner_watchdog`
* Logi: `/var/log/miner_watchdog.log`
* Konfiguracja: `/root/.env`

---

## 🔎 Dodatkowe pliki repozytorium

**`.gitignore`**:
```
.env
*.log
*.tmp
/var/
*.swp
```

**`LICENSE` (MIT)**:

```
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**Rekomendowana struktura katalogu repozytorium:**

```
miner_watchdog/
├── scripts/
│   ├── setup_miner_watchdog.sh
│   └── miner_watchdog.sh
├── .gitignore
├── LICENSE
├── README.md
├── linki.md
└── telegram_bot.md
```

---

## 📜 Licencja

Ten projekt może być używany i modyfikowany zgodnie z licencją MIT (zobacz plik `LICENSE`).

---

## 🤝 Wsparcie

Masz pytania lub potrzebujesz pomocy? Skontaktuj się z autorem przez Telegram lub zgłoś problem w [Issues](https://github.com/hattimon/miner_watchdog/issues).
