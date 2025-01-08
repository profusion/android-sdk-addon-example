package profusion.hardware.dummy_car_info_hal;

@VintfStability
interface IDummyCarInfoHAL{
    void getCarInfo(out profusion.hardware.dummy_car_info_hal.CarInfo carInfo);
}
