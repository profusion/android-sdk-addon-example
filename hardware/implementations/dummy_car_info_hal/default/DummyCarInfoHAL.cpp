#include "DummyCarInfoHAL.h"

#include <android-base/logging.h>
#include <cstdlib>

namespace aidl {
namespace profusion {
namespace hardware {
namespace dummy_car_info_hal {

ndk::ScopedAStatus DummyCarInfoHAL::getCarInfo(CarInfo* carInfo) {
    if (carInfo == nullptr) {
        LOG(ERROR) << "DummyHAL: carInfo is null!";
        return ndk::ScopedAStatus::fromExceptionCode(EX_ILLEGAL_ARGUMENT);
    }

    std::unique_lock<std::mutex> lock(dummyCarInfoMutex);
    LOG(INFO) << "DummyHAL: getCarInfo called!";
    carInfo->velocity = rand() % 70 + 50;
    carInfo->fuel = rand() % 10 + 50;
    carInfo->gear = rand() % 5 + 1;
    return ndk::ScopedAStatus::ok();
}

}
}
}
}
