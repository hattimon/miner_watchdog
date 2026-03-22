# 🌐 Helium Hotspot Root Access & Configuration Guide

<div align="center">
<a href="#english">🇬🇧 English</a> | <a href="#polski">🇵🇱 Polski</a>
</div>

---

<a id="english"></a>
# 🇬🇧 English Version

## 📡 Devices Overview
- HT-M2808 Indoor Hotspot  
  https://heltec.org/project/ht-m2808/
- HT-M01S Indoor LoRa Gateway (Rev.2.0)  
  https://heltec.org/project/ht-m01s-v2/

---

# 🟦 HELTEC SECTION

## 🔐 Root Access via Crankk

### 📥 Installation
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 SSH Access
- Port: 22  
- Login: crankk  
- Password: B@tch0n3  

```bash
sudo su
```

https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

---

# 🟩 SENSECAP M1 SECTION

## 🔑 Root Access via SD Card (FULL GUIDE)

### 1️⃣ Remove SD Card
- Insert into computer
- Open partition: resin-boot
- Find config.json
- ⚠️ Create backup

### 2️⃣ Generate SSH Key
```bash
ssh-keygen
```
- Example: sensecap_key
- Files created:
  - sensecap_key
  - sensecap_key.pub

I recommend the SSH Key Forge application for generating the key: [SSH Key Forge](https://github.com/hattimon/ssh-key-forge)

### 3️⃣ Add Key to config.json (CRITICAL)
```json
"sshKeys": [
    "ssh-rsa ORIGINAL_KEY 10000000@sensecapmx.com"
]
```

➡️ Add comma and new key:

```json
"sshKeys": [
    "ssh-rsa ORIGINAL_KEY 10000000@sensecapmx.com",
    "ssh-rsa AAAAB3...YOUR_KEY"
]
```

⚠️ Missing comma = system error

### 4️⃣ Reinsert SD Card
### 5️⃣ Connect via SSH
```bash
ssh root@IP_HOTSPOT -p 22222 -i sensecap_key
```

### 6️⃣ Commands
- ls
- cd ..
- cd /

---

## 💻 MobaXterm Connection Guide (FULL)

### 📋 Requirements
- MobaXterm installed
- SSH key generated
- Private key file
- SenseCap IP
- Login: root

### 🔌 Steps
1. Open MobaXterm  
2. Click **Session**  
3. Select **SSH**  
4. Enter IP:
```
192.168.0.204
```
5. (Optional) Specify username:
```
root
```
6. Set port: **22222**  
7. Open **Advanced SSH settings**  
8. Enable **Use private key**  
9. Select key:
```
C:\Users\USER\.ssh\sensecap_key
```
10. (Optional) Enable SFTP  
11. Click OK  

---

### 💡 Notes
- SSH agent usually active
- Key may require passphrase once
- Check firewall & ping if issues

---

## ⚙️ SenseCap M1 Network Config Generator

This handy retro-hacker style generator enables quick creation of a bash script for balenaOS (NetworkManager), which:
- Enables WiFi configuration (DHCP or static IP),
- Supports "Ethernet Only" mode (removes WiFi and disables radio),
- Adds options to copy or download the generated script,
- Features an audiovisual "super-hero code master" vibe with animation, background music, and "matrix rain."

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html

---

<a id="polski"></a>
# 🇵🇱 Wersja Polska

## 📡 Urządzenia
- HT-M2808 Indoor Hotspot  
- HT-M01S Indoor LoRa Gateway  

---

# 🟦 SEKCJA HELTEC

## 🔐 Root przez Crankk

### 📥 Instalacja
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 SSH
- Port: 22  
- Login: crankk  
- Hasło: B@tch0n3  

```bash
sudo su
```

---

# 🟩 SEKCJA SENSECAP

## 🔑 Root przez SSH (pełna instrukcja)

### 1️⃣ Wyjmij kartę SD
- Otwórz resin-boot  
- Znajdź config.json  
- ⚠️ Zrób backup  

### 2️⃣ Generuj klucz
```bash
ssh-keygen
```
Przykład: sensecap_key

- Utworzone pliki:  
  - sensecap_key  
  - sensecap_key.pub  

Do wygenerowania klucza polecam aplikację [SSH Key Forge](https://github.com/hattimon/ssh-key-forge)

### 3️⃣ Edycja config.json

```json
"sshKeys": [
    "ssh-rsa TwójKlucz"
]
```

➡️ Dodaj przecinek + nowy klucz:

```json
"sshKeys": [
    "ssh-rsa TwójKlucz",
    "ssh-rsa NOWY_KLUCZ"
]
```

⚠️ Brak przecinka = błąd

---

### 4️⃣ Włóż kartę
### 5️⃣ SSH
```bash
ssh root@IP_HOTSPOTA -p 22222 -i sensecap_key
```

---

## 💻 MobaXterm (pełna instrukcja)

### 📋 Wymagania
- MobaXterm  
- Klucz SSH  
- IP  
- Login root  

### 🔌 Kroki
1. Session → SSH  
2. IP:
```
192.168.0.204
```
3. Port: 22222  
4. Username: root  
5. Advanced → Use private key  
6. Wskaż:
```
C:\Users\Kowalski\.ssh\sensecap_key
```
7. (Opcjonalnie) SFTP  
8. OK  

---

### 💡 Uwagi
- ssh-agent aktywny domyślnie  
- Możliwe jednorazowe hasło do klucza  
- Sprawdź firewall i ping  

---

## ⚙️ Generator konfiguracji sieciowej dla SenseCap M1

Ten wygodny generator w stylu retro-hackerskim umożliwia szybkie tworzenie skryptu bash dla balenaOS (NetworkManager), który:
- Umożliwia konfigurację WiFi (DHCP lub statyczne IP),
- Obsługuje tryb „Tylko Ethernet” (usunięcie WiFi i wyłączenie radia),
- Dodaje opcje kopiowania lub pobrania wygenerowanego skryptu,
- Ma audiowizualny klimat „super-hero code master” z animacją, muzyką w tle i „matrix rain”.

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html

---

✅ You are ready to go!
