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
___

# Jak dostać się na root SenseCap M1 przez SSH

## 1. Wyciągnij kartę SD z urządzenia SenseCap M1

- Podłącz kartę SD do swojego komputera.
- Po zamontowaniu pojawi się partycja o nazwie **`resin-boot`** — to ta, do której musisz wejść.
- Otwórz tę partycję i znajdź plik **`config.json`**.
- **Zrób kopię zapasową tego pliku** — zawiera indywidualne ustawienia Twojego hotspota, więc jest bardzo ważny.

---

## 2. Wygeneruj nowy klucz SSH

- Otwórz terminal na swoim komputerze.
- Wpisz polecenie:

  ```bash
  ssh-keygen
  ```

- Zostaniesz zapytany o nazwę pliku do zapisania klucza, np. wpisz `sensecap_key`.
- Następnie wpisz dwukrotnie hasło (możesz też pozostawić puste, ale niezalecane).
- W katalogu domowym pojawią się dwa pliki:  
  - `sensecap_key` — klucz prywatny (login)  
  - `sensecap_key.pub` — klucz publiczny (to ten, który trzeba dodać do SenseCap)

---

## 3. Dodaj nowy klucz do `config.json`

- Skopiuj zawartość pliku `sensecap_key.pub` (otwórz go w edytorze tekstowym i zaznacz wszystko).
- Otwórz plik `config.json` na partycji **`resin-boot`**.
- Znajdź sekcję `"sshKeys"`, powinna wyglądać mniej więcej tak:

  ```json
  "sshKeys": [
      "ssh-rsa TwójOryginalnyKlucz== 10000000@sensecapmx.com"
  ]
  ```

- Po oryginalnym kluczu wstaw przecinek, enter i wklej swój nowy klucz w cudzysłowie, np.:

  ```json
  "sshKeys": [
      "ssh-rsa TwójOryginalnyKlucz== 10000000@sensecapmx.com",
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy...TwójNowyKlucz"
  ]
  ```

- Zapisz plik.

---

## 4. Włóż kartę SD z powrotem do SenseCap M1

- Włóż kartę do urządzenia i uruchom hotspota.

---

## 5. Zaloguj się przez SSH

- Na komputerze, gdzie masz wygenerowane klucze, otwórz terminal.
- Przejdź do katalogu `.ssh` (lub tam, gdzie masz klucz prywatny):

  ```bash
  cd ~/.ssh
  ```

- Połącz się z SenseCap M1 poleceniem:

  ```bash
  ssh root@IP_HOTSPOTA -p 22222 -i sensecap_key
  ```

  Gdzie `IP_HOTSPOTA` to adres IP Twojego SenseCap M1.

- Jeśli pojawi się pytanie o zaufanie do hosta, wpisz `yes`.
- Następnie wpisz hasło, które ustawiłeś podczas generowania klucza (lub naciśnij Enter jeśli nie ustawiłeś hasła).

---

## 6. Podstawowe polecenia po zalogowaniu

- `ls` — wyświetla pliki i foldery w bieżącym katalogu.
- `cd ..` — przejście do katalogu nadrzędnego.
- `cd /` — przejście do katalogu głównego.

---

Gratulacje! Jesteś zalogowany jako root na SenseCap M1 i możesz teraz konfigurować urządzenie.
___

# Instrukcja połączenia z SenseCap M1 przez MobaXterm

Ten dokument opisuje krok po kroku, jak skonfigurować połączenie SSH do urządzenia **SenseCap M1** za pomocą **MobaXterm** i klucza SSH.

---

## 📋 Wymagania

- Zainstalowany [MobaXterm](https://mobaxterm.mobatek.net/) na Windowsie  
- Wygenerowany klucz SSH (np. `ssh-keygen`)  
- Klucz prywatny dostępny lokalnie  
- Adres IP SenseCap M1  
- Dane dostępu (np. login `root`)  

---

## 🔌 Jak się połączyć

1. Uruchom **MobaXterm**.
2. Kliknij ikonę **Session** (Sesja) w górnym lewym rogu.
3. Wybierz zakładkę **SSH**.
4. W polu **Remote host** wpisz adres IP SenseCap M1, np.:

   ```
   192.168.0.204
   ```

5. (Opcjonalnie) Zaznacz **Specify username** i wpisz login, np.:

   ```
   root
   ```

6. Ustaw port na **22222** (domyślny dla SenseCap).
7. Rozwiń **Advanced SSH settings**.
8. Zaznacz opcję **Use private key** i wskaż ścieżkę do pliku z kluczem prywatnym, np.:

   ```
   C:\Users\Kosmo\.ssh\sensecap_root
   ```

9. (Opcjonalnie) W sekcji **SSH-browser type** możesz ustawić protokół **SFTP**, aby mieć możliwość transferu plików.
10. Kliknij **OK**, aby zapisać i otworzyć połączenie.

---

## 💡 Dodatkowe uwagi

- Upewnij się, że klucz prywatny nie jest chroniony hasłem **lub** że agent SSH (`ssh-agent`) jest uruchomiony, jeśli klucz ma passphrase.
   (domyslnie MobaXterm ma uruchomionego agenta SSH, a klucz generowany powyższym sposobem będzie wymagał tylko raz podanie hasła do klucza jakie ustawiliśmy w ssh-keygen)
- Jeśli SenseCap M1 działa na innym porcie niż 22222, ustaw go w polu **Port**.
- W przypadku problemów z połączeniem sprawdź:
  - Czy urządzenie jest dostępne w sieci (ping).
  - Czy firewall nie blokuje portu SSH.

---

✅ Teraz możesz zdalnie zarządzać SenseCap M1 przez terminal w **MobaXterm**!
___

## Generator konfiguracji sieciowej dla SenseCap M1

Ten wygodny generator w stylu retro-hackerskim umożliwia szybkie tworzenie skryptu bash dla balenaOS (NetworkManager), który:
- Umożliwia konfigurację WiFi (DHCP lub statyczne IP),
- Obsługuje tryb „Tylko Ethernet” (usunięcie WiFi i wyłączenie radia),
- Dodaje opcje kopiowania lub pobrania wygenerowanego skryptu,
- Ma audiowizualny klimat „super-hero code master” z animacją, muzyką w tle i „matrix rain”.

 **Sprawdź go już teraz:**  
[**Generator – SenseCap M1 (futurystyczny motyw)**](https://hattimon.github.io/helium/SenseCapM1/wifi-configurator.html)

 Po kliknięciu strona otworzy się w nowej karcie i od razu zaoferuje gotowy interaktywny generator—z ćmy, neonami i muzyką!  






