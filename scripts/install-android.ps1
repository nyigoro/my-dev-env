New-Item -ItemType Directory -Path "C:\android-sdk\cmdline-tools" -Force
$zipPath = "C:\cmdline-tools.zip"
$uri = "https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip"
Invoke-WebRequest -Uri $uri -OutFile $zipPath -UseBasicParsing

if (!(Test-Path $zipPath)) {
    throw "Android CLI tools download failed."
}

Expand-Archive -Path $zipPath -DestinationPath "C:\android-sdk\cmdline-tools"
Move-Item -Path "C:\android-sdk\cmdline-tools\cmdline-tools" -Destination "C:\android-sdk\cmdline-tools\latest"
Remove-Item -Path $zipPath -Force

& "C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat" --licenses | Out-Null
& "C:\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat" "platform-tools" "platforms;android-33" "build-tools;33.0.2"
