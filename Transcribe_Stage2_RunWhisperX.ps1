# Transcribe_Stage2_RunWhisperX.ps1
# Runs WhisperX transcription stage

param (
    [string]$AudioPath = "$env:USERPROFILE\OneDrive\Desktop\Transcriptions",
    [string]$OutPath   = "$env:USERPROFILE\OneDrive\Desktop\WhisperX_Output"
)

New-Item -ItemType Directory -Path $OutPath -Force | Out-Null

python -m whisperx "$AudioPath" --device cuda --output_dir "$OutPath" --diarize