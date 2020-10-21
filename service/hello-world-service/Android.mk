LOCAL_PATH:= $(call my-dir)

# Copy helloworld-permissions.xml to /etc/permissions folder
include $(CLEAR_VARS)
LOCAL_MODULE := helloworld-permissions.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/permissions
LOCAL_SRC_FILES := helloworld-permissions.xml
include $(BUILD_PREBUILT)

# Build helloworld library
# The SDK Add-On does not find this module if it's only defined in the Android.bp.
include $(CLEAR_VARS)
LOCAL_MODULE := helloworld
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := \
	helloworld-permissions.xml
LOCAL_CERTIFICATE := platform
LOCAL_SRC_FILES := \
	$(call all-java-files-under, src/com/profusion/helloworld) \
	$(call all-Iaidl-files-under, src/com/profusion/helloworld)
LOCAL_AIDL_INCLUDES := $(call all-Iaidl-files-under, src/com/profusion/helloworld)
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_PROGUARD_ENABLED := disabled
include $(BUILD_JAVA_LIBRARY)
