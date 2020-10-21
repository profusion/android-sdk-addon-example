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
