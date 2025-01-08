#pragma once

#include <aidl/profusion/hardware/dummy_car_info_hal/BnDummyCarInfoHAL.h>
#include <mutex>

namespace aidl {
namespace profusion {
namespace hardware {
namespace dummy_car_info_hal {

class DummyCarInfoHAL : public BnDummyCarInfoHAL {
    virtual ndk::ScopedAStatus getCarInfo(CarInfo* carInfo) override;

protected:
    std::mutex dummyCarInfoMutex;
};

}
}
}
}
