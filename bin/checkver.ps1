#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Check for new versions of Senzing SDK Runtime on S3 and optionally update the manifest.

.DESCRIPTION
    This script fetches the S3 bucket listing from Senzing's Windows distribution bucket,
    extracts version numbers from filenames, compares against the current manifest version,
    and optionally updates the manifest with the latest version and SHA256 hash.

.PARAMETER Update
    If specified, downloads the latest version and updates the manifest JSON file.

.EXAMPLE
    .\bin\checkver.ps1
    Check for new versions without updating.

.EXAMPLE
    .\bin\checkver.ps1 -Update
    Check for new versions and update the manifest if a newer version is found.
#>

param(
    [switch]$Update
)

$ErrorActionPreference = 'Stop'

# Configuration
$S3BucketUrl = 'https://senzing-production-win.s3.amazonaws.com/'
$ManifestPath = Join-Path $PSScriptRoot '..' 'bucket' 'senzingsdk-runtime-unofficial.json'
$VersionRegex = 'SenzingSDK_([\d.]+)\.zip'

Write-Host "Checking for Senzing SDK Runtime updates..." -ForegroundColor Cyan

# Fetch S3 bucket listing
try {
    Write-Host "Fetching S3 bucket listing from: $S3BucketUrl"
    $response = Invoke-RestMethod -Uri $S3BucketUrl -Method Get
} catch {
    Write-Error "Failed to fetch S3 bucket listing: $_"
    exit 1
}

# Extract versions from XML
$versions = @()
$response.ListBucketResult.Contents | ForEach-Object {
    if ($_.Key -match $VersionRegex) {
        $version = $matches[1]
        # Validate it's a 4-part version number
        if ($version -match '^\d+\.\d+\.\d+\.\d+$') {
            $versions += [PSCustomObject]@{
                Version = [Version]$version
                VersionString = $version
                Key = $_.Key
            }
        }
    }
}

if ($versions.Count -eq 0) {
    Write-Error "No valid versions found in S3 bucket"
    exit 1
}

# Sort and get latest version
$latestVersion = ($versions | Sort-Object -Property Version -Descending)[0]
Write-Host "Latest version found: $($latestVersion.VersionString)" -ForegroundColor Green

# Read current manifest version
try {
    $manifest = Get-Content -Path $ManifestPath -Raw | ConvertFrom-Json
    $currentVersion = $manifest.version
    Write-Host "Current manifest version: $currentVersion"
} catch {
    Write-Error "Failed to read manifest file: $_"
    exit 1
}

# Compare versions
if ($currentVersion -eq '0.0.0.0') {
    Write-Host "Manifest has placeholder version, update needed" -ForegroundColor Yellow
    $needsUpdate = $true
} elseif ([Version]$currentVersion -lt $latestVersion.Version) {
    Write-Host "New version available: $($latestVersion.VersionString) > $currentVersion" -ForegroundColor Yellow
    $needsUpdate = $true
} else {
    Write-Host "Manifest is up to date" -ForegroundColor Green
    $needsUpdate = $false
}

if (-not $needsUpdate) {
    exit 0
}

if (-not $Update) {
    Write-Host ""
    Write-Host "Run with -Update flag to update the manifest" -ForegroundColor Cyan
    exit 0
}

# Download and hash the latest version
Write-Host ""
Write-Host "Updating manifest to version $($latestVersion.VersionString)..." -ForegroundColor Cyan

$downloadUrl = "https://senzing-production-win.s3.amazonaws.com/$($latestVersion.Key)"
$tempFile = Join-Path $env:TEMP "SenzingSDK_$($latestVersion.VersionString).zip"

try {
    Write-Host "Downloading: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -UseBasicParsing

    Write-Host "Computing SHA256 hash..."
    $hash = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash.ToLower()
    Write-Host "SHA256: $hash" -ForegroundColor Green

    # Update manifest
    $manifest.version = $latestVersion.VersionString
    $manifest.architecture.'64bit'.hash = $hash

    # Write updated manifest
    $manifestJson = $manifest | ConvertTo-Json -Depth 10
    Set-Content -Path $ManifestPath -Value $manifestJson -Encoding UTF8

    Write-Host ""
    Write-Host "Manifest updated successfully!" -ForegroundColor Green
    Write-Host "Version: $($latestVersion.VersionString)" -ForegroundColor Green
    Write-Host "Hash: $hash" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Review the changes: git diff $ManifestPath"
    Write-Host "  2. Test the installation locally"
    Write-Host "  3. Commit and push when ready"

} catch {
    Write-Error "Failed to download or update manifest: $_"
    exit 1
} finally {
    # Clean up temp file
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
    }
}
