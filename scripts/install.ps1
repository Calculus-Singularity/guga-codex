Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Repo = if ($env:GUGUGAGA_REPO) { $env:GUGUGAGA_REPO } else { "Calculus-Singularity/gugugaga" }
$InstallDir = if ($env:GUGUGAGA_INSTALL_DIR) { $env:GUGUGAGA_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "Programs\gugugaga\bin" }
$Tag = if ($env:GUGUGAGA_VERSION) { $env:GUGUGAGA_VERSION } else { $null }

$arch = $env:PROCESSOR_ARCHITECTURE
if ($arch -ne "AMD64") {
  throw "Unsupported Windows architecture: $arch. Expected AMD64."
}

$asset = "gugugaga-x86_64-pc-windows-msvc.exe"
if (-not $Tag) {
  $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
  Write-Host "Fetching latest release for $Repo ..."
  $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "gugugaga-installer" }
  $Tag = $release.tag_name
  if ([string]::IsNullOrWhiteSpace($Tag)) {
    throw "Could not detect latest release tag from $apiUrl"
  }
}

$downloadUrl = "https://github.com/$Repo/releases/download/$Tag/$asset"
$tempExe = Join-Path ([System.IO.Path]::GetTempPath()) ("gugugaga-install-" + $PID + ".exe")
$destExe = Join-Path $InstallDir "gugugaga.exe"

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

Write-Host "Downloading $asset ($Tag) ..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe
Move-Item -Force -Path $tempExe -Destination $destExe

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $userPath) {
  $userPath = ""
}

$paths = $userPath.Split(";") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
if (-not ($paths -contains $InstallDir)) {
  $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $InstallDir } else { "$userPath;$InstallDir" }
  [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
  Write-Host "Added $InstallDir to your User PATH."
  Write-Host "Restart your terminal to use gugugaga from PATH."
}

Write-Host "Installed: $destExe"
Write-Host "Run: gugugaga --help"
