$env:ANDROID_HOME = "C:\android-sdk"
$cli = "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat"
& $cli --sdk_root=$env:ANDROID_HOME "ndk;25.2.9519653"
