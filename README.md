# DEPRECATED - Scoop Bucket for Senzing SDK Runtime (Unofficial)

> **This repository is deprecated.** Senzing now maintains an official Scoop bucket. Please migrate to the official package.
>
> **Official repo:** [https://github.com/Senzing/scoop-senzingsdk](https://github.com/Senzing/scoop-senzingsdk)

## Migration Instructions

### 1. Uninstall the unofficial package

```powershell
scoop uninstall senzingsdk-runtime-unofficial
scoop bucket rm senzingsdk-runtime-unofficial
```

### 2. Add the official Senzing bucket and install

```powershell
scoop bucket add senzingsdk https://github.com/Senzing/scoop-senzingsdk
scoop install senzingsdk-runtime
```

## Why Migrate?

- The official bucket is maintained by Senzing Inc. with guaranteed support
- This unofficial bucket will no longer receive version updates
- The official package name is `senzingsdk-runtime` (without the `-unofficial` suffix)

## License

This repository is licensed under the Apache License 2.0. See [LICENSE](LICENSE) file for details.

## Disclaimer

This was an **unofficial** package distribution. It was not maintained by Senzing Inc.

For official Senzing support and documentation, visit [senzing.com](https://senzing.com/).
