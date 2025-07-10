FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Windows SDK 11
RUN choco install -y windows-sdk-11-version-22H2-all --version=10.0.22621.2 --no-progress --timeout 600

# Install Git, CMake, OpenJDK
RUN choco install -y git cmake openjdk --no-progress

# Set JAVA_HOME
ENV JAVA_HOME="C:\\Program Files\\OpenJDK\\openjdk-17.0.2"
ENV PATH="$Env:PATH;$Env:JAVA_HOME\\bin"

# Download and set up Android Command Line Tools
RUN New-Item -ItemType Directory -Path "C:\\android-sdk\\cmdline-tools" -Force; \
    $url = 'https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip'; \
    $output = 'C:\\cmdline-tools.zip'; \
    Invoke-WebRequest -Uri $url -OutFile $output; \
    Expand-Archive -Path $output -DestinationPath 'C:\\android-sdk\\cmdline-tools'; \
    Move-Item -Path 'C:\\android-sdk\\cmdline-tools\\cmdline-tools' -Destination 'C:\\android-sdk\\cmdline-tools\\latest'; \
    Remove-Item -Path $output -Force

# Set Android SDK environment
ENV ANDROID_HOME="C:\\android-sdk"
ENV PATH="$Env:PATH;$Env:ANDROID_HOME\\cmdline-tools\\latest\\bin;$Env:ANDROID_HOME\\platform-tools"

# Accept licenses and install Android build tools
RUN & "$env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat" --licenses | Out-Null; \
    & "$env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat" "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install MinGW
RUN choco install -y mingw --no-progress

# Add MinGW to PATH
ENV PATH="$Env:PATH;C:\\ProgramData\\chocolatey\\lib\\mingw\\tools\\install\\mingw64\\bin"

# Set workspace
WORKDIR C:\\workspace

# Default to PowerShell
CMD ["powershell"]
