$env:ANDROID_HOME = "C:\android-sdk"
$cliPath = "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat"

# Download and unpack command-line tools
New-Item -ItemType Directory -Path "$env:ANDROID_HOME\cmdline-tools" -Force
$zipPath = "$env:TEMP\cmdline-tools.zip"
Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip" -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath "$env:ANDROID_HOME\cmdline-tools"
Move-Item -Path "$env:ANDROID_HOME\cmdline-tools\cmdline-tools" -Destination "$env:ANDROID_HOME\cmdline-tools\latest" -Force
Remove-Item $zipPath

# Simulate license acceptance
$licensesPath = "$env:ANDROID_HOME\licenses"
New-Item -Path $licensesPath -ItemType Directory -Force | Out-Null
Set-Content -Path "$licensesPath\android-sdk-license" -Value "8933bad161af4178b1185d1a37fbf41ea5269c55"
Set-Content -Path "$licensesPath\android-sdk-preview-license" -Value "84831b9409646a918e30573bab4c9c91346d8abd"

# Install components
& $cliPath --sdk_root=$env:ANDROID_HOME "platform-tools" "platforms;android-33" "build-tools;33.0.2"
