# Use Windows Server Core base
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Use native PowerShell shell
SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# Copy PowerShell install scripts into the container
COPY scripts/ C:/scripts/

# Run each install script
RUN C:/scripts/install-choco.ps1
RUN C:/scripts/install-sdk.ps1
RUN C:/scripts/install-tools.ps1
RUN C:/scripts/install-android.ps1
RUN C:/scripts/install-mingw.ps1

# Set Environment Variables
ENV JAVA_HOME="C:\\Program Files\\OpenJDK\\jdk-22.0.2"
ENV ANDROID_HOME="C:\\android-sdk"
ENV PATH="C:\\Program Files\\OpenJDK\\jdk-22.0.2\\bin;C:\\android-sdk\\cmdline-tools\\latest\\bin;C:\\android-sdk\\platform-tools;C:\\ProgramData\\chocolatey\\lib\\mingw\\tools\\install\\mingw64\\bin;%PATH%"

# Set working directory
WORKDIR C:/workspace

# Launch shell
CMD ["powershell.exe"]
