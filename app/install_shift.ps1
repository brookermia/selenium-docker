Set-ExecutionPolicy Unrestricted -Scope Process -Force

# Get current timestamp
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

Write-Output "$(Get-Timestamp): Starting Shift installation"

# Ensure the downloads directory exists
if (-Not (Test-Path -Path C:\app\downloads)) {
    Write-Output "$(Get-Timestamp): Downloads directory does not exist. Creating directory."
    New-Item -ItemType Directory -Path C:\app\downloads
}

# Find and install the Shift application
$files = Get-ChildItem -Path C:\app\downloads\Shift-*.exe -ErrorAction SilentlyContinue
if ($files -eq $null) {
    Write-Output "$(Get-Timestamp): No Shift executable found in C:\app\downloads."
    exit 1
}

foreach ($file in $files) {
    Write-Output "$(Get-Timestamp): Found executable: $file"
    try {
        Write-Output "$(Get-Timestamp): Running installer: $file"
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = $file
        $processInfo.Arguments = "/silent"
        $processInfo.RedirectStandardError = $true
        $processInfo.RedirectStandardOutput = $true
        $processInfo.UseShellExecute = $false
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        $process.Start() | Out-Null
        $process.WaitForExit()
        
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        Write-Output "$(Get-Timestamp): Installer stdout: $stdout"
        Write-Output "$(Get-Timestamp): Installer stderr: $stderr"

        if ($process.ExitCode -ne 0) {
            Write-Output "$(Get-Timestamp): Installer exited with code $($process.ExitCode)"
            exit $process.ExitCode
        }

        Write-Output "$(Get-Timestamp): Completed installer: $file"
    } catch {
        Write-Output "$(Get-Timestamp): Error running installer: $file"
        Write-Output $_.Exception.Message
    }
}

Write-Output "$(Get-Timestamp): Finished Shift installation"
