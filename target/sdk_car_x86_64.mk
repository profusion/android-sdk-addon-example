#
# Copyright (C) 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_PACKAGE_OVERLAYS := device/generic/car/common/overlay

QEMU_USE_SYSTEM_EXT_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

ifneq ($(EMULATOR_DYNAMIC_MULTIDISPLAY_CONFIG),true)
# Emulator configuration
PRODUCT_COPY_FILES += \
    device/generic/car/common/config.ini:config.ini
endif # EMULATOR_DYNAMIC_MULTIDISPLAY_CONFIG

#
# All components inherited here go to system image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, packages/services/Car/car_product/build/car_generic_system.mk)

PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := strict

#
# All components inherited here go to system_ext image
#
$(call inherit-product, packages/services/Car/car_product/build/car_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, device/generic/car/emulator/car_emulator_product.mk)

#
# All components inherited here go to vendor image
#
$(call inherit-product, device/generic/car/emulator/car_emulator_vendor.mk)
$(call inherit-product, device/generic/goldfish/board/emu64x/details.mk)
$(call inherit-product, device/profusion/profusion_sdk_addon/profusion_sdk_addon.mk)

EMULATOR_VENDOR_NO_SOUND := true
PRODUCT_NAME := sdk_car_x86_64
PRODUCT_DEVICE := emulator_car64_x86_64
PRODUCT_BRAND := Android
PRODUCT_MODEL := Car on x86_64 emulator
