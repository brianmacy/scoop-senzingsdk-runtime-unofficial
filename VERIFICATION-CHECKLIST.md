# Verification Checklist

This document lists items that need to be verified before the Scoop bucket is production-ready. These items cannot be determined without access to the actual Senzing SDK Windows distribution.

## Critical Verification Items

### 1. S3 Bucket URL ✅ VERIFIED
- **Current**: `senzing-production-win.s3.amazonaws.com`
- **Status**: Confirmed correct via direct download

### 2. Filename Pattern ✅ VERIFIED & FIXED
- **Actual**: `SenzingSDK_{version}.zip` (capital S, D, K)
- **Example**: `SenzingSDK_4.2.0.26023.zip`
- **Regex**: `SenzingSDK_([\d.]+)\.zip`
- **Status**: Fixed in manifest, checkver.ps1, and workflow

### 3. Zip Internal Structure ✅ VERIFIED & FIXED
- **Structure**: Has top-level `senzing/` directory
- **Action Taken**: Added `"extract_dir": "senzing"` to manifest and autoupdate
- **Status**: After extraction, Scoop will strip the `senzing/` directory

### 4. Directory Layout ✅ VERIFIED
- **Confirmed Structure**:
  ```
  senzing/
    er/
      lib/      (DLLs including OpenSSL and SQLite)
      bin/      (executables like sqlite3.exe)
      sdk/      (Java, C, .NET SDKs)
      etc/      (configuration files)
      resources/ (templates and schemas)
      var/      (database files)
  ```
- **Status**: `env_add_path` and `env_set` in manifest are correct

### 5. setupEnv Script ✅ VERIFIED - NOT SUITABLE
- **Exists**: Yes, at `senzing/er/setupEnv.bat`
- **Contents**: Hardcodes `SENZING_ROOT=%CD:~0,2%\senzing` (C:\senzing or D:\senzing)
- **Decision**: Do NOT reference it; Scoop manifest handles env vars properly with `$dir`
- **Status**: Not referenced in manifest (correct approach)

### 6. Dependencies ✅ VERIFIED - ALL BUNDLED
- **OpenSSL**: Bundled (`libcrypto-3-x64.dll`, `libssl-3-x64.dll` in `er/lib/`)
- **SQLite**: Bundled (`sqlite3.dll` in `er/lib/`, `sqlite3.exe` in `er/bin/`)
- **Decision**: No dependencies needed - everything is self-contained
- **Status**: No `depends` field in manifest (correct)

### 7. Initial Version and Hash ❌ MUST BE POPULATED
- **Current**: Version `0.0.0.0` with empty hash (placeholder)
- **Action**: Run `bin\checkver.ps1 -Update` to populate
- **Alternative**: Manually download latest version and compute SHA256

```powershell
# Populate version and hash
.\bin\checkver.ps1 -Update
```

### 8. 32-bit Support ✅ CONFIRMED - NOT AVAILABLE
- **Status**: Senzing does not provide 32-bit Windows builds
- **Current**: Only 64-bit architecture configured (correct)

## Testing Procedure

After verification items are addressed, test on a Windows machine:

### Local Testing

```powershell
# 1. Clone repository
git clone https://github.com/brianmacy/scoop-senzingsdk-runtime-unofficial.git
cd scoop-senzingsdk-runtime-unofficial

# 2. Populate version and hash
.\bin\checkver.ps1 -Update

# 3. Add local bucket
scoop bucket add senzing-local .

# 4. Test installation with EULA acceptance
$env:SENZING_EULA_ACCEPTED = "yes"
scoop install senzingsdk-runtime-unofficial

# 5. Verify installation
scoop info senzingsdk-runtime-unofficial
echo $env:SENZING_DIR
dir $env:SENZING_DIR

# 6. Check PATH
$env:PATH -split ';' | Select-String 'senzing'

# 7. Test EULA prompt (interactive)
scoop uninstall senzingsdk-runtime-unofficial
Remove-Item Env:\SENZING_EULA_ACCEPTED
scoop install senzingsdk-runtime-unofficial
# Should prompt for EULA acceptance

# 8. Test persistent EULA config
scoop uninstall senzingsdk-runtime-unofficial
scoop config SENZING_EULA_ACCEPTED yes
scoop install senzingsdk-runtime-unofficial
# Should NOT prompt

# 9. Clean up
scoop uninstall senzingsdk-runtime-unofficial
scoop bucket rm senzing-local
scoop config rm SENZING_EULA_ACCEPTED
```

### GitHub Actions Testing

```powershell
# After pushing to GitHub, test workflow:
# 1. Go to Actions tab
# 2. Run "Check for Senzing SDK Updates" workflow manually
# 3. Verify PR is created if update available
```

## Expected Results

After successful installation:

1. **Environment Variables Set**:
   - `SENZING_DIR` = `C:\Users\<user>\scoop\apps\senzingsdk-runtime-unofficial\current\er`
   - `PATH` includes `C:\Users\<user>\scoop\apps\senzingsdk-runtime-unofficial\current\er\lib`

2. **Directory Structure**:
   ```
   scoop\apps\senzingsdk-runtime-unofficial\
     current\
       er\
         lib\
         bin\
         ...
   ```

3. **Scoop Commands Work**:
   - `scoop info senzingsdk-runtime-unofficial` shows version
   - `scoop update senzingsdk-runtime-unofficial` checks for updates
   - `scoop uninstall senzingsdk-runtime-unofficial` removes cleanly

## Known Differences from Homebrew Implementation

The following features from the macOS Homebrew tap are NOT implemented:

1. **S3 Source Tracking**: macOS version tracks S3 source and re-prompts EULA if changed
2. **S3 URL Environment Override**: macOS allows `SENZING_SDK_WIN_S3_URL` override
3. **Skip Hash**: macOS skips hash verification (relies on code signing)

These differences are intentional and align with Windows/Scoop best practices.

## Next Steps

1. ✅ Complete all verification items above
2. ✅ Run `bin\checkver.ps1 -Update` to populate version/hash
3. ✅ Test installation locally on Windows
4. ✅ Commit and push to GitHub
5. ✅ Test GitHub Actions workflow
6. ✅ Monitor automated daily updates

## Status

- [x] Repository structure created
- [x] Manifest file created with placeholder version
- [x] PowerShell checkver script created
- [x] GitHub Actions workflow created
- [x] README documentation created
- [x] **All verification items 1-6 completed and fixed** ✅
- [x] **32-bit confirmation** (item 8) ✅
- [ ] **Initial version/hash populated** (item 7) ❌ - Requires running checkver.ps1
- [ ] **Local testing completed** - Requires Windows machine
- [ ] **Production ready** - Pending items 7 and local testing
