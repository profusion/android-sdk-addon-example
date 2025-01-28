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

#ifndef PLAYGROUNDSTUBIMPL_H_
#define PLAYGROUNDSTUBIMPL_H_
#include <CommonAPI/CommonAPI.hpp>
#include <cstdint>
#include <v1/org/genivi/vehicle/playground/PlaygroundStubDefault.hpp>

#include "mock/MockedAttributes.hpp"

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

class PlaygroundStubImpl
    : public v1_0::org::genivi::vehicle::playground::PlaygroundStubDefault {
private:
  Mock::Consumption consumption;
  Mock::Capacity capacity;
  Mock::Volume volume;
  Mock::EngineSpeed engineSpeed;
  Mock::CurrentGear currentGear;
  Mock::IsReverseGearOn isReverseGearOn;
  Mock::DrivePowerTransmission drivePowerTransmission;
  Mock::DoorsOpeningStatus doorsOpeningStatus;
  Mock::SeatHeatingStatus seatHeatingStatus;
  Mock::SeatHeatingLevel seatHeatingLevel;

public:
  PlaygroundStubImpl();
  virtual ~PlaygroundStubImpl();

  void initializeAttributes();

  void updateTankVolume();

  void monitorTankLevel();

  virtual void
  changeDoorsState(const std::shared_ptr<CommonAPI::ClientId> _client,
                   CarDoorsCommand _commands, changeDoorsStateReply_t _reply);
};
#endif /* PLAYGROUNDSTUBIMPL_H_ */
