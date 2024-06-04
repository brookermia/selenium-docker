# Get current timestamp
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

Write-Output "$(Get-Timestamp): Starting script"

# Start WinAppDriver
Write-Output "$(Get-Timestamp): Starting WinAppDriver"
Start-Process -NoNewWindow -FilePath "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"

# Check for Developer Mode
Write-Output "$(Get-Timestamp): Checking Developer Mode"
$developerModeEnabled = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue
if ($null -eq $developerModeEnabled) {
    Write-Output "$(Get-Timestamp): Developer Mode is not enabled. This may cause issues."
} else {
    Write-Output "$(Get-Timestamp): Developer Mode is enabled."
}

# Start Selenium test
Write-Output "$(Get-Timestamp): Starting Selenium test"

# List common paths for dotnet.exe
$possibleDotnetPaths = @(
    "C:\Program Files\dotnet\dotnet.exe",
    "C:\Program Files (x86)\dotnet\dotnet.exe",
    "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe",
    "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
)

$dotnetPath = $null
foreach ($path in $possibleDotnetPaths) {
    if (Test-Path $path) {
        $dotnetPath = $path
        break
    }
}

if ($null -eq $dotnetPath) {
    Write-Output "$(Get-Timestamp): dotnet.exe not found in common paths."
    exit 1
}

Write-Output "$(Get-Timestamp): Using dotnet path: $dotnetPath"


Write-Output "$(Get-Timestamp): Running the seleniumdocker.dll file."
if ($args[0] -eq "--headless") {
    $result = Start-Process -NoNewWindow -FilePath $dotnetPath -ArgumentList "SeleniumDocker.dll --headless" -Wait -PassThru
} else {
    $result = Start-Process -NoNewWindow -FilePath $dotnetPath -ArgumentList "SeleniumDocker.dll" -Wait -PassThru
}

if ($result.ExitCode -eq 0) {
    Write-Output "$(Get-Timestamp): Tests passed successfully."
} else {
    Write-Output "$(Get-Timestamp): Tests failed with exit code $($result.ExitCode)."
}

# Wait indefinitely to keep the container running
Write-Output "$(Get-Timestamp): Script finished. Keeping container alive."
Start-Sleep -Seconds 86400
