$ConfigPath = Join-Path $PSScriptRoot "backup_config.json"
$BackupFolder = Join-Path $PSScriptRoot "backup"

$ConfigJson = Get-Content $ConfigPath -Raw | ConvertFrom-Json
$UserEnter = Read-Host "Enter 1 to export, 2 to import"

foreach ($Item in $ConfigJson) {
    $Module = $Item.Module
    $Folder = $Item.Folder
    $File = $Item.File

    $SourcePath = Join-Path $Folder $File
    $TargetPath = Join-Path (Join-Path $BackupFolder $Module) $File

    if ($UserEnter -eq "1") {
        if (Test-Path $SourcePath) {
            New-Item -ItemType Directory -Path (Split-Path $TargetPath) -Force | Out-Null
            Copy-Item -Path $SourcePath -Destination $TargetPath -Force
        }
    }
    elseif ($UserEnter -eq "2") {
        if (Test-Path $TargetPath) {
            New-Item -ItemType Directory -Path (Split-Path $SourcePath) -Force | Out-Null
            Copy-Item -Path $TargetPath -Destination $SourcePath -Force
        }
    }
}
