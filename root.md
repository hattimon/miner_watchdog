# 🌐 Helium Hotspot Root Access & Configuration Guide

<div align="center">
<a href="#english">🇬🇧 English</a> | <a href="#polski">🇵🇱 Polski</a>
</div>

---

<a id="english"></a>
# 🇬🇧 English Version

## 📡 Devices Overview

- **HT-M2808 Indoor Hotspot**  
  https://heltec.org/project/ht-m2808/

- **HT-M01S Indoor LoRa Gateway (Rev.2.0)**  
  (External radio – root access via Heltec support)  
  https://heltec.org/project/ht-m01s-v2/

---

# 🟦 HELTEC SECTION

## 🔐 Root Access via Crankk

### 📥 Installation
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 SSH Access Details
- Port: **22**
- Login: **crankk**
- Password: **B@tch0n3**
- Gain root:
```bash
sudo su
```

🔗 https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

---

# 🟩 SENSECAP M1 SECTION

## 🔑 Full Root Access via SSH (SD Card Method)

### 1️⃣ Remove SD Card
- Insert into computer
- Open partition: **resin-boot**
- Locate file: **config.json**
- ⚠️ Create backup (VERY IMPORTANT)

---

### 2️⃣ Generate SSH Key

```bash
ssh-keygen
```

- Example filename: `sensecap_key`
- You will get:
  - `sensecap_key` (private key)
  - `sensecap_key.pub` (public key)

---

### 3️⃣ Add Key to config.json (CRITICAL STEP)

1. Open `sensecap_key.pub`
2. Copy ENTIRE content
3. Open `config.json`
4. Find section:

```json
"sshKeys": [
    "ssh-rsa ORIGINAL_KEY 10000000@sensecapmx.com"
]
```

5. ADD comma after existing key  
6. Paste new key in quotes

✅ Final result MUST look like:

```json
"sshKeys": [
    "ssh-rsa ORIGINAL_KEY 10000000@sensecapmx.com",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...YOUR_NEW_KEY"
]
```

💡 Missing comma = config will BREAK

---

### 4️⃣ Reinsert SD Card
- Insert back into device
- Boot hotspot

---

### 5️⃣ SSH Login

```bash
cd ~/.ssh

ssh root@IP_HOTSPOT -p 22222 -i sensecap_key
```

- Confirm connection: `yes`
- Enter passphrase (if set)

---

### 6️⃣ Basic Commands
- `ls`
- `cd ..`
- `cd /`

---

## 💻 MobaXterm SSH Connection

### 📋 Requirements
- MobaXterm
- SSH key
- Device IP

### 🔌 Steps
1. Session → SSH  
2. Enter IP  
3. Port: **22222**  
4. Specify username: **root**  
5. Advanced → Use private key  
6. Select file:
```
C:\Users\USER\.ssh\sensecap_key
```

---

## 💡 Notes
- SSH agent usually auto-enabled
- Check firewall if connection fails
- Verify device is reachable (ping)

---

## ⚙️ Network Configuration Generator (SenseCap)

This tool allows:

- WiFi setup (DHCP / Static IP)
- Ethernet-only mode (disable WiFi)
- Quick script generation (balenaOS)

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html

---

<a id="polski"></a>
# 🇵🇱 Wersja Polska

## 📡 Urządzenia

- **HT-M2808 Indoor Hotspot**  
  https://heltec.org/project/ht-m2808/

- **HT-M01S Indoor LoRa Gateway (Rev.2.0)**  
  (Radio zewnętrzne – root przez support Heltec)  
  https://heltec.org/project/ht-m01s-v2/

---

# 🟦 SEKCJA HELTEC

## 🔐 Dostęp root przez Crankk

### 📥 Instalacja
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 Dostęp SSH
- Port: **22**
- Login: **crankk**
- Hasło: **B@tch0n3**

Uzyskanie root:
```bash
sudo su
```

🔗 https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

---

# 🟩 SEKCJA SENSECAP M1

## 🔑 Pełny dostęp root (metoda SD)

### 1️⃣ Wyjmij kartę SD
- Podłącz do komputera  
- Otwórz **resin-boot**  
- Znajdź **config.json**  
- ⚠️ Zrób kopię zapasową  

---

### 2️⃣ Wygeneruj klucz SSH

```bash
ssh-keygen
```

- Nazwa np.: `sensecap_key`
- Powstaną:
  - `sensecap_key`
  - `sensecap_key.pub`

---

### 3️⃣ Dodaj klucz do config.json (NAJWAŻNIEJSZE)

1. Otwórz `sensecap_key.pub`
2. Skopiuj CAŁOŚĆ
3. Otwórz `config.json`
4. Znajdź:

```json
"sshKeys": [
    "ssh-rsa TwójOryginalnyKlucz== 10000000@sensecapmx.com"
]
```

5. Dodaj przecinek po pierwszym kluczu  
6. Wklej nowy klucz w cudzysłowie  

✅ Efekt końcowy:

```json
"sshKeys": [
    "ssh-rsa TwójOryginalnyKlucz== 10000000@sensecapmx.com",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...TwójNowyKlucz"
]
```

💡 Brak przecinka = błąd systemu

---

### 4️⃣ Włóż kartę SD
- Uruchom urządzenie

---

### 5️⃣ Logowanie SSH

```bash
cd ~/.ssh

ssh root@IP_HOTSPOTA -p 22222 -i sensecap_key
```

---

### 6️⃣ Podstawowe komendy
- ls  
- cd ..  
- cd /  

---

## 💻 MobaXterm

### 🔌 Kroki
1. Session → SSH  
2. IP urządzenia  
3. Port: 22222  
4. Login: root  
5. Klucz prywatny  

---

## ⚙️ Generator konfiguracji sieci

Generator umożliwia:

- WiFi DHCP / statyczne IP  
- Tryb tylko Ethernet  
- Automatyczne skrypty  

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html

---

✅ Gotowe – pełny profesjonalny README dla GitHub!
