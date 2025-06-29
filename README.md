# miner_watchdog
Watchdog dla Heltec HT-M2808 Hotspot Helium

# 🛡 miner\_watchdog — watchdog dla Heltec HT-M2808 Hotspot

Skrypt `miner_watchdog` automatycznie monitoruje:

* 🚀 połączenie z radiem Heltec (`RADIO_IP`)
* 🌍 połączenie z Internetem (`INTERNET_IP`)

Jeśli wykryje problemy, podejmuje **automatyczne akcje naprawcze** w ustalonej kolejności:

1. 🔄 Restart kontenera Docker z minerem
2. ♻️ Restart interfejsów sieciowych (eth0, wlan0) i usług (`connman`, `NetworkManager`)
3. 🔁 Restart systemu

Wszystkie ważne zdarzenia są raportowane do **Telegrama** przez bota.

---

## 📋 Wymagania

* System oparty na **Debian/Ubuntu** (np. Debian 9 Stretch) 🔹✅Domyślnie na Heltec
* `docker` z zainstalowanym minerem Helium 🔹✅Domyślnie na Heltec (kontener nazywa się "miner")
* Konto Telegram z botem i chatem
* Urządzenie [HT-M2808 Indoor Hotspot For Helium](https://heltec.org/project/ht-m2808/) z radiem [HT-M01S Indoor LoRa Gateway (Rev.2.0)](https://heltec.org/project/ht-m01s-v2/) lub bez zewnętrznego radia (wtedy podaj stały adres LAN do pingów np. routera)
* **Konieczna prawidlowa lokalizacja skryptów:**
/
├── root/
│   ├── setup_miner_watchdog.sh
│   └── miner_watchdog.sh

```


---

## 🔧 Instalacja z GitHub (zalecana)

Zaloguj się na urządzenie jako `root`, następnie:

```bash
# Zainstaluj git (jeśli nie masz)
apt-get install -y git

# Sklonuj repozytorium
cd /root
git clone https://github.com/hattimon/miner_watchdog.git

# Skopiuj skrypty do katalogu /root (zgodnie z założeniami instalatora)
cp miner_watchdog/scripts/*.sh /root

# Usuń ewentualne znaki Windows
sed -i 's/\r$//' /root/setup_miner_watchdog.sh
sed -i 's/\r$//' /root/miner_watchdog.sh

# Nadaj uprawnienia i uruchom instalację
chmod +x /root/setup_miner_watchdog.sh
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

---

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

## 💬 Przykładowe wiadomości Telegram

```
🚀 Miner Watchdog uruchomiony
📡 Sprawdzam stan radia: 192.168.1.20
🌐 Sprawdzam połączenie internetowe: 8.8.8.8
...
📊 Status systemu:
CPU: 5.2%
RAM: 38.1%
Temp: 45.6°C
Dysk: 72%
```

---

## 💾 Dane i logi

* Dane stanu i retry znajdują się w: `/var/lib/miner_watchdog`
* Logi: `/var/log/miner_watchdog.log`
* Konfiguracja: `/root/.env`

---

## 🛯 Reset pauzy

Po przywróceniu połączenia pauza zostaje automatycznie wyzerowana, a system sam się przywraca do normalnego trybu pracy.

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
```

---

## 📜 Licencja

Ten projekt może być używany i modyfikowany zgodnie z licencją MIT (zobacz plik `LICENSE`).

---

## 🤝 Wsparcie

Masz pytania lub potrzebujesz pomocy? Skontaktuj się z autorem przez Telegram lub zgłoś problem w [Issues](https://github.com/hattimon/miner_watchdog/issues).
