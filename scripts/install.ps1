Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Repo = if ($env:GUGA_CODEX_REPO) { $env:GUGA_CODEX_REPO } else { "Calculus-Singularity/guga-codex" }
$InstallDir = if ($env:GUGA_CODEX_INSTALL_DIR) { $env:GUGA_CODEX_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "Programs\guga-codex\bin" }
$Tag = if ($env:GUGA_CODEX_VERSION) { $env:GUGA_CODEX_VERSION } else { $null }

$arch = $env:PROCESSOR_ARCHITECTURE
if ($arch -ne "AMD64") {
  throw "Unsupported Windows architecture: $arch. Expected AMD64."
}

$asset = "guga-codex-x86_64-pc-windows-msvc.exe"
if (-not $Tag) {
  $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
  Write-Host "Fetching latest release for $Repo ..."
  $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "guga-codex-installer" }
  $Tag = $release.tag_name
  if ([string]::IsNullOrWhiteSpace($Tag)) {
    throw "Could not detect latest release tag from $apiUrl"
  }
}

$downloadUrl = "https://github.com/$Repo/releases/download/$Tag/$asset"
$tempExe = Join-Path ([System.IO.Path]::GetTempPath()) ("guga-codex-install-" + $PID + ".exe")
$destExe = Join-Path $InstallDir "guga-codex.exe"

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
  Write-Host "Restart your terminal to use guga-codex from PATH."
}

Write-Host "Installed: $destExe"
Write-Host "Run: guga-codex --help"
