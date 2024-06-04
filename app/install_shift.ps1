
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

try {
    $installerPath = ".\downloads\Shift-122.2.0-Production.exe"

    if (-not (Test-Path $installerPath)) {
        Write-Output "$(Get-Timestamp): Installer not found at $installerPath"
        exit 1
    }

    $argument = "$installerPath /silent"
    Write-Output "$(Get-Timestamp): Running installer: $installerPath"
    
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "cmd.exe"
    $processInfo.Arguments = "/c $argument"
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

    Write-Output "$(Get-Timestamp): Completed installer: $installerPath"
} catch {
    Write-Output "$(Get-Timestamp): Error running installer: $installerPath"
    Write-Output $_.Exception.Message
}
