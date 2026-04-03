# 🛠️ Git-Helfer (PowerShell for Windows)

Ein automatisiertes Werkzeug für Stationeers-Modder, um Projekte effizient mit GitHub zu synchronisieren und Releases zu erstellen.

---

## 🌟 Hauptfunktionen

* **Dauerhafte Versionsverwaltung:** Die aktuelle Versionsnummer wird zentral in `Scripts\version.txt` gespeichert und bei jedem Programmstart automatisch geladen.
* **Intelligente ZIP-Erstellung:** * Erstellt eine ZIP-Datei im Format `ModName-Version.zip`.
    * Packt nur die relevanten Mod-Ordner (`About`, `Data`, `Scripts`).
    * Räumt das `.\zip` Verzeichnis vor jedem neuen Packvorgang automatisch auf.
* **GitHub Release-Automation:** Lädt die erstellte ZIP-Datei direkt als neuen Release (inkl. Tagging) hoch.
* **Git-Workflow:** Schneller Zugriff auf `Pull`, `Push` und `Status` direkt aus dem Menü.

---

## 📂 Projekt-Struktur & Versionierung

Der Git-Helfer nutzt eine **Master-Quelle** für die Versionierung:

1. **Scripts\version.txt:** Hier steht die reine Versionsnummer (z. B. `0.0.9`). 
2. Das Skript liest diesen Wert beim Start aus und nutzt ihn für:
   * Den Dateinamen der ZIP.
   * Den Release-Tag auf GitHub (z. B. `v0.0.9`).
   * Den Titel des Releases.

### Empfohlene Ordnerstruktur:
```text
DeinProjekt/
├── .git/
├── .gitignore            <-- Wichtig: /zip/ hier eintragen!
├── Git-Helfer-Start.bat
├── Git-Helfer-Programm.ps1
├── About/                <-- Mod-Daten
├── Data/                 <-- Mod-Daten
├── Scripts/              
│   └── version.txt       <-- ZENTRALE VERSIONSQUELLE
└── zip/                  <-- Lokaler Zwischenspeicher für Releases

## 🚀 Installation

1. **Dateien kopieren:** Kopiere `Git-Helfer-Start.bat` und `Git-Helfer-Programm.ps1` in dein Projekt-Hauptverzeichnis.
2. **Voraussetzungen prüfen:** Stelle sicher, dass Git und die GitHub CLI installiert sind. Teste dies in deinem Terminal:
   ```bash
   git --version  # Beispiel: "git version 2.53.0.windows.2"
   gh --version   # Beispiel: "gh version 2.89.0 (2026-03-26)"

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

## 📝 Lizenz & Autor
Autor: Jens (Bonbonkocher)