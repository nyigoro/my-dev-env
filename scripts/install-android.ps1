# Set paths
$env:ANDROID_HOME = "C:\android-sdk"
$toolsPath = "$env:ANDROID_HOME\cmdline-tools"
$zipPath = "C:\cmdline-tools.zip"
$cliToolsUrl = "https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip"

# Create directory
New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null

# Download cmdline tools
Invoke-WebRequest -Uri $cliToolsUrl -OutFile $zipPath

# Extract
Expand-Archive -Path $zipPath -DestinationPath $toolsPath

# Move to expected 'latest' folder structure
Move-Item -Path "$toolsPath\cmdline-tools" -Destination "$toolsPath\latest"

# Cleanup
Remove-Item -Path $zipPath -Force

# Set SDK Manager path
$cli = "$toolsPath\latest\bin\sdkmanager.bat"

# Accept licenses non-interactively
cmd /c "$cli --licenses < NUL"

# Install core packages
& $cli --sdk_root=$env:ANDROID_HOME `
  "platform-tools" `
  "platforms;android-33" `
  "build-tools;33.0.2"
