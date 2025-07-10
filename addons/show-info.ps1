Write-Host ""
Write-Host "🧰 Windows Android Dev Container Ready" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Java:" (java -version 2>&1)[0]
Write-Host "✅ Git:" (git --version)
Write-Host "✅ CMake:" (cmake --version)[0]
Write-Host "✅ GCC:" (gcc --version)[0]
Write-Host "✅ Android SDK Path: C:\android-sdk"
Write-Host "Use 'sdkmanager.bat --list' to manage Android packages"
Write-Host ""
