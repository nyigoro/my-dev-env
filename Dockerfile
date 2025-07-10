# Use Windows Server Core 2022 as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set shell to PowerShell
SHELL ["powershell", "-Command"]

# Install Chocolatey package manager
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Windows SDK (version 10.0.22621.0 for Windows 11)
RUN choco install -y windows-sdk-10.0 --version=10.0.22621.0

# Install OpenJDK 17 for Android SDK
RUN choco install -y openjdk --version=17.0.2

# Install MinGW-w64 for Linux-compatible cross-compilation
RUN choco install -y mingw

# Install Git and CMake
RUN choco install -y git cmake

# Set up Android SDK
ENV ANDROID_HOME=C:\\android-sdk
RUN New-Item -ItemType Directory -Path $env:ANDROID_HOME -Force; \
    Invoke-WebRequest -Uri https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip -OutFile cmdline-tools.zip; \
    Expand-Archive -Path cmdline-tools.zip -DestinationPath $env:ANDROID_HOME\\cmdline-tools; \
    Move-Item -Path $env:ANDROID_HOME\\cmdline-tools\\cmdline-tools -Destination $env:ANDROID_HOME\\cmdline-tools\\latest; \
    Remove-Item cmdline-tools.zip

# Accept Android SDK licenses and install components
RUN echo y | & "$env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat" --licenses; \
    & "$env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat" "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Update PATH
ENV PATH="%PATH%;%ANDROID_HOME%\\cmdline-tools\\latest\\bin;%ANDROID_HOME%\\platform-tools;C:\\ProgramData\\chocolatey\\lib\\mingw\\tools\\install\\mingw64\\bin"

# Set working directory
WORKDIR C:\\workspace

# Default command
CMD ["cmd.exe"]