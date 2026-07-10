# TWRP 14.1 — realme X2 Pro (samurai / RMX1931)

Device tree for **minimal-manifest-twrp `twrp-14.1`** (AOSP Android 14 base).

Includes Android **16 / 16.2 QPR2** FBE decrypt alignment (fscrypt v2 + metadata + wrappedkey).

## Features

- ADB / ADB Sideload
- `/data` FBE decrypt (Keymaster 4.0 + Gatekeeper + qseecomd)
- MTP, USB OTG
- Flash / backup / restore
- Ozip key support (stock Realme packages)

## Build (TWRP 14.1)

```bash
# Source
repo init --depth=1 \
  -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git \
  -b twrp-14.1
repo sync -j$(nproc)

# Device tree
git clone https://github.com/nayem8854/twrp_device_realme_RMX1931.git \
  -b twrp-14.1 device/realme/samurai

# QCOM decrypt common (also listed in twrp.dependencies)
git clone https://github.com/TeamWin/android_device_qcom_twrp-common.git \
  -b android-14.1 device/qcom/twrp-common

# Build
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch twrp_samurai-eng
mka recoveryimage
```

Output (typical):

```text
out/target/product/samurai/recovery.img
```

Test:

```bash
fastboot boot out/target/product/samurai/recovery.img
# flash when OK:
fastboot flash recovery out/target/product/samurai/recovery.img
```

## Android 16 decrypt notes

Aligned with LOS 23 `fstab.qcom` for samurai:

| Setting | Value |
|--------|--------|
| FSCRYPT policy | `TW_USE_FSCRYPT_POLICY := 2` |
| fileencryption | `aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized,wrappedkey` |
| keydirectory | `/metadata/vold/metadata_encryption` |
| Keymaster | 4.0 (same as A16 vendor on this device) |

### After flashing a new ROM

1. Update `prebuilt/Image.gz-dtb` + `prebuilt/dtbo.img` from that ROM’s boot/dtbo if recovery won’t boot or decrypt fails.
2. Re-extract from **vendor** if needed: `qseecomd`, keymaster 4.0, gatekeeper + `vendor/lib64` deps; run `ldcheck` on `$OUT/recovery/root`.

### Clean decrypt test

1. TWRP → Wipe → **Format Data**
2. Flash ROM → boot → set PIN
3. Reboot recovery → enter PIN → `/data` mounts

## Debug

`init.recovery.qcom.rc` enables:

- `prepdecrypt.setpatch=true`
- `prepdecrypt.loglevel=2`

```bash
adb shell cat /tmp/recovery.log
```

## Branches

| Branch | TWRP source |
|--------|-------------|
| `twrp-12.1` / `twrp-12.1L` | `platform_manifest_twrp_aosp` **twrp-12.1** |
| `twrp-14.1` | `platform_manifest_twrp_aosp` **twrp-14.1** |

## Layout

```text
device/realme/samurai/
  BoardConfig.mk
  device.mk
  twrp_samurai.mk
  twrp.dependencies          # qcom twrp-common @ android-14.1
  recovery/root/             # init, fstab, crypto blobs
  prebuilt/                  # Image.gz-dtb, dtbo.img
```
