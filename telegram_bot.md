## Oto **instrukcja krok po kroku**, jak stworzyć bota na Telegramie i zdobyć wszystkie potrzebne dane, które później wpiszesz do pliku `.env`, by zintegrować go np. z `miner_watchdog.sh`.

---

## ✅ **1. Utwórz bota na Telegramie**

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

   ✅ **Zapisz token!** To będzie `BOT_TOKEN`.

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

   ✅ **Zapisz ten numer** – to jest `CHAT_ID`.

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
BOT_TOKEN=123456789:ABCdefGhIJKlmNOPqrsTUVwxyz0123456789
CHAT_ID=987654321
```

---
