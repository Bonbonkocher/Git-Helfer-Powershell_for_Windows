# Changelog

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/)
und dieses Projekt hält sich an [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

## [0.2.0] - 2026-10-04

### Hinzugefügt
* **Git-Tag-Verwaltung:** Neuer Menüpunkt `[T]`, um annotierte Git-Tags (`git tag -a ... -m "..."`) lokal anzulegen und mit `git push origin --tags` direkt zu GitHub zu übertragen.
* **Mehrzeilige Commit-Nachrichten:** Unterstützung für die Zwischenablage (`[c]`), um vorformatierte Texte mehrzeilig via `Get-Clipboard` in Commits einzufügen.
* **Force-Push-Absicherung:** Automatische Abfrage für `git push --force-with-lease`, falls der Remote-Branch abweicht und der reguläre Push abgewiesen wird.
* **Diff-Inspektion:** `Status-Zeile` (`[3]`) nutzt `--no-pager`, um Zeilenänderungen ohne Pager-Blockade direkt in der Konsole auszugeben.

### Behoben
* **Syntax-Fehler bei PowerShell-Pipes:** Typografische Formatierungsfehler (`\vert{}`) bei Datei-Ausgaben (`Out-File`) durch Standard-Pipes (`|`) ersetzt.
* **Fensterschließung:** Menüpunkt `[Q]` beendet den Terminalprozess nun zuverlässig mittels `exit` statt `return`.

## [0.1.0] - 2026-09-15

### Hinzugefügt
* Grundlegendes Konsolenmenü für Git-Aktionen (`pull`, `push`, `status`).
* Automatisierte ZIP-Erstellung für definierte Mod-Verzeichnisse (`About`, `Data`, `Scripts`).
* Release-Upload via GitHub CLI (`gh release create`).
* Persistente Versionsverwaltung über `Scripts/version.txt` und Projektnamen über `Scripts/name.txt`.