#include "DummyCarInfoHAL.h"

#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <android-base/logging.h>

using aidl::profusion::hardware::dummy_car_info_hal::DummyCarInfoHAL;

int main() {
    LOG(INFO) << "DummyHAL: Main HAL being called";

    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<DummyCarInfoHAL> dummyCarInfoHAL = ndk::SharedRefBase::make<DummyCarInfoHAL>();

    const std::string instance = std::string() + DummyCarInfoHAL::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(dummyCarInfoHAL->asBinder().get(), instance.c_str());
    CHECK_EQ(status, STATUS_OK);

    ABinderProcess_joinThreadPool();
    LOG(INFO) << "DummyHAL: Main HAL initialization failed";
    return EXIT_FAILURE;
}
