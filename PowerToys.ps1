Set-Location -Path $PSScriptRoot

$configPath = Join-Path $PSScriptRoot "backup_config.json"
$BackupRoot = Join-Path $PSScriptRoot "backup"
if (-not (Test-Path $configPath)) {
    Write-Error "Missing configuration file: $configPath"
    exit
}

$ConfigJson = Get-Content $configPath -Raw | ConvertFrom-Json
$PowerToysRoot = "C:\Users\User\AppData\Local\Microsoft\PowerToys"
$UserEnter = Read-Host "Enter 1 to export, 2 to import"

foreach ($Module in $ConfigJson.PSObject.Properties.Name) {
    $fileList = $ConfigJson.$Module

    foreach ($file in $fileList) {
        if ($Module -eq "Root") {
            $sourcePath = Join-Path $PowerToysRoot $file
            $targetPath = Join-Path $BackupRoot $file
        }
        else {
            $sourceDir = Join-Path $PowerToysRoot $Module
            $targetDir = Join-Path $BackupRoot $Module
            $sourcePath = Join-Path $sourceDir $file
            $targetPath = Join-Path $targetDir $file
        }

        if ($UserEnter -eq "1") {
            if (Test-Path $sourcePath) {
                $null = New-Item -ItemType Directory -Path (Split-Path $targetPath) -Force
                Copy-Item -Path $sourcePath -Destination $targetPath -Force
                Write-Host "Exported $Module/$file"
            }
            else {
                Write-Host "Not found: $Module/$file"
            }
        }
        elseif ($UserEnter -eq "2") {
            if (Test-Path $targetPath) {
                $null = New-Item -ItemType Directory -Path (Split-Path $sourcePath) -Force
                Copy-Item -Path $targetPath -Destination $sourcePath -Force
                Write-Host "Imported $Module/$file"
            }
            else {
                Write-Host "No backup file found: $Module/$file"
            }
        }
    }
}
