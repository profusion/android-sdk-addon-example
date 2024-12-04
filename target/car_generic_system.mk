#
# Copyright (C) 2022 The Android Open Source Project
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
#

# This makefile supports a generic system image for an automotive device.
$(call inherit-product, packages/services/Car/car_product/build/car_system.mk)

$(call inherit-product, device/profusion/common/profusion-packages.mk)

# Car rotary
PRODUCT_PACKAGES += \
    CarRotaryController \
    CarRotaryImeRRO \
    RotaryIME \
    RotaryPlayground \

PRODUCT_PACKAGES_DEBUG += \
    avbctl \
    bootctl \
    curl \
    tinycap \
    tinyhostless \
    tinymix \
    tinypcminfo \
    tinyplay \
    update_engine_client \
    AdasLocationTestApp \
    CarHotwordDetectionServiceOne \
    CarTelemetryApp \
    DefaultStorageMonitoringCompanionApp \
    EmbeddedKitchenSinkApp \
    ExperimentalCarService \
    GarageModeTestApp \
    NetworkPreferenceApp \
    RailwayReferenceApp \
    SampleCustomInputService \

# Default boot animation for AAOS
PRODUCT_COPY_FILES += \
    packages/services/Car/car_product/bootanimations/bootanimation-832.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

# ClusterOsDouble is the testing app to test Cluster2 framework and it can handle Cluster VHAL
# and do some Cluster OS role.
ifeq ($(ENABLE_CLUSTER_OS_DOUBLE), true)
PRODUCT_PACKAGES += ClusterHomeSample ClusterOsDouble
else
# DirectRenderingCluster is the sample app for the old Cluster framework.
PRODUCT_PACKAGES += DirectRenderingCluster
endif  # ENABLE_CLUSTER_OS_DOUBLE

# ENABLE_CAMERA_SERVICE must be set as true from the product's makefile if it wants to support
# Android Camera service.
ifneq ($(ENABLE_CAMERA_SERVICE), true)
PRODUCT_PROPERTY_OVERRIDES += config.disable_cameraservice=true
PRODUCT_PACKAGES += HideCameraApps
endif

# ENABLE_EVS_SERVICE must be set as true from the product's makefile if it wants to support
# the Extended View System service.
ifeq ($(ENABLE_EVS_SERVICE), true)
PRODUCT_PACKAGES += evsmanagerd

# CUSTOMIZE_EVS_SERVICE_PARAMETER must be set as true from the product's makefile if it wants
# to use IEvsEnumearor instances other than hw/1.
ifneq ($(CUSTOMIZE_EVS_SERVICE_PARAMETER), true)
PRODUCT_COPY_FILES += \
    packages/services/Car/cpp/evs/manager/aidl/init.evs.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.evs.rc
endif

ifeq ($(ENABLE_CAREVSSERVICE_SAMPLE), true)
# TODO(b/293332636): Clean up below line when both apps are consolidated into a single app.
PRODUCT_PACKAGES += CarEvsCameraPreviewApp CarEvsMultiCameraPreviewApp
endif
ifeq ($(ENABLE_REAR_VIEW_CAMERA_SAMPLE), true)
PRODUCT_PACKAGES += SampleRearViewCamera
endif
# This is needed to be available to all builds because overlay config doesn't support optional overlays.
PRODUCT_PACKAGE_OVERLAYS += packages/services/Car/tests/SampleRearViewCamera/overlay

endif  # ENABLE_EVS_SERVICE

# Conditionally enable the telemetry service
ifeq ($(ENABLE_CARTELEMETRY_SERVICE), true)
PRODUCT_PACKAGES += android.automotive.telemetryd@1.0 \
                    ScriptExecutor
endif

# ENABLE_EVS_SAMPLE should be set true or their vendor specific equivalents should be included in
# the device.mk with the corresponding selinux policies
ifeq ($(ENABLE_EVS_SAMPLE), true)
PRODUCT_PACKAGES += evs_app
# A reference EVS HAL implementation will be added in car_vendor.mk and require AIDL version of
# the automotive display service implementation.
USE_AIDL_DISPLAY_SERVICE := true
else ifeq ($(ENABLE_SAMPLE_EVS_APP), true)
PRODUCT_PACKAGES += evs_app
endif

ifeq ($(USE_AIDL_DISPLAY_SERVICE), true)
PRODUCT_PACKAGES += cardisplayproxyd
else
# TODO(b/276340636): Remove HIDL Automotive Display Service implementation when we stop supporting
# HIDL EVS interface implementations.
$(warning HIDL version of the Automotive Display Service is deprecated \
          and will be replaced with cardisplayproxyd.)
PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service
endif  # USE_AIDL_DISPLAY_SERVICE

PRODUCT_NAME := car_generic_system
PRODUCT_BRAND := generic

# Define /system partition-specific product properties to identify that /system
# partition is car_generic_system.
PRODUCT_SYSTEM_NAME := car_generic
PRODUCT_SYSTEM_BRAND := Android
PRODUCT_SYSTEM_MANUFACTURER := Android
PRODUCT_SYSTEM_MODEL := car_generic
PRODUCT_SYSTEM_DEVICE := generic

# System.img should be mounted at /, so we include ROOT here.
_my_paths := \
  $(TARGET_COPY_OUT_ROOT)/ \
  $(TARGET_COPY_OUT_SYSTEM)/ \

$(call require-artifacts-in-path, $(_my_paths),)
