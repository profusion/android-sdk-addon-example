# ============================================================
# SDK Add-On (build/make/core/tasks/sdk-addon.mk)
# ============================================================

# Uncomment this to run with 'TARGET_PRODUCT=profusion_sdk_addon TARGET_RELEASE=trunk_staging m droid'
# $(call inherit-product, device/generic/car/sdk_car_x86_64.mk)

# The name of this add-on (for the SDK)
PRODUCT_SDK_ADDON_NAME := profusion_sdk_addon

INTERNAL_SDK_HOST_OS_NAME := $(HOST_OS)

PRODUCT_PACKAGES := \
    libvsomeip3 \
    libCommonAPI \
    libCommonAPI-SomeIP \
    helloworld \
    profusion.hardware.dummy_car_info_hal-service \
    some_ip_playground-service \
    DummyCarInfoManager

# Copy the manifest and hardware files for the SDK add-on.
PRODUCT_SDK_ADDON_COPY_FILES := \
 $(LOCAL_PATH)/manifest.ini:manifest.ini \
 $(LOCAL_PATH)/source.properties:source.properties \
 $(LOCAL_PATH)/package.xml:package.xml

# Define the IMAGE PROPERTY (emulator related, but needed to build)
PRODUCT_SDK_ADDON_SYS_IMG_SOURCE_PROP := $(LOCAL_PATH)/source.properties

BOARD_SEPOLICY_DIRS += \
    device/profusion/sepolicy/daemon \
    device/profusion/sepolicy/interface

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
	hardware/implementations/dummy_car_info_hal/default/compatibility_matrix.xml

# Copy the jar files for the optional libraries that are exposed as APIs.
PRODUCT_SDK_ADDON_COPY_MODULES := \
    helloworld:libs/helloworld.jar \
    DummyCarInfoManager:libs/DummyCarInfoManager.jar

# Rules for public APIs
PRODUCT_SDK_ADDON_STUB_DEFS := $(LOCAL_PATH)/sdk_addon_stub_defs.txt

# Name of the doc to generate and put in the add-on.
# This must match the name defined in the optional library with the tag
#PRODUCT_SDK_ADDON_DOC_MODULES := \
#    helloworld

# This add-on extends the default sdk product.
# $(call inherit-product, $(SRC_TARGET_DIR)/product/sdk.mk)

# The name of this add-on (for the build system)
# Use 'TARGET_PRODUCT=<PRODUCT_NAME> m droid' to build the add-on,
# so in this case, we would run 'TARGET_PRODUCT=profusion_sdk_addon TARGET_RELEASE=trunk_staging m droid'
PRODUCT_NAME := profusion_sdk_addon
PRODUCT_MODEL := Profusion SDK Addon
PRODUCT_DEVICE := emulator_car64_x86_64
PRODUCT_BRAND := Android
############################################################################
