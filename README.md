# Scoop Bucket for Senzing SDK Runtime (Unofficial)

This is an **unofficial** Scoop bucket for installing the Senzing SDK Runtime on Windows. This package is not maintained by Senzing Inc.

## Quick Start

### Install Scoop (if needed)

**PowerShell (Recommended):**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

**Command Prompt (cmd.exe):**

```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh'))" && SET "PATH=%USERPROFILE%\scoop\shims;%PATH%"
```

### Add This Bucket and Install

**PowerShell:**

```powershell
# Add the bucket
scoop bucket add senzingsdk-runtime-unofficial https://github.com/brianmacy/scoop-senzingsdk-runtime-unofficial

# Install Senzing SDK Runtime
scoop install senzingsdk-runtime-unofficial
```

**Command Prompt (cmd.exe):**

```cmd
REM Add the bucket
scoop bucket add senzingsdk-runtime-unofficial https://github.com/brianmacy/scoop-senzingsdk-runtime-unofficial

REM Install Senzing SDK Runtime
scoop install senzingsdk-runtime-unofficial
```

## EULA Acceptance

The Senzing SDK Runtime requires acceptance of the End User License Agreement (EULA) before installation.

### Interactive Acceptance

By default, you will be prompted to accept the EULA during installation:

**PowerShell / Command Prompt:**
```
scoop install senzingsdk-runtime-unofficial
# You will be prompted: Do you accept the Senzing EULA? (yes/no)
```

### Non-Interactive Acceptance

For automated installations, you can accept the EULA in advance:

**Option 1: Environment Variable (session only)**

PowerShell:
```powershell
$env:SENZING_EULA_ACCEPTED = "yes"
scoop install senzingsdk-runtime-unofficial
```

Command Prompt:
```cmd
set SENZING_EULA_ACCEPTED=yes
scoop install senzingsdk-runtime-unofficial
```

**Option 2: Scoop Config (persistent)**

PowerShell / Command Prompt:
```
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
- **`PATH`**: The `er\lib` directory is added to your PATH for DLL access

### Verify Installation

**PowerShell:**
```powershell
# Check environment variable
echo $env:SENZING_DIR
# Output: C:\Users\<YourName>\scoop\apps\senzingsdk-runtime-unofficial\current\er

# Verify directory structure
dir $env:SENZING_DIR
```

**Command Prompt:**
```cmd
REM Check environment variable
echo %SENZING_DIR%
REM Output: C:\Users\<YourName>\scoop\apps\senzingsdk-runtime-unofficial\current\er

REM Verify directory structure
dir %SENZING_DIR%
```

### What's Included

The Senzing SDK Runtime includes:

- **`bin/`**: Executables including `sqlite3.exe`
- **`lib/`**: Core DLLs (Sz.dll, g2*.dll, etc.) and dependencies (OpenSSL, SQLite)
- **`sdk/`**: SDKs for C, Java, and .NET
  - `c/`: C header files (`libSz.h`, etc.)
  - `java/`: Java JARs (`sz-sdk.jar`, javadoc, sources)
  - `dotnet/`: .NET NuGet package
- **`etc/`**: Configuration files (`g2config.json`, `sz_engine_config.ini`)
- **`resources/`**: Templates and database schemas (SQLite, PostgreSQL, MySQL, MSSQL, Oracle)
- **`var/sqldb/`**: Default SQLite database (`G2C.db`)
- **`data/`**: Address parsing and name data models

## Using the SDK

### Directory Structure

```
$env:SENZING_DIR/
├── bin/              # Executables
├── lib/              # DLLs (on PATH)
├── sdk/              # Development SDKs
│   ├── c/           # C headers
│   ├── java/        # Java JARs
│   └── dotnet/      # .NET package
├── etc/              # Configuration
├── resources/        # Templates & schemas
├── var/sqldb/        # SQLite database
└── data/             # Data models
```

### Configuration

The main configuration file is located at:

PowerShell: `$env:SENZING_DIR\etc\sz_engine_config.ini`
Command Prompt: `%SENZING_DIR%\etc\sz_engine_config.ini`

This file controls database connections, resource paths, and engine settings.

### Using with C/C++

```c
#include "libSz.h"

// Link against: Sz.lib
// Ensure $env:SENZING_DIR\lib is in PATH for runtime DLLs
```

Header files are in: `$env:SENZING_DIR\sdk\c\`

### Using with Java

Add the SDK to your classpath:

**PowerShell:**
```powershell
$env:CLASSPATH = "$env:SENZING_DIR\sdk\java\sz-sdk.jar;$env:CLASSPATH"
```

**Command Prompt:**
```cmd
set CLASSPATH=%SENZING_DIR%\sdk\java\sz-sdk.jar;%CLASSPATH%
```

Or in your build tool (Maven, Gradle):
```xml
<dependency>
  <systemPath>${env.SENZING_DIR}/sdk/java/sz-sdk.jar</systemPath>
</dependency>
```

### Using with .NET

Install the NuGet package from the SDK:

**PowerShell:**
```powershell
cd $env:SENZING_DIR\sdk\dotnet
# Extract and reference Senzing.Sdk.4.x.x.nupkg in your project
```

**Command Prompt:**
```cmd
cd %SENZING_DIR%\sdk\dotnet
REM Extract and reference Senzing.Sdk.4.x.x.nupkg in your project
```

Or via NuGet Package Manager:
```powershell
Install-Package Senzing.Sdk -Source "$env:SENZING_DIR\sdk\dotnet"
```

### Using with Python

If you have the Senzing Python SDK installed, ensure the runtime DLLs are accessible:

```python
import os
os.environ['PATH'] = os.path.join(os.environ['SENZING_DIR'], 'lib') + ';' + os.environ['PATH']

from senzing import SzEngine
# Your code here
```

### Database Setup

The SDK includes database schemas for multiple databases:

**PowerShell:**
```powershell
# SQLite (default - already included)
$env:SENZING_DIR\var\sqldb\G2C.db

# PostgreSQL schema
$env:SENZING_DIR\resources\schema\szcore-schema-postgresql-create.sql

# MySQL schema
$env:SENZING_DIR\resources\schema\szcore-schema-mysql-create.sql

# MSSQL schema
$env:SENZING_DIR\resources\schema\szcore-schema-mssql-create.sql
```

**Command Prompt:**
```cmd
REM SQLite (default - already included)
%SENZING_DIR%\var\sqldb\G2C.db

REM PostgreSQL schema
%SENZING_DIR%\resources\schema\szcore-schema-postgresql-create.sql

REM MySQL schema
%SENZING_DIR%\resources\schema\szcore-schema-mysql-create.sql

REM MSSQL schema
%SENZING_DIR%\resources\schema\szcore-schema-mssql-create.sql
```

### Testing Your Installation

Test that the DLLs are accessible:

**PowerShell:**
```powershell
# Check if SQLite executable works
& "$env:SENZING_DIR\bin\sqlite3.exe" --version

# Verify DLLs are loadable
Test-Path "$env:SENZING_DIR\lib\Sz.dll"

# Check configuration file exists
Get-Content "$env:SENZING_DIR\etc\sz_engine_config.ini"
```

**Command Prompt:**
```cmd
REM Check if SQLite executable works
"%SENZING_DIR%\bin\sqlite3.exe" --version

REM Verify DLLs exist
dir "%SENZING_DIR%\lib\Sz.dll"

REM Check configuration file exists
type "%SENZING_DIR%\etc\sz_engine_config.ini"
```

### Common Use Cases

**1. Entity Resolution Application Development**
- Include C headers or Java/C# SDKs in your project
- Configure database connection in `sz_engine_config.ini`
- Link against runtime DLLs

**2. Data Analysis with SQLite**
- Use the included SQLite database at:
  - PowerShell: `$env:SENZING_DIR\var\sqldb\G2C.db`
  - Command Prompt: `%SENZING_DIR%\var\sqldb\G2C.db`
- Query with `sqlite3.exe` or your preferred SQLite tool

**3. Integration with Enterprise Databases**
- Use provided SQL schemas in `resources/schema/`
- Update `sz_engine_config.ini` with your database connection string

## Troubleshooting

### EULA Not Accepted Error

If you see an error about EULA acceptance:

1. Accept interactively: Re-run `scoop install` and type `yes` when prompted
2. Set environment variable:
   - PowerShell: `$env:SENZING_EULA_ACCEPTED = "yes"`
   - Command Prompt: `set SENZING_EULA_ACCEPTED=yes`
3. Set scoop config: `scoop config SENZING_EULA_ACCEPTED yes`

### Check Installation Status

**PowerShell:**
```powershell
# List installed apps
scoop list

# Show detailed info (version, install path, etc.)
scoop info senzingsdk-runtime-unofficial

# Check environment variables
echo $env:SENZING_DIR
$env:PATH -split ';' | Select-String 'senzing'

# Verify DLLs are in PATH
where.exe Sz.dll
```

**Command Prompt:**
```cmd
REM List installed apps
scoop list

REM Show detailed info (version, install path, etc.)
scoop info senzingsdk-runtime-unofficial

REM Check environment variables
echo %SENZING_DIR%
echo %PATH%

REM Verify DLLs are in PATH
where Sz.dll
```

### Installation Fails or Gets Stuck

If installation fails:

**PowerShell / Command Prompt:**
```
# Clean up failed installation
scoop uninstall senzingsdk-runtime-unofficial
scoop cache rm senzingsdk-runtime-unofficial

# Clear cache and retry
scoop install senzingsdk-runtime-unofficial
```

### "File not found" or DLL Errors

If you get DLL loading errors:

1. Verify PATH is set correctly:

   PowerShell:
   ```powershell
   $env:PATH -split ';' | Select-String 'senzing'
   ```

   Command Prompt:
   ```cmd
   echo %PATH% | findstr /i senzing
   ```

2. Restart your terminal/IDE to pick up new environment variables

3. Check DLLs exist:

   PowerShell:
   ```powershell
   dir $env:SENZING_DIR\lib\*.dll
   ```

   Command Prompt:
   ```cmd
   dir %SENZING_DIR%\lib\*.dll
   ```

### Uninstall

**PowerShell / Command Prompt:**
```
# Uninstall the package
scoop uninstall senzingsdk-runtime-unofficial

# Remove the bucket (optional)
scoop bucket rm senzingsdk-runtime-unofficial
```

## Automatic Updates

This bucket is automatically maintained via GitHub Actions:

- **Hourly Checks**: The workflow runs every hour to check for new SDK versions
- **Automatic Updates**: When a new version is detected, it's automatically committed to the repository
- **Zero Maintenance**: No manual intervention required - updates happen automatically
- **Update Frequency**: Typically within 1 hour of Senzing releasing a new version

To get the latest version:

**PowerShell / Command Prompt:**
```
scoop update  # Update bucket metadata
scoop update senzingsdk-runtime-unofficial  # Update the package
```

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
