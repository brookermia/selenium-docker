# install-winappdriver.ps1

# Install Chocolatey if it is not already installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));
}

# Install WinAppDriver using Chocolatey
Write-Output "Installing WinAppDriver using Chocolatey"
choco install winappdriver -y

# Wait for the installation to complete
Start-Sleep -Seconds 10

# Verify installation
$winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
if (Test-Path $winAppDriverPath) {
    Write-Output "WinAppDriver installation completed successfully."
    # Optionally, start WinAppDriver to verify it runs correctly
    try {
        Start-Process -FilePath $winAppDriverPath -ArgumentList "/quiet" -NoNewWindow -Wait
        Write-Output "WinAppDriver started successfully."
    } catch {
        Write-Error "Failed to start WinAppDriver."
        throw "Failed to start WinAppDriver."
    }
} else {
    Write-Error "Failed to install WinAppDriver."
    throw "Failed to install WinAppDriver."
}


Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
