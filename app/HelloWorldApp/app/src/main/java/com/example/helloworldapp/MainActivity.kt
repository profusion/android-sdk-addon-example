package com.example.helloworldapp

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.sp
import com.example.helloworldapp.ui.theme.HelloWorldAppTheme
import com.profusion.helloworld.IHelloWorldService

class MainActivity : ComponentActivity() {
    companion object {
        const val HELLO_WORLD_SERVICE_PACKAGE = "com.profusion.helloworld"
        const val HELLO_WORLD_SERVICE = "$HELLO_WORLD_SERVICE_PACKAGE.HelloWorldService"
        const val TAG = "HelloWorldApplication"
    }

    private var helloWorldService: IHelloWorldService? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            HelloWorldAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MainContent(
                        modifier = Modifier.padding(innerPadding),
                        onButtonClick = {
                            helloWorldService?.printHelloWorld()
                        }
                    )
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        val intent = Intent()
        intent.component = ComponentName(HELLO_WORLD_SERVICE_PACKAGE, HELLO_WORLD_SERVICE)
        try {
            this.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
        } catch (e: Exception) {
            Log.e(TAG, "Unable to bind HelloWorldService", e)
        }
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            helloWorldService = IHelloWorldService.Stub.asInterface(service)
        }

        override fun onServiceDisconnected(className: ComponentName) {
            helloWorldService = null
        }
    }
}

@Composable
fun MainContent(modifier: Modifier = Modifier, onButtonClick: () -> Unit) {
    Column(
        modifier = modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Button(
            onClick = onButtonClick,
        ) {
            Text(
                stringResource(R.string.helloWorldButtonText),
                fontSize = 32.sp,
            )
        }
    }
}
