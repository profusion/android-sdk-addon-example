package com.profusion.dummyCarInfo;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.os.ServiceManager;
import android.util.Log;
import profusion.hardware.dummy_car_info_hal.IDummyCarInfoHAL;
import profusion.hardware.dummy_car_info_hal.CarInfo;

public class DummyCarInfoService extends Service {
    private static final String TAG = "DummyCarInfoService";

    private IDummyCarInfoHAL halService;
    private IDummyCarInfoService.Stub binder;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate");
        try {
            IBinder binder = ServiceManager.getService("profusion.hardware.dummy_car_info_hal.IDummyCarInfoHAL/default");
            if (binder == null) {
                Log.e(TAG, "Failed to get DummyCarInfoHAL from ServiceManager");
                return;
            }
            halService = IDummyCarInfoHAL.Stub.asInterface(binder);
            if (halService == null) {
                Log.e(TAG, "Failed to get DummyCarInfoHAL service");
                return;
            }
            Log.d(TAG, "HAL binded");
        } catch (Exception e) {
            Log.e(TAG, "Exception on HAL bind", e);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.d(TAG, "DummyCarInfoService onBind");
        if (binder == null) {
            binder = new DummyCarInfoServiceImpl();
        }
        return binder;
    }

    private class DummyCarInfoServiceImpl extends IDummyCarInfoService.Stub {

        public DummyCarInfoServiceImpl() {
        }

        public String getCarInfo() {
            try {
                return getCarInfoFromHAL();
            } catch (Exception e) {
                Log.e(TAG, "Exception while getting car info from HAL", e);
                return null;
            }
        }
    }

    private String getCarInfoFromHAL() throws Exception {
        Log.d(TAG, "Getting car info from HAL");
        if (halService != null) {
            try {
                CarInfo carInfo = new CarInfo();
                halService.getCarInfo(carInfo);
                Log.d(TAG, "Car info received from HAL");
                return "Velocity: " + carInfo.velocity + ", Fuel: " + carInfo.fuel + ", Gear: " + carInfo.gear;
            } catch (Exception e) {
                Log.e(TAG, "Exception on getCarInfo", e);
                throw new Exception("Failed to get car info from HAL", e);
            }
        } else {
            Log.e(TAG, "HAL service is not initialized");
            throw new Exception("HAL service is not initialized");
        }
    }
}
