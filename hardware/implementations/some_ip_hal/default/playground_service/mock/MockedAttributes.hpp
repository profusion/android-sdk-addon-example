/*
 * Copyright (C) 2021, Bayerische Motoren Werke Aktiengesellschaft (BMW AG),
 *   Author: Alexander Domin (Alexander.Domin@bmw.de)
 * Copyright (C) 2021, ProFUSION Sistemas e Soluções LTDA,
 *   Author: Leandro Ferlin (leandroferlin@profusion.mobi)
 *
 * SPDX-License-Identifier: MPL-2.0
 *
 * This Source Code Form is subject to the terms of the
 * Mozilla Public License, v. 2.0. If a copy of the MPL was
 * not distributed with this file, You can obtain one at
 * http://mozilla.org/MPL/2.0/.
 */

#ifndef CONSUMPTION_H_
#define CONSUMPTION_H_

#include "MockedValue.hpp"
#include <cstdint>
#include <vector>
#include <v1/org/genivi/vehicle/playground/PlaygroundStubDefault.hpp>

namespace Mock {

typedef ::org::genivi::vehicle::playgroundtypes::PlaygroundTypes::Gear Gear;
typedef ::org::genivi::vehicle::playgroundtypes::PlaygroundTypes::DoorsStatus
    DoorsStatus;
typedef ::org::genivi::vehicle::playgroundtypes::PlaygroundTypes::DriveType
    DriveType;
typedef ::org::genivi::vehicle::playgroundtypes::PlaygroundTypes::DoorCommand
    DoorCommand;
typedef ::org::genivi::vehicle::playgroundtypes::PlaygroundTypes::
    CarDoorsCommand CarDoorsCommand;
typedef CommonAPI::Event<uint8_t> CurrentTankVolumeEvent;

class Consumption : public MockedValue<float> {

public:
  Consumption(float v);
  Consumption();
};

class Capacity : public MockedValue<uint8_t> {

private:
  const double m_MinValue;
  const double m_MaxValue;
  const double m_MaxValueInMilliliters;

public:
  Capacity(uint8_t v, double minValue, double maxValue,
           double maxValueInMilliliters);
  Capacity(uint8_t v);
  Capacity();

  double getMinValue();
  double getMaxValue();
  double getMaxValueInMilliliters();
  double getCapacityInLiters();
};

class Volume : public MockedValue<float> {

public:
  Volume(float v);
  Volume();
};

class EngineSpeed : public MockedValue<uint16_t> {

public:
  EngineSpeed(uint16_t v);
  EngineSpeed();
};

class CurrentGear : public MockedValue<Gear> {

public:
  CurrentGear(Gear v);
  CurrentGear();
};

class IsReverseGearOn : public MockedValue<bool> {

public:
  IsReverseGearOn(bool v);
  IsReverseGearOn();
};

class DrivePowerTransmission : public MockedValue<DriveType> {

public:
  DrivePowerTransmission(DriveType v);
  DrivePowerTransmission();
};

class DoorsOpeningStatus : public MockedValue<DoorsStatus> {

public:
  DoorsOpeningStatus(DoorsStatus v);
  DoorsOpeningStatus();

  bool getNextStateFromCommand(const bool &currentState,
                               const DoorCommand &command);
  bool getNextStateFromCommand();
};

class SeatHeatingStatus : public MockedValue<std::vector<bool>> {

public:
  SeatHeatingStatus(std::vector<bool> v);
  SeatHeatingStatus();
};

class SeatHeatingLevel : public MockedValue<std::vector<uint8_t>> {

public:
  SeatHeatingLevel(std::vector<uint8_t> v);
  SeatHeatingLevel();
};

} // namespace Mock

#endif
