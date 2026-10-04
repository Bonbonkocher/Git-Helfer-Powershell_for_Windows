# 🛠️ Git-Helfer (PowerShell for Windows)

Ein automatisiertes Werkzeug für Stationeers-Modder und Entwickler, um Projekte effizient mit GitHub zu synchronisieren, Tags zu verwalten und Releases zu erstellen.

---

## 🌟 Hauptfunktionen

* **Dauerhafte Versionsverwaltung:** Die aktuelle Versionsnummer wird zentral in `Scripts\version.txt` gespeichert und bei jedem Programmstart automatisch geladen.
* **Intelligente ZIP-Erstellung:**
  * Erstellt eine ZIP-Datei im Format `ModName-Version.zip`.
  * Packt nur die relevanten Mod-Ordner (`About`, `Data`, `Scripts`).
  * Räumt das `.\zip`-Verzeichnis vor jedem neuen Packvorgang automatisch auf.
* **Git-Tagging & Sync:** Direktes Setzen annotierter Git-Tags (`git tag -a`) inklusive Upload (`--tags`) auf GitHub.
* **Erweiterter Git-Workflow:**
  * Pull, Push, Status und Zeilen-Diff direkt im Menü.
  * Mehrzeilige Commit-Texte direkt aus der Windows-Zwischenablage einfügen (`c`).
  * Force-Push-Option (`--force-with-lease`), falls der Remote-Stand abweicht.
* **GitHub Release-Automation:** Lädt die erstellte ZIP-Datei via GitHub CLI (`gh`) direkt als Release hoch.

---

## 🧭 Menü-Übersicht

| Taste | Aktion | Beschreibung |
| :--- | :--- | :--- |
| **`[0]`** | **Status-Datei** | Kompakte Liste aller geänderten Dateien (`git status -s`). |
| **`[1]`** | **Pull** | Lädt aktuelle Projektdaten von GitHub herunter (`git pull`). |
| **`[2]`** | **Push** | Nimmt alle Änderungen auf (`git add .`), erstellt Commit und lädt hoch. Bietet Zwischenablagen-Import (`c`) und Force-Push-Absicherung. |
| **`[3]`** | **Status-Zeile** | Zeigt zeilenweise Änderungen (Diff) direkt in der Konsole an. |
| **`[T]`** | **Tag erstellen** | Erstellt einen annotierten Tag und lädt ihn via `git push origin --tags` hoch. |
| **`[4]`** | **ZIP erstellen** | Schnürt das Release-Paket anhand von Name und Version. |
| **`[5]`** | **Release (gh)** | Erstellt ein GitHub-Release mit angehängter ZIP-Datei. |
| **`[V]`** | **Version ändern** | Aktualisiert die Versionsnummer in `Scripts\version.txt`. |
| **`[N]`** | **Name ändern** | Passt den Projektnamen in `Scripts\name.txt` an. |
| **`[Q]`** | **Quit** | Beendet das Skript und schließt das Terminalfenster sofort. |

---

## 📂 Projekt-Struktur & Versionierung

Der Git-Helfer nutzt eine **Master-Quelle** für die Versionierung:

1. **`Scripts\version.txt`:** Hier steht die reine Versionsnummer (z. B. `0.2.0`). 
2. Das Skript liest diesen Wert beim Start aus und nutzt ihn für:
   * Den Dateinamen der ZIP.
   * Den Release-Tag auf GitHub (z. B. `v0.2.0`).
   * Den Titel des Releases.

### Empfohlene Ordnerstruktur:
```text
DeinProjekt/
├── .git/
├── .gitignore            <-- Wichtig: /zip/ hier eintragen!
├── Git-Helfer-Start.bat
├── Git-Helfer-Programm.ps1
├── CHANGELOG.md          <-- Protokoll aller Änderungen
├── README.md
├── About/                <-- Mod-Daten
├── Data/                 <-- Mod-Daten
├── Scripts/              
│   ├── name.txt          <-- Projektname
│   └── version.txt       <-- ZENTRALE VERSIONSQUELLE
└── zip/                  <-- Lokaler Zwischenspeicher für Releases
```
## 🚀 Installation

1. **Dateien kopieren:** Kopiere `Git-Helfer-Start.bat` und `Git-Helfer-Programm.ps1` in dein Projekt-Hauptverzeichnis.
2. **Voraussetzungen prüfen:** Stelle sicher, dass `Git` und die `GitHub CLI` installiert sind. Teste dies in deinem Terminal:
   ```bash
   Git = git --version  # Beispiel: "git version 2.53.0.windows.2"
   GitHub CLI = gh --version   # Beispiel: "gh version 2.89.0 (2026-03-26)"
```
## Vorbereitung:
Es muss .git generiert werden in dem man über PowerShell: "gh repo clone [NAME]/[Projeckt]", damit ein GitHub-Pfad genierirt wird
* **HINWEIS** dafür wird GitHub CLI benötigt

## Nutzung:
Starte das Tool über die .bat Datei.

## 🔍 Fehlersuche (Troubleshooting)

Falls das Tool eine Fehlermeldung ausgibt, prüfe bitte folgende Punkte:

### 1. Fehler: "Der Befehl 'git' wurde nicht gefunden"
Dies passiert, wenn Git nicht installiert ist oder nicht im Windows-PATH registriert wurde.
* **Symptom:** Punkt [0], [1], [2], [3] oder [4] werfen rote Fehlermeldungen in der PowerShell.
* **Lösung:** Installiere [Git for Windows](https://git-scm.com/). Starte nach der Installation deinen PC oder zumindest das Terminal neu.

### 2. GitHub-Authentifizierung (Login)
Wenn Punkt **[5]** (Release) fehlschlägt, obwohl `gh` installiert ist, fehlt meist die Anmeldung.
* **Symptom:** Fehlermeldung wie "Notice: authentication required" oder "403 Forbidden".
* **Lösung:** Öffne ein Terminal (CMD oder PowerShell) und gib ein:
  ```bash
  gh auth login
  ```
## 📝 Lizenz & Autor
Autor: Jens (Bonbonkocher)