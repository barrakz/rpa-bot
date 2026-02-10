# RPA Bot – Robot Framework (skeleton)

Minimalny, lokalny fundament projektu Robot Framework (Python) pod macOS. Docelowo bot będzie uruchamiany na Windows z GUI — na razie tylko podstawa bez automatyzacji UI.

## Szybki start

1) Utwórz wirtualne środowisko i zainstaluj zależności:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

2) Uruchom testy:

```bash
robot --outputdir artifacts/logs tests
```

## Workflow demo (macOS)

```bash
scripts/run_mac.sh
```

## Wybór środowiska i przeglądarki

Domyślnie dobór przeglądarki jest automatyczny:
- macOS → `safari`
- Windows → `chrome`

Możesz wymusić:

```bash
RPA_ENV=mac BROWSER=safari robot --outputdir artifacts/logs process/open_sellasist.robot
```

## Safari (macOS)

Safari używa wbudowanego `safaridriver` (bez Homebrew).

1) Włącz zdalną automatyzację:
- Safari → Preferences → Advanced → „Show Develop menu in menu bar”.
- Develop → „Allow Remote Automation”.

2) Jednorazowo aktywuj `safaridriver`:

```bash
sudo safaridriver --enable
```

3) Uruchom test przykładowy:

```bash
robot --outputdir artifacts/logs tests/open_wp.robot
```

Uwaga: Selenium nie może wpisywać adresu w pasek URL przeglądarki (chrome UI). Zamiast tego używamy `Go To`, które programowo nawiguję do adresu.

## Logi i artefakty

- `artifacts/logs/` – `log.html`, `report.html`, `output.xml` oraz `smoke_ok.txt`
- `artifacts/screenshots/` – miejsce na screenshoty (na razie puste)

## Sekrety i loginy (lokalnie)

W czasie prac na macOS przechowuj dane dostępowe lokalnie w:
`/.local/.env` (plik poza repo). Przykładowy format znajdziesz w `.env.example`.

```env
SELLASIST_USER=twoj_login
SELLASIST_PASS=twoje_haslo
```

Plik `.local/.env` jest ignorowany przez git.

## Dodawanie testów i keywordów

- Nowe testy dodawaj w `tests/` jako pliki `.robot`.
- Własne keywordy umieszczaj w `src/keywords/` i importuj w testach przez `Resource`.

## Uwaga o docelowym środowisku

Na tym etapie projekt jest przygotowany pod lokalne uruchomienia na macOS. Docelowo bot będzie uruchamiany na Windows z GUI.

## Bundle Windows (demo)

Gotowy bundle do uruchomienia bez instalacji repo:
- `bundle/windows/1.0/`
- `bundle/windows/rpa-bot-windows-1.0.zip`
- `bundle/windows/1.1/`
- `bundle/windows/rpa-bot-windows-1.1.zip`

Uruchom `run.bat`, aby otworzyć Chrome i stronę logowania SellAsist.

Bundle `1.1` dodatkowo:
- pozwala podać login/hasło jako argumenty: `run.bat "user" "pass"` (lub env `SELLASIST_USER`/`SELLASIST_PASS`)
- otwiera folder `NOTEPAD` na pulpicie (Windows/macOS stub)
