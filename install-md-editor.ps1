# Markdown Editor Windows Installer
$ErrorActionPreference = 'Stop'

$AppName = 'Markdown Editor'
$Version = '0.4.3'

$WinX64Url = 'https://github.com/wmasfoe/homebrew-tap/releases/download/md-editor-v0.4.3/Markdown.Editor_0.4.3_x64-setup.exe'
$WinX64Sha256 = ''

$WinArm64Url = ''
$WinArm64Sha256 = ''

function Log-Info($msg) {
    Write-Host "md-editor install: $msg" -ForegroundColor Cyan
}

function Fail-Install($msg) {
    Write-Error "md-editor install error: $msg"
    exit 1
}

$arch = $env:PROCESSOR_ARCHITECTURE
$downloadUrl = ''
$expectedSha = ''

switch ($arch) {
    'AMD64' {
        $downloadUrl = $WinX64Url
        $expectedSha = $WinX64Sha256
    }
    'ARM64' {
        if ($WinArm64Url) {
            $downloadUrl = $WinArm64Url
            $expectedSha = $WinArm64Sha256
        } else {
            # Fallback to x64 on Windows 11 ARM via emulation if ARM64 native package is not provided
            $downloadUrl = $WinX64Url
            $expectedSha = $WinX64Sha256
        }
    }
    default {
        Fail-Install "Unsupported processor architecture: $arch"
    }
}

if (-not $downloadUrl) {
    Fail-Install "Download URL for Windows ($arch) is not configured."
}

$tempDir = [System.IO.Path]::GetTempPath()
$installerPath = Join-Path $tempDir "md-editor-setup-$Version.exe"

try {
    Log-Info "Downloading $AppName $Version for Windows ($arch)..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing

    if ($expectedSha) {
        Log-Info "Verifying SHA256 hash..."
        $actualSha = (Get-FileHash -Path $installerPath -Algorithm SHA256).Hash.ToLower()
        if ($actualSha -ne $expectedSha) {
            Fail-Install "SHA256 hash mismatch: expected $expectedSha, got $actualSha"
        }
    }

    Log-Info "Running silent installation..."
    $process = Start-Process -FilePath $installerPath -ArgumentList "/S" -PassThru -Wait
    if ($process.ExitCode -ne 0) {
        Fail-Install "Installer exited with code $($process.ExitCode)"
    }

    Log-Info "$AppName $Version has been successfully installed!"
}
finally {
    if (Test-Path $installerPath) {
        Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
    }
}
