# ==============================================================================
# GIT-HELFER (PowerShell for Windows)
# 
# Copyright (c) 2026 Jens (Bonbonkocher)
# Lizenziert unter der MIT-Lizenz.
# (Vollständiger Lizenztext siehe LICENSE Datei im Repository)
#
# Zweck: Automatisierung von ZIP, Git-Push und GitHub-Releases für Projekte
# ==============================================================================

Set-Location $PSScriptRoot

# --- KONFIGURATION ---
$MOD_NAME = "Mirrored_Devices_Deutsch"
$MOD_DATEIEN = @("About", "Data", "Scripts")
$VERSION_DATEI = Join-Path $PSScriptRoot "Scripts\version.txt"
# ----------------------

$letzteAktion = "Keine (Programm gestartet)"

# --- VERSION BEIM START LADEN ---
if (Test-Path $VERSION_DATEI) {
    $aktuelleVersion = (Get-Content $VERSION_DATEI -Raw).Trim()
} else {
    $aktuelleVersion = "" # Falls Datei nicht existiert
}

while ($true) {
    Clear-Host
    Write-Host "--- GitHub Projekt Manager: $MOD_NAME ---" -ForegroundColor Cyan
    Write-Host "Verzeichnis: $PSScriptRoot" -ForegroundColor Gray
    Write-Host "Letzte Aktion: " -NoNewline
    Write-Host $letzteAktion -ForegroundColor Yellow
    
    Write-Host "Aktive Version (aus Scripts\version.txt): " -NoNewline
    if ($aktuelleVersion) { 
        Write-Host $aktuelleVersion -ForegroundColor Green 
    } else { 
        Write-Host "NICHT GESETZT" -ForegroundColor Red 
    }
    
    Write-Host ""
    Write-Host "Was moechtest du tun?" -ForegroundColor White
    Write-Host "------------------------------------------------"
    Write-Host "[0] Status-Datei    - Kompakte Liste gaeenderter Dateien"
    Write-Host "[1] Pull            - Projektdaten von GitHub laden"
    Write-Host "[2] Push            - Lokale Aenderungen hochladen"
    Write-Host "[3] Status-Zeile    - Detail-Ansicht der Aenderungen"
    Write-Host "[4] ZIP erstellen   - Packt Mod-Dateien in .\zip"
    Write-Host "[5] Release (gh)    - ZIP als neue Version veroeffentlichen"
    Write-Host "[V] Version aendern  - Versionsnummer manuell setzen & speichern"
    Write-Host "[Q] Quit            - Programm beenden"
    Write-Host "------------------------------------------------"
    Write-Host ""

    $eingabe = (Read-Host "-> Auswahl").Trim().ToLower()

    switch ($eingabe) {
        "0" {
            Write-Host "`n--- DATEI STATUS ---" -ForegroundColor Yellow
            git status -s
            $letzteAktion = "Status-Datei geprueft"
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "1" {
            Write-Host "`nFuehre 'git pull' aus..." -ForegroundColor Yellow
            git pull
            $letzteAktion = "Pull ausgefuehrt ($(Get-Date -Format 'HH:mm:ss'))"
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "2" {
            Write-Host "`nBereite Push vor..." -ForegroundColor Yellow
            $msg = Read-Host "Commit-Nachricht (leer lassen fuer Zeitstempel)"
            if (-not $msg) { $msg = "Update $(Get-Date -Format 'dd.MM.yyyy HH:mm')" }
            
            git add .
            git commit -m "$msg"
            git push
            $letzteAktion = "Push: '$msg'"
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "3" {
            Write-Host "`n--- DETAIL STATUS ---" -ForegroundColor Yellow
            git --no-pager diff
            git --no-pager diff --cached
            $letzteAktion = "Status-Zeile geprueft"
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "4" {
            Write-Host "`n--- ZIP ERSTELLUNG ---" -ForegroundColor Yellow
            
            # Falls keine Version da ist, fragen und SPEICHERN
            if (-not $aktuelleVersion) {
                $aktuelleVersion = (Read-Host "Welche Versionsnummer (z.B. 0.0.9)?").Trim()
                if (!(Test-Path (Split-Path $VERSION_DATEI))) { New-Item -ItemType Directory -Path (Split-Path $VERSION_DATEI) -Force | Out-Null }
                $aktuelleVersion | Out-File -FilePath $VERSION_DATEI -Force
            }

            $zipOrdner = Join-Path $PSScriptRoot "zip"
            if (!(Test-Path $zipOrdner)) { New-Item -ItemType Directory -Path $zipOrdner -Force | Out-Null }
            Remove-Item (Join-Path $zipOrdner "$MOD_NAME-*.zip") -ErrorAction SilentlyContinue

            $zipFileName = "$MOD_NAME-$aktuelleVersion.zip"
            $targetPath = Join-Path $zipOrdner $zipFileName
            $vorhandenePfade = $MOD_DATEIEN | Where-Object { Test-Path (Join-Path $PSScriptRoot $_) }

            if ($vorhandenePfade) {
                Compress-Archive -Path $vorhandenePfade -DestinationPath $targetPath -Force
                Write-Host "Erfolgreich erstellt: $zipFileName" -ForegroundColor Green
                $letzteAktion = "ZIP erstellt: $zipFileName"
            }
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "5" {
            if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
                Write-Host "GitHub CLI nicht gefunden!" -ForegroundColor Red
            } else {
                if (-not $aktuelleVersion) { Write-Host "Fehler: Keine Version gesetzt! Bitte erst [4] oder [V] nutzen." -ForegroundColor Red }
                else {
                    $zipPath = Join-Path $PSScriptRoot "zip\$MOD_NAME-$aktuelleVersion.zip"
                    if (Test-Path $zipPath) {
                        $tagName = "v$aktuelleVersion"
                        gh release create $tagName $zipPath --title "Version $aktuelleVersion" --generate-notes
                        $letzteAktion = "Release $tagName veroeffentlicht"
                    } else {
                        Write-Host "Fehler: ZIP nicht gefunden! Bitte erst [4] ausfuehren." -ForegroundColor Red
                    }
                }
            }
            Write-Host "`nDruecke eine Taste..."
            $null = [Console]::ReadKey()
        }

        "v" {
            $neueVersion = (Read-Host "Neue Version festlegen (z.B. 0.1.0)").Trim()
            if ($neueVersion) {
                $aktuelleVersion = $neueVersion
                # Ordner Scripts erstellen falls noetig
                $dir = Split-Path $VERSION_DATEI
                if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
                # In Datei speichern
                $aktuelleVersion | Out-File -FilePath $VERSION_DATEI -Force
                $letzteAktion = "Version auf $aktuelleVersion aktualisiert & gespeichert"
            }
        }

        "q" { return }

        default {
            Write-Host "Ungueltige Auswahl!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}