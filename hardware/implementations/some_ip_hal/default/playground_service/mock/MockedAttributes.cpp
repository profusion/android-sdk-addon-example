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

#include "MockedAttributes.hpp"
#include <cstdint>

namespace Mock {

Consumption::Consumption(float v) : MockedValue<float>{v} {};

Consumption::Consumption() : MockedValue<float>{4.5} {};

Capacity::Capacity(uint8_t v, double minValue, double maxValue,
                   double maxValueInMilliliters)
    : MockedValue<uint8_t>{v}, m_MinValue(minValue), m_MaxValue(maxValue),
      m_MaxValueInMilliliters(maxValueInMilliliters){};

Capacity::Capacity(uint8_t v)
    : MockedValue<uint8_t>{v}, m_MinValue(0.0), m_MaxValue(255.0),
      m_MaxValueInMilliliters(80000.0){};

Capacity::Capacity()
    : MockedValue<uint8_t>{200}, m_MinValue(0.0), m_MaxValue(255.0),
      m_MaxValueInMilliliters(80000.0){};

double Capacity::getMinValue() { return m_MinValue; }

double Capacity::getMaxValue() { return m_MaxValue; }

double Capacity::getMaxValueInMilliliters() { return m_MaxValueInMilliliters; }

double Capacity::getCapacityInLiters() {
  return m_MaxValueInMilliliters * (value / (m_MaxValue - m_MinValue)) / 1000;
}

Volume::Volume(float v) : MockedValue<float>{v} {};

Volume::Volume() : MockedValue<float>{60.8} {};

EngineSpeed::EngineSpeed(uint16_t v) : MockedValue<uint16_t>{v} {};

EngineSpeed::EngineSpeed() : MockedValue<uint16_t>{2000} {};

CurrentGear::CurrentGear(Gear v) : MockedValue<Gear>{v} {};

CurrentGear::CurrentGear()
    : MockedValue<Gear>{Gear(Gear::Literal::FOURTH_GEAR)} {};

IsReverseGearOn::IsReverseGearOn(bool v) : MockedValue<bool>{v} {};

IsReverseGearOn::IsReverseGearOn() : MockedValue<bool>{false} {};

DrivePowerTransmission::DrivePowerTransmission(DriveType v)
    : MockedValue<DriveType>{v} {};

DrivePowerTransmission::DrivePowerTransmission()
    : MockedValue<DriveType>{
          DriveType(DriveType::Literal::REAR_WHEEL_DRIVE)} {};

DoorsOpeningStatus::DoorsOpeningStatus(DoorsStatus v)
    : MockedValue<DoorsStatus>{v} {};

DoorsOpeningStatus::DoorsOpeningStatus()
    : MockedValue<DoorsStatus>{DoorsStatus(true, false, false, false)} {};

bool DoorsOpeningStatus::getNextStateFromCommand(const bool &currentState,
                                                 const DoorCommand &command) {
  if (command == DoorCommand::Literal::NOTHING) {
    return currentState;
  }
  return (command == DoorCommand::Literal::OPEN_DOOR);
}

SeatHeatingStatus::SeatHeatingStatus(std::vector<bool> v)
    : MockedValue<std::vector<bool>>{v} {};

SeatHeatingStatus::SeatHeatingStatus()
    : MockedValue<std::vector<bool>>{
          {true, true, false, true, false, true, false}} {};

SeatHeatingLevel::SeatHeatingLevel(std::vector<uint8_t> v)
    : MockedValue<std::vector<uint8_t>>{v} {};

SeatHeatingLevel::SeatHeatingLevel()
    : MockedValue<std::vector<uint8_t>>{{50, 45, 30, 30, 60, 65, 70}} {};

} // namespace Mock
