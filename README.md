# Scoop Bucket for Senzing SDK Runtime (Unofficial)

This is an **unofficial** Scoop bucket for installing the Senzing SDK Runtime on Windows. This package is not maintained by Senzing Inc.

## Quick Start

### Install Scoop (if needed)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

### Add This Bucket and Install

```powershell
# Add the bucket
scoop bucket add senzingsdk-runtime-unofficial https://github.com/brianmacy/scoop-senzingsdk-runtime-unofficial

# Install Senzing SDK Runtime
scoop install senzingsdk-runtime-unofficial
```

## EULA Acceptance

The Senzing SDK Runtime requires acceptance of the End User License Agreement (EULA) before installation.

### Interactive Acceptance

By default, you will be prompted to accept the EULA during installation:

```powershell
scoop install senzingsdk-runtime-unofficial
# You will be prompted: Do you accept the Senzing EULA? (yes/no)
```

### Non-Interactive Acceptance

For automated installations, you can accept the EULA in advance:

**Option 1: Environment Variable (session only)**
```powershell
$env:SENZING_EULA_ACCEPTED = "yes"
scoop install senzingsdk-runtime-unofficial
```

**Option 2: Scoop Config (persistent)**
```powershell
scoop config SENZING_EULA_ACCEPTED yes
scoop install senzingsdk-runtime-unofficial
```

**EULA Location:** https://senzing.com/software-license-agreement/

## Version Management

### Update to Latest Version

```powershell
scoop update senzingsdk-runtime-unofficial
```

### Install Specific Version

```powershell
scoop install senzingsdk-runtime-unofficial@4.1.0.25279
```

### Check Installed Version

```powershell
scoop info senzingsdk-runtime-unofficial
```

## Post-Install

After installation, the following environment variables are automatically configured:

- **`SENZING_DIR`**: Points to the Senzing installation directory (`$SCOOP\apps\senzingsdk-runtime-unofficial\current\er`)
- **`PATH`**: The `er\lib` directory is added to your PATH

### Verify Installation

```powershell
# Check environment variable
echo $env:SENZING_DIR

# Verify directory structure
dir $env:SENZING_DIR
```

## Troubleshooting

### EULA Not Accepted Error

If you see an error about EULA acceptance:

1. Accept interactively: Re-run `scoop install` and type `yes` when prompted
2. Set environment variable: `$env:SENZING_EULA_ACCEPTED = "yes"`
3. Set scoop config: `scoop config SENZING_EULA_ACCEPTED yes`

### Check Installation Status

```powershell
# List installed apps
scoop list

# Show detailed info
scoop info senzingsdk-runtime-unofficial

# Check environment variables
echo $env:SENZING_DIR
echo $env:PATH
```

### Uninstall

```powershell
scoop uninstall senzingsdk-runtime-unofficial
```

## Maintenance

This bucket is automatically updated via GitHub Actions:

- **Daily Check**: The workflow runs daily at 08:00 UTC to check for new versions
- **Automatic PRs**: When a new version is detected, a pull request is automatically created
- **Manual Trigger**: Maintainers can manually trigger the update workflow

## Architecture

This bucket currently supports:

- **64-bit Windows**: Windows 10/11 and Windows Server 2016+

## Related Projects

- **Homebrew Tap (macOS)**: [brianmacy/homebrew-senzingsdk-runtime-unofficial](https://github.com/brianmacy/homebrew-senzingsdk-runtime-unofficial)

## License

This repository is licensed under the Apache License 2.0. See [LICENSE](LICENSE) file for details.

**Note:** The Senzing SDK Runtime itself is licensed under the [Senzing EULA](https://senzing.com/software-license-agreement/), which you must accept to use the software.

## Disclaimer

This is an **unofficial** package distribution. It is not maintained by Senzing Inc. Use at your own risk.

For official Senzing support and documentation, visit [senzing.com](https://senzing.com/).

## Contributing

Issues and pull requests are welcome! Please feel free to:

- Report bugs or issues with the package installation
- Suggest improvements to the manifest or automation
- Submit updates for new versions (though automated updates should handle this)

## Support

For issues with:

- **This Scoop bucket**: Open an issue in this repository
- **Senzing SDK itself**: Contact Senzing Inc. or visit their official support channels
