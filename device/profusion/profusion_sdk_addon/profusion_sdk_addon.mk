# ============================================================
# SDK Add-On (build/make/core/tasks/sdk-addon.mk)
# ============================================================
# Real name of the add-on. This is the name used to build the add-on.
# Use `TARGET_PRODUCT=PRODUCT-<PRODUCT_NAME> m droid` to build the add-on.
# If they didn't define PRODUCT_SDK_ADDON_NAME, then we won't define < TODO remove?
# any of sdk_addon rules.

# $(call inherit-product, build/make/target/product/aosp_x86_64.mk)

# The name of this add-on (for the SDK)
PRODUCT_SDK_ADDON_NAME := helloworld # or profusion_sdk_addon?

INTERNAL_SDK_HOST_OS_NAME := $(HOST_OS)

# PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST+= \
#     system/%

PRODUCT_PACKAGES := \
    com.profusion.helloworld

# Copy the manifest and hardware files for the SDK add-on.
PRODUCT_SDK_ADDON_COPY_FILES += \
 $(LOCAL_PATH)/manifest.ini:manifest.ini

# Copy the jar files for the optional libraries that are exposed as APIs.
PRODUCT_SDK_ADDON_COPY_MODULES += \
    com.profusion.helloworld:libs/com.profusion.helloworld.jar

# Rules for public APIs
PRODUCT_SDK_ADDON_STUB_DEFS := $(LOCAL_PATH)/addon_stub_defs

# Name of the doc to generate and put in the add-on.
# This must match the name defined in the optional library with the tag
#PRODUCT_SDK_ADDON_DOC_MODULES := \
#    helloworld

# This add-on extends the default sdk product.
$(call inherit-product, $(SRC_TARGET_DIR)/product/sdk.mk)

# The name of this add-on (for the build system)
# Use 'TARGET_PRODUCT=<PRODUCT_NAME> m droid' to build the add-on,
# so in this case, we would run 'TARGET_PRODUCT=profusion_sdk_addon  m droid'
PRODUCT_NAME := profusion_sdk_addon
# PRODUCT_DEVICE := generic_x86_64
PRODUCT_BRAND := Android
############################################################################
