# 🛠️ Git-Helfer (PowerShell for Windows)

Ein automatisiertes Kommandozeilen-Werkzeug, um den Workflow zwischen lokalen Projekten (z. B. Stationeers-Mods) und GitHub zu vereinfachen. Der Git-Helfer übernimmt lästige Routineaufgaben wie das Verwalten von Commits, das Erstellen von Releases und die Suche nach Upload-Dateien.

---

## 🌟 Hauptfunktionen

* **Smart Pull & Push:** Schnelle Synchronisation mit dem GitHub-Server inklusive automatischer Zeitstempel für Commit-Nachrichten.
* **Intelligente Release-Automatik:** * Erstellt GitHub-Releases direkt aus dem Terminal.
    * **Auto-Scan:** Sucht automatisch im benachbarten Ordner `.\zip` nach fertigen `.zip`-Dateien.
    * Generiert automatisch Release-Notes basierend auf den letzten Commits.
* **Status-Monitor:** * Detailansicht geänderter Zeilen (Diff).
    * Kompakte Dateiliste der Änderungen (Status -s).
* **Fehlerprüfung:** Überprüft die Existenz der GitHub-CLI (`gh`) und validiert Dateipfade vor dem Hochladen.

---


## ⚠️ Wichtiger Installations-Hinweis (Sicherheit)

Damit deine ZIP-Dateien **nicht** im Quellcode-Repository landen, sondern nur im "Release"-Bereich, musst du deine `.gitignore` Datei anpassen:

1. Öffne die Datei `.gitignore` in deinem Projekt-Ordner.
2. Füge folgende Zeile hinzu:
   ```text
   zip/
   
## 🚀 Installation & Vorbereitung

1.  **Voraussetzungen:**
    * [Git for Windows](https://git-scm.com/) muss installiert sein.
    * [GitHub CLI (gh)](https://cli.github.com/) wird für die Release-Funktion benötigt.
2.  **Projekt kopieren:**
    Lade die `Git-Helfer-Start.bat` und die `Git-Helfer-Programm.ps1` in deinen Projekt-Hauptordner (wo auch der `.git`-Ordner liegt).
3.  **Ordnerstruktur (Empfohlen):**
    ```text
    DeinProjekt/
    ├── .git/
    ├── .gitignore            <-- Wichtig: zip/ hier eintragen!
    ├── Git-Helfer-Start.bat
    ├── Git-Helfer-Programm.ps1
    └── zip/                  <-- Hier legst du deine fertige Mod.zip rein
        └── DeineMod.zip
    ```

---

## 🛠️ Benutzung

Starte einfach die **`Git-Helfer-Start.bat`**. Ein interaktives Menü führt dich durch die Funktionen:

* **[1] Pull:** Lädt den neuesten Stand von GitHub.
* **[2] Push:** Fügt alle Änderungen hinzu (`git add .`), erstellt einen Commit und lädt ihn hoch.
* **[3] Status-Zeile:** Zeigt dir genau, welchen Code du geändert hast.
* **[5] Release:** Fragt nach der Versionsnummer und verknüpft automatisch die gefundene ZIP-Datei mit dem GitHub-Release.

---

## 📝 Lizenz & Autor

* **Autor:** Jens (Bonbonkocher)
* **Projekt-Link:** [Git-Helfer auf GitHub](https://github.com/Bonbonkocher/Git-Helfer-Powershell_for_Windows)

*Entwickelt für die Stationeers Modding-Community und alle, die Git unkompliziert nutzen möchten.*