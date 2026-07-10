#
# Copyright (C) 2022-2026 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Product makefile for twrp-14.1 (twrp_ prefix required)
#

# Release name
PRODUCT_RELEASE_NAME := samurai

# Inherit AOSP base (order matters on A14)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
# FBE / modern storage helpers (safe no-op when unused)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# TWRP common
$(call inherit-product, vendor/twrp/config/common.mk)

# Device
$(call inherit-product, device/realme/samurai/device.mk)

PRODUCT_DEVICE := samurai
PRODUCT_NAME := twrp_samurai
PRODUCT_BRAND := Realme
PRODUCT_MODEL := Realme X2 Pro
PRODUCT_MANUFACTURER := Realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=RMX1931 \
    BUILD_PRODUCT=RMX1931 \
    TARGET_DEVICE=RMX1931
