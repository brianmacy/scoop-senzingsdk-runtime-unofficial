# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is an unofficial Scoop bucket for Senzing SDK packages. Scoop is a command-line installer for Windows that manages software packages. This repository contains JSON manifest files that define how to install and manage Senzing SDK components.

**Current Packages:**
- `senzingsdk-runtime-unofficial` - Senzing SDK Runtime

**Future Extensibility:**
This bucket can be extended with additional Senzing packages by adding more manifest files:
- `bucket/senzingsdk-tools-unofficial.json` (future)
- `bucket/senzingsdk-dev-unofficial.json` (future)
- etc.

Each manifest file represents a separate installable package.

## Scoop Bucket Structure

Scoop buckets typically contain:
- `bucket/` directory with JSON manifest files (one per application/tool)
- Each manifest defines: version, download URL, checksums, installation steps, environment variables, and shortcuts

## Manifest File Standards

When creating or updating Scoop manifests:
- Use JSON format with proper indentation (4 spaces)
- Include required fields: `version`, `description`, `homepage`, `license`, `architecture`, `url`, `hash`
- Use `$dir` variable for installation directory references
- Test manifests with `scoop install` before committing
- Validate JSON syntax

## Common Commands

Test a manifest locally:
```
scoop install <manifest-file.json>
```

Update checksums in a manifest:
```
scoop checkver <app-name> -u
```

Add this bucket to Scoop (for users):
```
scoop bucket add senzingsdk-runtime-unofficial https://github.com/brianmacy/scoop-senzingsdk-runtime-unofficial
```

## Project Constraints

- Apache 2.0 License (see LICENSE file)
- This is an UNOFFICIAL bucket - not maintained by Senzing Inc.
- Manifests should point to official Senzing distribution URLs where possible

## Implementation Details

### Senzing SDK Distribution

- **S3 Bucket**: `senzing-production-win.s3.amazonaws.com`
- **Filename Pattern**: `senzingsdk_{version}.zip` (underscore separator)
- **Version Format**: 4-part semantic versioning (major.minor.patch.build)
- **Example**: `senzingsdk_4.1.0.25279.zip`

### Manifest Structure

The main manifest (`bucket/senzingsdk-runtime-unofficial.json`) includes:

- **EULA Gate**: Pre-install script checks for acceptance via environment variable or scoop config
- **Environment Setup**: Automatically sets `SENZING_DIR` and adds `er\lib` to PATH
- **Auto-update**: Configured with checkver pattern and autoupdate URL template
- **SHA256 Verification**: Required for all downloads

### Version Management

1. **Manual Check**: Run `bin\checkver.ps1` to check for updates
2. **Manual Update**: Run `bin\checkver.ps1 -Update` to download and update manifest
3. **Automated Updates**: GitHub Actions workflow runs daily at 08:00 UTC

### Testing Procedure

Test locally before pushing:

```powershell
# Add local bucket
scoop bucket add senzing-local C:\path\to\repo

# Test installation with EULA acceptance
$env:SENZING_EULA_ACCEPTED = "yes"
scoop install senzingsdk-runtime-unofficial

# Verify environment
echo $env:SENZING_DIR
dir $env:SENZING_DIR

# Clean up
scoop uninstall senzingsdk-runtime-unofficial
scoop bucket rm senzing-local
```

### Items Requiring Verification

Before the package is production-ready, verify:

1. S3 bucket URL and filename pattern are correct
2. Zip internal structure (may need `extract_dir` setting)
3. Confirm `er/lib` and `er/bin` paths exist in distribution
4. Check for `setupEnv.cmd` or `setupEnv.ps1` scripts
5. Verify if dependencies (OpenSSL, SQLite) are bundled or needed
6. Test with actual Senzing SDK to confirm paths and functionality

### Maintenance Workflow

1. GitHub Actions detects new version on S3
2. Workflow downloads zip and computes SHA256 hash
3. Automated PR is created with version bump
4. Maintainer reviews and merges PR
5. Users update with `scoop update senzingsdk-runtime-unofficial`

### Key Differences from Homebrew Implementation

- **Hash Verification**: Windows version requires SHA256 (macOS skips due to code signing)
- **Environment Setup**: Automatic via Scoop manifest (macOS requires manual sourcing)
- **Dependencies**: Likely bundled in Windows SDK (macOS may require separate packages)
- **S3 Source Tracking**: Not implemented (macOS tracks source for EULA re-prompting)
