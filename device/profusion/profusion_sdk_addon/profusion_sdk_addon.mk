# ============================================================
# SDK Add-On (build/make/core/tasks/sdk-addon.mk)
# ============================================================
# Real name of the add-on. This is the name used to build the add-on.
# Use `TARGET_PRODUCT=PRODUCT-<PRODUCT_NAME> m droid` to build the add-on.
# If they didn't define PRODUCT_SDK_ADDON_NAME, then we won't define < TODO remove?
# any of sdk_addon rules.

#$(call inherit-product, build/make/target/product/aosp_x86_64.mk)

# The name of this add-on (for the SDK)
PRODUCT_SDK_ADDON_NAME := profusion_sdk_addon

PRODUCT_PACKAGES := \
    helloworld

# Copy the manifest and hardware files for the SDK add-on.
PRODUCT_SDK_ADDON_COPY_FILES := \
 $(LOCAL_PATH)/manifest.ini:manifest.ini \
 $(LOCAL_PATH)/source.properties:source.properties \
 $(LOCAL_PATH)/package.xml:package.xml

# Define the IMAGE PROPERTY (emulator related, but needed to build)
PRODUCT_SDK_ADDON_SYS_IMG_SOURCE_PROP := $(LOCAL_PATH)/source.properties


# Copy the jar files for the optional libraries that are exposed as APIs.
PRODUCT_SDK_ADDON_COPY_MODULES := \
    helloworld:libs/helloworld.jar

# Rules for public APIs
PRODUCT_SDK_ADDON_STUB_DEFS := $(LOCAL_PATH)/sdk_addon_stub_defs.txt

# Name of the doc to generate and put in the add-on.
# This must match the name defined in the optional library with the tag
#PRODUCT_SDK_ADDON_DOC_MODULES := \
#    helloworld

# This add-on extends the default sdk product.
#$(call inherit-product, $(SRC_TARGET_DIR)/product/sdk.mk)

# The name of this add-on (for the build system)
# Use 'make PRODUCT-<PRODUCT_NAME>-sdk_addon' to build the add-on,
# so in this case, we would run 'make PRODUCT-profusion_sdk_addon-sdk_addon'
PRODUCT_NAME := profusion_sdk_addon
PRODUCT_MODEL := Profusion SDK Addon
PRODUCT_DEVICE := generic_x86_64
PRODUCT_BRAND := Android
############################################################################
