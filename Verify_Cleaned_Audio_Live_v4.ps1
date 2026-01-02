# Verify_Cleaned_Audio_Live_v4.ps1
# Live verification of cleaned WAV files

param (
    [string]$WatchPath = "$env:USERPROFILE\OneDrive\Desktop\Transcriptions",
    [string]$Report = "$env:USERPROFILE\OneDrive\Desktop\Verify_Live_Report.csv"
)

if (!(Test-Path $Report)) {
    "Time,FilePath,DurationSec,Status" | Out-File $Report -Encoding UTF8
}

$ffprobe = "ffprobe"

function VerifyFile($file) {
    $dur = & $ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>$null
    if ($dur -and [double]$dur -gt 2) {
        "$(Get-Date),$file,$dur,OK" | Out-File $Report -Append
    } else {
        "$(Get-Date),$file,$dur,BAD" | Out-File $Report -Append
    }
}

Get-ChildItem $WatchPath -Recurse -Filter *.wav | ForEach-Object {
    VerifyFile $_.FullName
}

$fsw = New-Object IO.FileSystemWatcher $WatchPath, "*.wav"
$fsw.IncludeSubdirectories = $true
$fsw.EnableRaisingEvents = $true

Register-ObjectEvent $fsw Created -Action {
    Start-Sleep -Seconds 1
    VerifyFile $Event.SourceEventArgs.FullPath
}

Write-Host "Live verification running. Press Ctrl+C to stop."
while ($true) { Start-Sleep 5 }