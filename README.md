# TWRP Device configuration for realme X2 Pro (samurai / RMX1931)

Branch target: **Android 12–16 FBE** (including Android 16 / 16.2 QPR2 custom ROMs such as LineageOS 23).

## Features

Works:
- ADB
- Decryption of `/data` (FBE v2 + metadata encryption + wrappedkey)
- Screen brightness settings
- Correct screenshot color
- MTP
- Flashing (ROMs, images, Magisk, etc.)
- Backup/Restore
- USB OTG

## Android 16 decrypt notes

Tree is aligned with LOS 23 / A16 `fstab.qcom` for samurai:

- `TW_USE_FSCRYPT_POLICY := 2`
- `fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,wrappedkey`
- `keydirectory=/metadata/vold/metadata_encryption`
- metadata crypto props (`dm-default-key`, format version 2)
- Keymaster 4.0 + Gatekeeper (same as A16 vendor for this device)

### After flashing a new ROM kernel

Update prebuilts from the ROM you want to decrypt:

```bash
# From ROM boot.img / dtbo.img
cp Image.gz-dtb device/realme/samurai/prebuilt/
cp dtbo.img device/realme/samurai/prebuilt/
```

If decrypt still fails, re-extract from the **vendor** partition of that ROM:

- `qseecomd`
- `android.hardware.keymaster@4.0-service-qti`
- `android.hardware.gatekeeper@1.0-service-qti`
- matching `vendor/lib64` deps

Then run `ldcheck` on `$OUT/recovery/root` after build.

### Clean decrypt test

1. Boot TWRP → **Wipe → Format Data** (types `yes`)
2. Flash ROM → reboot system → set PIN/password
3. Reboot recovery → enter same PIN → `/data` should mount

## Compile

### OrangeFox Recovery Build

Init OrangeFox Manifest (R11.1 / R12.1):

```bash
repo init --depth=1 -u https://gitlab.com/OrangeFox/manifest.git -b fox_12.1
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
```

Place this device tree in `device/realme/samurai`:

```bash
git clone https://github.com/zahid5656/twrp_device_realme_RMX1931.git -b twrp-12.1 device/realme/samurai
```

Build OrangeFox:

```bash
. build/envsetup.sh
lunch fox_samurai-eng
mka recoveryimage
# Or using OrangeFox build script:
# ./vendor/fox/bin/build.sh --device samurai --type Official
```

### TWRP Build

First checkout minimal TWRP source:

```bash
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync
```

Build TWRP:

```bash
. build/envsetup.sh
lunch twrp_samurai-eng
mka recoveryimage
```

### Test & Flash

Test (do not flash until booted successfully):

```bash
fastboot boot out/target/product/samurai/recovery.img
```

Flash when confirmed:

```bash
fastboot flash recovery out/target/product/samurai/recovery.img
```

## Debug decrypt

`init.recovery.qcom.rc` enables:

- `prepdecrypt.setpatch=true`
- `prepdecrypt.loglevel=2`

Check `/tmp/recovery.log` or `adb shell cat /tmp/recovery.log` after boot.

