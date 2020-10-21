# How to build and use an SDK Add-on

Whether you are an OEM company or a developer customizing the Android Open Source Project, you might have come across the issue where you developed a feature and you would like for App developers to use it. That's when the SDK Add-on comes in handy.

The Android Software Development Kit (SDK) is a collection of libraries and tools that enables and makes it easier to develop Android applications. SDK Add-ons allow third-party actors to extend the Android SDK to add interfaces to their features without changing the Android SDK. According to the Android Compatibility Definition Document (CDD), OEMs are not allowed to change the Android public APIs - namely those in the protected namespaces: `java.*`, `javax.*`, `sun.*`, `android.*`, `com.android.*`. Therefore, by using add-ons, OEMs can add libraries in their namespaces, providing functionalities that can be exported without infringing the CDD. Having to build only the add-on is also a great advantage that might save a lot of development time.

In this post, we will build an SDK Add-on containing an example service - for which we will cover all the necessary config files. We will also learn how to connect an application to our example service using the add-on. Here, we are assuming you already have access to the Android source code and that you can build and deploy these changes. The code and configuration files were made with Android 10 (API level 29) in mind but they can be easily modifiable to work with other versions.

## Hello World System Service

To facilitate the understanding of how to build and extract your own SDK Add-on, we will create a simple "hello world" service so that later we can use an application to connect to it.

##### `HelloWorldService.java`
```code
package com.profusion.helloworld;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

public class HelloWorldService extends Service {
    private static final String TAG = "HelloWorldService";
    private IHelloWorldService.Stub mBinder;

    @Override
    public IBinder onBind(final Intent intent) {
        if (mBinder == null) {
            mBinder = new HelloWorld();
        }
        return mBinder;
    }

    private class HelloWorld extends IHelloWorldService.Stub {

        public HelloWorld() {
        }

        public void printHelloWorld() {
            Log.d(TAG, "Hello World.");
        }
    }
}

```

An [AIDL](https://source.android.com/devices/architecture/aidl/overview) interface is needed for a client app to connect to.

##### `IHelloWorldService.aidl`
```code
package com.profusion.helloworld;

interface IHelloWorldService {
    void printHelloWorld();
}
```

The service also needs a set of permissions that will be installed on the `/system/etc` directory. When the client app is installed, it will look for this file to determine if the HelloWorld library exists. The service library is installed in the `/system/framework` directory.
##### `helloworld-permissions.xml`
```code
<?xml version="1.0" encoding="utf-8"?>
<permissions>
    <library name="helloworld" file="/system/framework/helloworld.jar"/>
</permissions>
```

If `helloworld-permissions.xml` does not exist, then the app will not be installed and `adb install` will return an error such as:
```
Failure [INSTALL_FAILED_MISSING_SHARED_LIBRARY: Package couldn't be installed...]
```

Also, `AndroidManifest.xml` needs to define the service interface.
##### `AndroidManifest.xml`
```code
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
      package="com.profusion.helloworld"
      android:versionCode="1"
      android:versionName="1.0"
      android:sharedUserId="android.uid.system">

    <application android:label="Hello World Service"
                 android:directBootAware="true">
        <service android:name=".HelloWorldService"
                 android:enabled="true"
                 android:exported="true" >
        </service>
    </application>
</manifest>

```

Unfortunately, the SDK Add-on does not recognize the library if it's defined in an `Android.bp` file, so the `.jar` must be defined in an `Android.mk`. We will still have a `.bp`, but it only defines the service APK that will be built and will not be a part of the add-on.

##### `Android.bp`
```code
android_app {
    name: "helloworldservice",
    srcs: [
        "src/com/profusion/helloworld/HelloWorldService.java",
        "src/com/profusion/helloworld/IHelloWorldService.aidl"
    ],
    dex_preopt: {
        enabled: false,
    },
    certificate: "platform",
}
```

##### `Android.mk`
```code
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
```

## SDK Add-on configs
If you already have a service, then this is the interesting part:
You need a `.mk` file that defines the name and properties of your SDK Add-on, and several other files that define miscellaneous properties such as the API level being used, the revision version, and the libraries contained in the add-on. During the Android build, these files are bundled into a `.zip` containing the add-on to be distributed. In the next sections, I will go into further detail into each of the included files.

##### `profusion_sdk_addon.mk`
```code
# The name of this add-on (for the SDK)
PRODUCT_SDK_ADDON_NAME := profusion_sdk_addon

PRODUCT_PACKAGES := \
    helloworld

# Copy the manifest and properties files for the SDK add-on.
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
```
The `profusion_sdk_addon.mk` provides all the information needed to build the add-on, like the modules that will be included. In this case, we want to include our helloworld.jar, so we need to specify the module to be built in the `PRODUCT_PACKAGES` variable and copy it to the add-on using the `PRODUCT_SDK_ADDON_COPY_MODULES` variable. The `PRODUCT_SDK_ADDON_COPY_FILES` is used to copy the config files that will be used in Android Studio to build the application.

##### `manifest.ini`
```code
# SDK Add-on Manifest

name=ProfusionAddOn
name-id=profusionaddon
vendor=Profusion
vendor-id=profusion
description=Profusion SDK Add-On

api=29
revision=1
libraries=helloworld
helloworld=helloworld.jar
```
The `manifest.ini` file contains the properties of the add-on, including the Android API Level, the libraries included, and the revision number. If there is more than one library, they must be separated by a semicolon (;) and also be defined below in a new line containing the library name and its `.jar` file name.

##### `source.properties`
```code
Addon.NameId=profusionaddon
Addon.NameDisplay=ProfusionAddOn
Addon.VendorId=profusion
Addon.VendorDisplay=Profusion
Pkg.Desc=Profusion SDK Addon
Pkg.Revision=1
Pkg.UserSrc=false
Archive.Arch=ANY
Archive.Os=ANY

AndroidVersion.ApiLevel=29
SystemImage.TagDisplay=Profusion SDK Add-On
SystemImage.TagId=profusionaddon
SystemImage.Abi=${TARGET_CPU_ABI}
```
The `source.properties` defines add-on properties used for the built image, which can be distributed along with the SDK Add-on.

##### `package.xml`
```code
<ns2:repository xmlns:ns2="http://schemas.android.com/repository/android/common/01" xmlns:ns3="http://schemas.android.com/repository/android/generic/01" xmlns:ns4="http://schemas.android.com/sdk/android/repo/addon2/01" xmlns:ns5="http://schemas.android.com/sdk/android/repo/repository2/01" xmlns:ns6="http://schemas.android.com/sdk/android/repo/sys-img2/01">
  <license id="license-CC939D3F" type="text"/>
  <localPackage path="add-ons;addon-profusionaddon-profusion-29" obsolete="false">
    <type-details xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:addonDetailsType">
      <api-level>29</api-level>
      <vendor>
        <id>profusion</id>
        <display>Profusion</display>
      </vendor>
      <tag>
        <id>profusionaddon</id>
        <display>ProfusionAddOn</display>
      </tag>
      <libraries>
        <library localJarPath="helloworld.jar" name="helloworld">
          <description>Hello World Library</description>
        </library>
      </libraries>
    </type-details>
    <revision>
      <major>1</major>
      <minor>0</minor>
      <micro>0</micro>
    </revision>
    <display-name>ProfusionAddOn, Android 29, rev 1</display-name>
    <uses-license ref="license-CC939D3F"/>
  </localPackage>
</ns2:repository>
```
The `package.xml` file makes it easier for Android Studio to import the add-on.

##### `sdk_addon_stub_defs.txt`
```code
+com.profusion.helloworld.*
```
The `sdk_addon_stub_defs.txt` file contains the rules for public APIs.

For these tests, I was using `lunch aosp_x86_64-eng`, so I decided to add the reference to `profusion_sdk_addon.mk` in the `build/make/target/product/aosp_x86_64.mk`, but you may add it to whichever device you are using. Simply add:
```code
$(call inherit-product, $(SRC_TARGET_DIR)/product/profusion_sdk_addon/profusion_sdk_addon.mk)
```

### Building
The SDK Add-on is all set. Now we only have to build it. Notice, again, that I'm using `aosp_x86_64`:
```code
$ make PRODUCT-aosp_x86_64-sdk_addon
```

When the compilation succeeds, the SDK Add-on `.zip` will be in `out/host/linux-x86/sdk_addon/profusion_sdk_addon-eng.user-linux-x86.zip`

## Adding the SDK Add-on to Android Studio

Create a path on your Android SDK for the add-ons, then extract the contents of the add-on `.zip` file. You will need to rename the directory using the names defined in the "localPackage path" in the `package.xml`
```code
$ mkdir -p /path/to/Sdk/add-ons
$ unzip out/host/linux-x86/sdk_addon/profusion_sdk_addon-eng.user-linux-x86.zip -d /path/to/Sdk/add-ons/
$ mv /path/to/Sdk/add-ons/profusion_sdk_addon-eng.user-linux-x86/ /path/to/Sdk/add-ons/addon-profusionaddon-profusion-29/
```

Open Android Studio and go to Tools -> SDK Manager. Check the "Show Package Details" checkbox then you will be able to see the SDK Add-on for the API level configured.
![SDK Manager containing the SDK Add-on](sdkmanager.png)

## Using the SDK Add-on in an application

To use the SDK Add-on, you must first change the `compileSdkVersion` on the `build.gradle` to the vendor name, along with the add-on name and the API level - as defined in the `manifest.ini` - all separated by colons. In your case, it will look like this:
```code
...
  compileSdkVersion 'Profusion:ProfusionAddOn:29'
...
```

Import the class from the SDK you'd like to use. In our case, it's `com.profusion.helloworld.IHelloWorldService`.
Sometimes Android Studio will not recognize the package, so I recommend you go to Tools -> SDK Manager and on the "SDK Location" click on `Edit` and don't change anything, but click `Next` until it finishes. This will force Android Studio to reparse the `package.xml` from the add-on.

Below is an example of an application using the HelloWorldService:
##### `MainActivity.kt`
```code
package com.profusion.helloworldapplication

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.os.RemoteException
import android.util.Log
import com.profusion.helloworld.IHelloWorldService

const val HELLOWORLD_SERVICE_PACKAGE = "com.profusion.helloworld"
const val HELLOWORLD_SERVICE = "$HELLOWORLD_SERVICE_PACKAGE.HelloWorldService"
const val TAG = "HelloWorldApplication"

class MainActivity : Activity() {
    private var mService: IHelloWorldService? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun onStart() {
        super.onStart()
        val intent = Intent()
        intent.component = ComponentName(HELLOWORLD_SERVICE_PACKAGE, HELLOWORLD_SERVICE)
        try {
            this.bindService(intent, mConnection, Context.BIND_AUTO_CREATE)
        } catch (e: Exception) {
            Log.e(TAG, "Unable to bind HelloWorldService");
            e.printStackTrace()
        }
    }

    private val mConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            mService = IHelloWorldService.Stub.asInterface(service)
            try {
                mService?.printHelloWorld()
            } catch (e: RemoteException) {
                Log.e(TAG, "HelloWorldService request failed");
                e.printStackTrace()
            }
        }

        override fun onServiceDisconnected(className: ComponentName) {
            mService = null
        }
    }
}
```

Make sure to include the following in your `AndroidManifest.xml` under the application tag:
```code
    <application
        ...
        <uses-library android:name="helloworld"
            android:required="true" />
        ...
    </application>
```

And that's it!

If you run the application and then check the `logcat` searching for "HelloWorldService," then you will be able to see the service printing "Hello World."

```code
$ adb shell
# logcat | grep -i HelloWorldService
3261  3279 D HelloWorldService: Hello World.
```
