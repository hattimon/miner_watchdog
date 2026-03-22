# 🌐 Helium Hotspot & SenseCap M1 Guide

<div align="center">
<a href="#english">🇬🇧 English</a> | <a href="#polski">🇵🇱 Polski</a>
</div>

---

<a id="english"></a>
# 🇬🇧 English Version

## 📡 Devices

### 🔹 HT-M2808 Indoor Hotspot
https://heltec.org/project/ht-m2808/

### 🔹 Radio: HT-M01S Indoor LoRa Gateway (Rev.2.0)
(External – root access via Heltec support)
https://heltec.org/project/ht-m01s-v2/

---

## 🔐 Root Access via Crankk

### 📥 Installation
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 SSH Access
- Port: 22  
- Login: crankk  
- Password: B@tch0n3  
- Command: sudo su  

https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

---

## 🛠 SenseCap M1 Root Access via SSH

### 1️⃣ Remove SD Card
- Insert into computer
- Open partition: `resin-boot`
- Backup `config.json`

### 2️⃣ Generate SSH Key
```bash
ssh-keygen
```

### 3️⃣ Add Key to config.json
Add your public key to:
```json
"sshKeys": []
```

### 4️⃣ Reinsert SD Card

### 5️⃣ Connect via SSH
```bash
ssh root@IP_HOTSPOT -p 22222 -i sensecap_key
```

### 6️⃣ Basic Commands
- ls
- cd ..
- cd /

---

## 💻 MobaXterm Connection Guide

### 📋 Requirements
- MobaXterm
- SSH Key
- IP Address

### 🔌 Steps
1. Session → SSH  
2. Enter IP  
3. Port: 22222  
4. Use private key  
5. Connect  

---

## ⚙️ Network Configuration Generator

Interactive generator for:
- WiFi (DHCP / Static)
- Ethernet-only mode
- Script export

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html

---

<a id="polski"></a>
# 🇵🇱 Wersja Polska

## 📡 Urządzenia

### 🔹 HT-M2808 Indoor Hotspot
https://heltec.org/project/ht-m2808/

### 🔹 Radio: HT-M01S Indoor LoRa Gateway (Rev.2.0)
(Zewnętrzne – dostęp root przez support Heltec)
https://heltec.org/project/ht-m01s-v2/

---

## 🔐 Dostęp root przez Crankk

### 📥 Instalacja
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

### 🖥 Dostęp SSH
- Port: 22  
- Login: crankk  
- Hasło: B@tch0n3  
- Komenda: sudo su  

https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

---

## 🛠 Dostęp root do SenseCap M1 przez SSH

### 1️⃣ Wyjmij kartę SD
- Podłącz do komputera  
- Otwórz `resin-boot`  
- Zrób kopię `config.json`  

### 2️⃣ Wygeneruj klucz SSH
```bash
ssh-keygen
```

### 3️⃣ Dodaj klucz do config.json
```json
"sshKeys": []
```

### 4️⃣ Włóż kartę z powrotem

### 5️⃣ Połącz przez SSH
```bash
ssh root@IP_HOTSPOTA -p 22222 -i sensecap_key
```

### 6️⃣ Podstawowe komendy
- ls  
- cd ..  
- cd /  

---

## 💻 Instrukcja MobaXterm

### 📋 Wymagania
- MobaXterm  
- Klucz SSH  
- IP urządzenia  

### 🔌 Kroki
1. Session → SSH  
2. IP urządzenia  
3. Port: 22222  
4. Klucz prywatny  
5. Połącz  

---

## ⚙️ Generator konfiguracji sieci

Generator umożliwia:
- WiFi DHCP / statyczne  
- Tryb tylko Ethernet  
- Eksport skryptu  

👉 https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html
