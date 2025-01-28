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

#include "PlaygroundStubImpl.hpp"
#include "mock/MockedAttributes.hpp"
#include <cstdint>
#include <csignal>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <sys/types.h>

typedef v1_0::org::genivi::vehicle::playground::PlaygroundStubDefault
    PlaygroundStubDefault;

PlaygroundStubImpl::PlaygroundStubImpl()
    : consumption{}, capacity{}, volume{}, engineSpeed{}, currentGear{},
      isReverseGearOn{}, drivePowerTransmission{}, doorsOpeningStatus{},
      seatHeatingStatus{}, seatHeatingLevel{} {
  initializeAttributes();
}
PlaygroundStubImpl::~PlaygroundStubImpl() {}

void PlaygroundStubImpl::initializeAttributes() {
  PlaygroundStubDefault::setConsumptionAttribute(consumption.getValue());
  PlaygroundStubDefault::setCapacityAttribute(capacity.getValue());
  PlaygroundStubDefault::setVolumeAttribute(volume.getValue());
  PlaygroundStubDefault::setEngineSpeedAttribute(engineSpeed.getValue());
  PlaygroundStubDefault::setCurrentGearAttribute(currentGear.getValue());
  PlaygroundStubDefault::setIsReverseGearOnAttribute(
      isReverseGearOn.getValue());
  PlaygroundStubDefault::setDrivePowerTransmissionAttribute(
      drivePowerTransmission.getValue());
  PlaygroundStubDefault::setDoorsOpeningStatusAttribute(
      doorsOpeningStatus.getValue());
  PlaygroundStubDefault::setSeatHeatingStatusAttribute(
      seatHeatingStatus.getValue());
  PlaygroundStubDefault::setSeatHeatingLevelAttribute(
      seatHeatingLevel.getValue());
}

void PlaygroundStubImpl::updateTankVolume() {
  const float currentVolume = PlaygroundStubDefault::getVolumeAttribute();
  float updatedVolume;
  if (currentVolume > 0.0) {
      updatedVolume = currentVolume - 0.1;
  } else {
      updatedVolume = capacity.getCapacityInLiters();
  }
  PlaygroundStubDefault::setVolumeAttribute(updatedVolume);
}

void PlaygroundStubImpl::monitorTankLevel() {
  const double capacityInLiters = capacity.getCapacityInLiters();
  const int currentVolume = PlaygroundStubDefault::getVolumeAttribute();

  const uint8_t &level = (uint8_t)(100 * currentVolume / capacityInLiters);
  fireCurrentTankVolumeEvent(level);
}

void PlaygroundStubImpl::changeDoorsState(
    const std::shared_ptr<CommonAPI::ClientId> _client,
    CarDoorsCommand _commands, changeDoorsStateReply_t _reply) {

  DoorsStatus lockedDoorsStatus =
      PlaygroundStubDefault::getDoorsOpeningStatusAttribute();

  const bool &currentFrontLeftState = lockedDoorsStatus.getFrontLeft();
  const bool &currentFrontRightState = lockedDoorsStatus.getFrontRight();
  const bool &currentRearLeftState = lockedDoorsStatus.getRearLeft();
  const bool &currentRearRightState = lockedDoorsStatus.getRearRight();

  const DoorCommand &frontLeftCommand = _commands.getFrontLeftDoor();
  const DoorCommand &frontRightCommand = _commands.getFrontRightDoor();
  const DoorCommand &rearLeftCommand = _commands.getRearLeftDoor();
  const DoorCommand &rearRightCommand = _commands.getRearRightDoor();

  const bool &nextFrontLeftState = doorsOpeningStatus.getNextStateFromCommand(
      currentFrontLeftState, frontLeftCommand);
  const bool &nextFrontRightState = doorsOpeningStatus.getNextStateFromCommand(
      currentFrontRightState, frontRightCommand);
  const bool &nextRearLeftState = doorsOpeningStatus.getNextStateFromCommand(
      currentRearLeftState, rearLeftCommand);
  const bool &nextRearRightState = doorsOpeningStatus.getNextStateFromCommand(
      currentRearRightState, rearRightCommand);

  const DoorsStatus &doorsStatus =
      DoorsStatus(nextFrontLeftState, nextFrontRightState, nextRearLeftState,
                  nextRearRightState);

  PlaygroundStubDefault::setDoorsOpeningStatusAttribute(doorsStatus);
  _reply();
};
