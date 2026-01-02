# CountCleanedWavs.ps1
param (
    [string]$Path = "$env:USERPROFILE\OneDrive\Desktop\Transcriptions"
)

(Get-ChildItem $Path -Recurse -Filter *.wav -ErrorAction SilentlyContinue).Count