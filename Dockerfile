FROM mcr.microsoft.com/windows/servercore:ltsc2022
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install -y windows-sdk-11-version-22H2-all --version=10.0.22621.2 --no-progress --retry --timeout 600 || \
    choco install -y windows-sdk-11-version-22H2-all --version=10.0.22621.2 --no进度
RUN choco install -y git cmake openjdk --no-progress
ENV JAVA_HOME="C:\\Program Files\\OpenJDK\\openjdk-17.0.2"
ENV PATH="${PATH};${JAVA_HOME}\\bin"
RUN mkdir -p "C:\\android-sdk\\cmdline-tools"; \
    $url = 'https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip'; \
    $output = 'C:\\cmdline-tools.zip'; \
    Invoke-WebRequest -Uri $url -OutFile $output; \
    Expand-Archive -Path $output -DestinationPath 'C:\\android-sdk\\cmdline-tools'; \
    Move-Item -Path 'C:\\android-sdk\\cmdline-tools\\cmdline-tools' -Destination 'C:\\android-sdk\\cmdline-tools\\latest'; \
    Remove-Item -Path $output
ENV ANDROID_HOME="C:\\android-sdk"
ENV PATH="${PATH};${ANDROID_HOME}\\cmdline-tools\\latest\\bin;${ANDROID_HOME}\\platform-tools"
RUN & $env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat --licenses; \
    & $env:ANDROID_HOME\\cmdline-tools\\latest\\bin\\sdkmanager.bat "platform-tools" "platforms;android-33" "build-tools;33.0.2"
RUN choco install -y mingw --no-progress
ENV PATH="${PATH};C:\\ProgramData\\chocolatey\\lib\\mingw\\tools\\install\\mingw64\\bin"
WORKDIR C:\\workspace
CMD ["powershell"]
