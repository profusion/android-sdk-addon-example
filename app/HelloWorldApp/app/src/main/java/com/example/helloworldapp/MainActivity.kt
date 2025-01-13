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
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.helloworldapp.ui.theme.HelloWorldAppTheme
import com.profusion.helloworld.IHelloWorldService
import com.profusion.dummyCarInfo.DummyCarInfoManager

class MainActivity : ComponentActivity() {
    companion object {
        const val HELLO_WORLD_SERVICE_PACKAGE = "com.profusion.helloworld"
        const val HELLO_WORLD_SERVICE = "$HELLO_WORLD_SERVICE_PACKAGE.HelloWorldService"
        const val TAG = "HelloWorldApplication"
    }

    private var helloWorldService: IHelloWorldService? = null
    private var dummyCarInfoManager: DummyCarInfoManager? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            var carInfoState by remember { mutableStateOf("") }

            HelloWorldAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    MainContent(
                        modifier = Modifier.padding(innerPadding),
                        onHelloWorldButtonClick = {
                            helloWorldService?.printHelloWorld()
                        },
                        onCarInfoButtonClick = {
                            carInfoState = try {
                                dummyCarInfoManager!!.carInfo
                            } catch (e: Exception) {
                                "Error: ${e.message}"
                            }
                        },
                        carInfoState = carInfoState,
                    )
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        dummyCarInfoManager?.unbindService();
    }

    override fun onStart() {
        super.onStart()
        dummyCarInfoManager = DummyCarInfoManager(this)
        val intent = Intent()
        intent.component = ComponentName(HELLO_WORLD_SERVICE_PACKAGE, HELLO_WORLD_SERVICE)
        try {
            this.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
        } catch (e: Exception) {
            Log.e(TAG, "Unable to bind");
            e.printStackTrace()
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
fun MainContent(
    modifier: Modifier = Modifier,
    onHelloWorldButtonClick: () -> Unit,
    onCarInfoButtonClick: () -> Unit,
    carInfoState: String,
) {
    Column(
        modifier = modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Button(
            onClick = onHelloWorldButtonClick,
        ) {
            Text(
                stringResource(R.string.helloWorldButtonText),
                fontSize = 32.sp,
            )
        }
        Button(
            modifier = Modifier.padding(vertical = 16.dp),
            onClick = onCarInfoButtonClick,
        ) {
            Text(
                stringResource(R.string.carInfoButtonText),
                fontSize = 32.sp,
            )
        }
        Text(
            text = carInfoState,
            fontSize = 32.sp,
        )
    }
}
