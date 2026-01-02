# Prewash_LiveMonitor.ps1
# Displays live count of cleaned WAV files

param (
    [string]$Path = "$env:USERPROFILE\OneDrive\Desktop\Transcriptions"
)

while ($true) {
    $files = Get-ChildItem $Path -Recurse -Filter *.wav -ErrorAction SilentlyContinue
    $count = $files.Count
    $size = "{0:N2}" -f (($files | Measure-Object Length -Sum).Sum / 1GB)
    Write-Host "[$(Get-Date -Format HH:mm:ss)] Files cleaned: $count | Size: $size GB"
    Start-Sleep 10
}