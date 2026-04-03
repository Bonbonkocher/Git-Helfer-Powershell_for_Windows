# ==============================================================================
# GIT-HELFER (PowerShell for Windows)
# 
# Copyright (c) 2026 Jens (Bonbonkocher)
# Lizenziert unter der MIT-Lizenz.
# ==============================================================================

Set-Location $PSScriptRoot

# --- PFADE ZU DEN KONFIGURATIONS-DATEIEN ---
$ORDNER_SCRIPTS = Join-Path $PSScriptRoot "Scripts"
$DATEI_VERSION  = Join-Path $ORDNER_SCRIPTS "version.txt"
$DATEI_NAME     = Join-Path $ORDNER_SCRIPTS "name.txt"

# Sicherstellen, dass der Scripts-Ordner existiert
if (!(Test-Path $ORDNER_SCRIPTS)) { New-Item -ItemType Directory -Path $ORDNER_SCRIPTS -Force | Out-Null }

# --- MOD-NAME LADEN ODER FRAGEN ---
if (Test-Path $DATEI_NAME) {
    $MOD_NAME = (Get-Content $DATEI_NAME -Raw).Trim()
} else {
    Write-Host "Kein Mod-Name gefunden!" -ForegroundColor Yellow
    $MOD_NAME = (Read-Host "Wie soll die Mod/ZIP heissen? (z.B. Mein_Mod_Name)").Trim()
    $MOD_NAME | Out-File -FilePath $DATEI_NAME -Encoding utf8 -Force
}

# --- VERSION LADEN ---
if (Test-Path $DATEI_VERSION) {
    $aktuelleVersion = (Get-Content $DATEI_VERSION -Raw).Trim()
} else {
    $aktuelleVersion = ""
}

# Welche Ordner sollen in die ZIP? (Standard fuer Stationeers)
$MOD_DATEIEN = @("About", "Data", "Scripts")

$letzteAktion = "Programm gestartet"

while ($true) {
    Clear-Host
    Write-Host "--- GitHub Projekt Manager ---" -ForegroundColor Cyan
    Write-Host "Projekt-Name: " -NoNewline
    Write-Host $MOD_NAME -ForegroundColor Green
    Write-Host "Version:      " -NoNewline
    if ($aktuelleVersion) { Write-Host $aktuelleVersion -ForegroundColor Green } else { Write-Host "FEHLT" -ForegroundColor Red }
    Write-Host "Letzte Aktion: " -NoNewline
    Write-Host $letzteAktion -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Was moechtest du tun?" -ForegroundColor White
    Write-Host "------------------------------------------------"
    Write-Host "[0] Status-Datei    - Liste geanderter Dateien"
    Write-Host "[1] Pull            - Daten von GitHub laden"
    Write-Host "[2] Push            - Lokale Aenderungen hochladen"
    Write-Host "[3] Status-Zeile    - Detail-Ansicht (Diff)"
    Write-Host "[4] ZIP erstellen   - Nutzt Name & Version"
    Write-Host "[5] Release (gh)    - ZIP hochladen"
    Write-Host "[V] Version aendern - Versionsnummer anpassen"
    Write-Host "[N] Name aendern    - Mod-Namen anpassen"
    Write-Host "[Q] Quit            - Beenden"
    Write-Host "------------------------------------------------"
    Write-Host ""

    $eingabe = (Read-Host "-> Auswahl").Trim().ToLower()

    switch ($eingabe) {
        "0" { 
            Write-Host "`n--- DATEI STATUS ---" -ForegroundColor Yellow
            git status -s; $letzteAktion = "Status geprueft"; $null = [Console]::ReadKey() 
        }
        "1" { 
            Write-Host "`nFuehre 'git pull' aus..." -ForegroundColor Yellow
            git pull; $letzteAktion = "Pull erledigt"; $null = [Console]::ReadKey() 
        }
        "2" {
            Write-Host "`nBereite Push vor..." -ForegroundColor Yellow
            $msg = Read-Host "Commit-Nachricht (leer lassen fuer Zeitstempel)"
            if (-not $msg) { $msg = "Update $(Get-Date -Format 'dd.MM.yyyy HH:mm')" }
            git add .; git commit -m "$msg"; git push
            $letzteAktion = "Push ausgefuehrt"; $null = [Console]::ReadKey()
        }
        "3" { 
            Write-Host "`n--- DETAIL STATUS ---" -ForegroundColor Yellow
            git --no-pager diff; git --no-pager diff --cached; $null = [Console]::ReadKey() 
        }
        "4" {
            Write-Host "`n--- ZIP ERSTELLUNG ---" -ForegroundColor Yellow
            if (-not $aktuelleVersion) {
                $aktuelleVersion = (Read-Host "Version eingeben (z.B. 0.1.0)").Trim()
                $aktuelleVersion | Out-File -FilePath $DATEI_VERSION -Encoding utf8 -Force
            }
            $zipOrdner = Join-Path $PSScriptRoot "zip"
            if (!(Test-Path $zipOrdner)) { New-Item -ItemType Directory -Path $zipOrdner -Force | Out-Null }
            Remove-Item (Join-Path $zipOrdner "$MOD_NAME-*.zip") -ErrorAction SilentlyContinue
            
            $zipFileName = "$MOD_NAME-$aktuelleVersion.zip"
            $targetPath = Join-Path $zipOrdner $zipFileName
            $vorhandenePfade = $MOD_DATEIEN | Where-Object { Test-Path (Join-Path $PSScriptRoot $_) }
            
            Compress-Archive -Path $vorhandenePfade -DestinationPath $targetPath -Force
            $letzteAktion = "ZIP erstellt: $zipFileName"
            Write-Host "Datei erzeugt in .\zip\$zipFileName" -ForegroundColor Green
            $null = [Console]::ReadKey()
        }
        "5" {
            if (!(Get-Command gh -ErrorAction SilentlyContinue)) { Write-Host "gh CLI fehlt!" -ForegroundColor Red }
            elseif (-not $aktuelleVersion) { Write-Host "Bitte erst Version setzen!" -ForegroundColor Red }
            else {
                $zipPath = Join-Path $PSScriptRoot "zip\$MOD_NAME-$aktuelleVersion.zip"
                if (Test-Path $zipPath) {
                    $tagName = "v$aktuelleVersion"
                    gh release create $tagName $zipPath --title "Version $aktuelleVersion" --generate-notes
                    $letzteAktion = "Release $tagName veroeffentlicht"
                } else { Write-Host "ZIP nicht gefunden! Bitte Punkt [4] nutzen." -ForegroundColor Red }
            }
            $null = [Console]::ReadKey()
        }
        "v" {
            $aktuelleVersion = (Read-Host "Neue Version").Trim()
            $aktuelleVersion | Out-File -FilePath $DATEI_VERSION -Encoding utf8 -Force
            $letzteAktion = "Version geandert auf $aktuelleVersion"
        }
        "n" {
            $MOD_NAME = (Read-Host "Neuer Mod-Name").Trim()
            $MOD_NAME | Out-File -FilePath $DATEI_NAME -Encoding utf8 -Force
            $letzteAktion = "Name geandert auf $MOD_NAME"
        }
        "q" { return }
    }
}