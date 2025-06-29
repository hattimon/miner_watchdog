Urządzenie [HT-M2808 Indoor Hotspot For Helium](https://heltec.org/project/ht-m2808/) z radiem [HT-M01S Indoor LoRa Gateway (Rev.2.0)](https://heltec.org/project/ht-m01s-v2/)

___
# HT-M2808 Indoor Hotspot For Helium:
https://heltec.org/project/ht-m2808/

# RADIO: HT-M01S Indoor LoRa Gateway (Rev.2.0)
(Zewnętrzne - konfiguracja i hasło do konta root po kontakcie z support heltec.org):
https://heltec.org/project/ht-m01s-v2/
___

## Jeżeli nie masz dostępu do konta root na Heltec to możesz go uzyskać dzięki Crankk:

# Instalacja:
https://crankk.io/guides/crankk-official-guide-for-onboarding-a-heltec-gateway

# Dostęp przez SSH do konta root na Heltec:
https://crankk.io/support/gateways/make-a-secure-shell-ssh-connection-to-your-gateway

## Oto **instrukcja krok po kroku**, jak stworzyć bota na Telegramie i zdobyć wszystkie potrzebne dane, które później wpiszesz do pliku `.env`, by zintegrować go np. z `miner_watchdog.sh`.

---

## ✅ 1. Utwórz bota na Telegramie

1. **Otwórz Telegrama** (aplikację mobilną lub desktop/web).

2. Wyszukaj kontakt: `@BotFather`

3. Rozpocznij rozmowę i wpisz komendę:

   ```
   /start
   ```

4. Następnie utwórz nowego bota:

   ```
   /newbot
   ```

5. BotFather zapyta Cię o:

   * **nazwę bota** (dowolna, np. `Miner Watchdog`)
   * **username bota** (musi kończyć się na `bot`, np. `MinerWatchdogBot`)

6. Po utworzeniu bota BotFather wyśle Ci:

   ```
   Done! Congratulations on your new bot. You will find it at t.me/MinerWatchdogBot.
   Use this token to access the HTTP API:
   123456789:ABCdefGhIJKlmNOPqrsTUVwxyz0123456789
   ```

   ✅ **Zapisz token!** To będzie `TELEGRAM_BOT_TOKEN`.

---

## ✅ **2. Znajdź swoje ID Telegrama**

Aby bot mógł do Ciebie pisać, musisz znać swój **user ID**.

Masz dwie opcje:

### 🔹 Opcja A (najprostsza):

1. Wejdź na Telegramie na bota: [`@userinfobot`](https://t.me/userinfobot)
2. Kliknij „Start”.
3. Bot odpowie np.:

   ```
   👤 ID: 987654321
   First Name: Jan
   ```

   ✅ **Zapisz ten numer** – to jest `TELEGRAM_CHAT_ID`.

---

## ✅ **3. Sprawdź, czy bot działa**

1. Wejdź na Telegramie w link do swojego bota, np.:

   ```
   https://t.me/MinerWatchdogBot
   ```

2. Kliknij `Start`.

Jeśli wszystko działa, możesz już testować wysyłkę wiadomości np. przez `curl`:

```bash
curl -s -X POST https://api.telegram.org/bot123456789:ABCdefGhIJKlmNOPqrsTUVwxyz0123456789/sendMessage \
  -d chat_id=987654321 \
  -d text="Bot działa poprawnie!"
```

(Podmień `botToken` i `chat_id` na swoje dane.)

---

## ✅ **4. Dane do wpisania do `.env`**

Na podstawie powyższych kroków, dodaj do `.env`:

```
TELEGRAM_BOT_TOKEN=123456789:ABCdefGhIJKlmNOPqrsTUVwxyz0123456789
TELEGRAM_CHAT_ID=987654321
```

---
