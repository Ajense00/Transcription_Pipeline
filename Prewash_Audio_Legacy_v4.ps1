# Prewash_Audio_Legacy_v4.ps1
# Audio cleaning and normalization pipeline using FFmpeg

param (
    [string]$RawAudioPath = "$env:USERPROFILE\OneDrive\Desktop\MSI_BACKUP\Kelly_Case\Raw_Audio",
    [string]$OutputRoot  = "$env:USERPROFILE\OneDrive\Desktop\Transcriptions"
)

$timestamp = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
$outDir = Join-Path $OutputRoot $timestamp
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$logFile = Join-Path $outDir "Audio_Prewash_Log_$timestamp.csv"
"Time,Source,Output,Status" | Out-File $logFile -Encoding UTF8

$ffmpeg = "ffmpeg"
$ffprobe = "ffprobe"

Get-ChildItem $RawAudioPath -Recurse -Include *.mp3,*.m4a,*.wav | ForEach-Object {
    $src = $_.FullName
    $base = [IO.Path]::GetFileNameWithoutExtension($_.Name)
    $out = Join-Path $outDir ($base + "_clean.wav")

    & $ffmpeg -y -i "$src" -ac 1 -ar 48000 -af "loudnorm" "$out" 2>$null

    if (Test-Path $out) {
        "$(Get-Date),$src,$out,OK" | Out-File $logFile -Append
    } else {
        "$(Get-Date),$src,,FAIL" | Out-File $logFile -Append
    }
}