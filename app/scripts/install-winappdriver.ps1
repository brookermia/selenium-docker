# install-winappdriver.ps1

$downloadUrl = "https://github.com/microsoft/WinAppDriver/releases/download/v1.2.99/WindowsApplicationDriver-1.2.99-win-x86.exe"
$destinationPath = "C:\WindowsApplicationDriver.exe"

Write-Output "Downloading WinAppDriver from $downloadUrl"
Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

if (Test-Path $destinationPath) {
    Write-Output "Downloaded WinAppDriver to $destinationPath"
    Start-Process msiexec.exe -ArgumentList "/i $destinationPath /quiet /norestart" -NoNewWindow -Wait
    Write-Output "WinAppDriver installation completed successfully."
} else {
    Write-Error "Failed to download WinAppDriver."
    throw "Failed to download WinAppDriver."
}

Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
