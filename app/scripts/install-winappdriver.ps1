# install-winappdriver.ps1

# Install WinAppDriver using Chocolatey
Write-Output "Installing WinAppDriver using Chocolatey"
choco install winappdriver -y

# Verify installation
if (Get-Command "WinAppDriver.exe" -ErrorAction SilentlyContinue) {
    Write-Output "WinAppDriver installation completed successfully."
} else {
    Write-Error "Failed to install WinAppDriver."
    throw "Failed to install WinAppDriver."
}

Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
