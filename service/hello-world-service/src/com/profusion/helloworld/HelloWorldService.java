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
