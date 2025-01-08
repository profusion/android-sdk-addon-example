package com.profusion.dummyCarInfo;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

public class DummyCarInfoManager {
    private static final String TAG = "DummyCarInfoManager";
    private IDummyCarInfoService dummyCarInfoService;
    private Context context;
    private boolean isBound = false;
    private static final String DUMMY_CAR_SERVICE_PACKAGE = "com.profusion.dummyCarInfo";
    private static final String DUMMY_CAR_SERVICE = "com.profusion.dummyCarInfo.DummyCarInfoService";

    public DummyCarInfoManager(Context context) {
        this.context = context;
        bindService();
    }

    private void bindService() {
        try {
            Intent intent = new Intent();
            intent.setComponent(new ComponentName(DUMMY_CAR_SERVICE_PACKAGE, DUMMY_CAR_SERVICE));
            context.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
        } catch (Exception e) {
            Log.e(TAG, "Exception while binding to DummyCarInfoService", e);
        }
    }

    public void unbindService() {
        if (isBound) {
            context.unbindService(serviceConnection);
            isBound = false;
        }
    }

    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            dummyCarInfoService = IDummyCarInfoService.Stub.asInterface(service);
            isBound = true;
            Log.d(TAG, "DummyCarInfoService connected");
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            dummyCarInfoService = null;
            isBound = false;
            Log.d(TAG, "DummyCarInfoService disconnected");
        }
    };

    public String getCarInfo() throws Exception {
        if (dummyCarInfoService != null) {
            String carInfo = dummyCarInfoService.getCarInfo();
            if (carInfo != null) {
                return carInfo;
            } else {
                Log.e(TAG, "Failed to get car info from DummyCarInfoService");
                throw new Exception("Failed to get car info from DummyCarInfoService");
            }
        } else {
            Log.e(TAG, "DummyCarInfoService is not bound");
            throw new Exception("DummyCarInfoService is not bound");
        }
    }
}
