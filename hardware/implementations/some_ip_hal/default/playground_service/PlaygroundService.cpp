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

#include <iostream>
#include <thread>
#include <CommonAPI/CommonAPI.hpp>
#include "PlaygroundStubImpl.hpp"

using namespace std;

int main() {
    std::cout << "SOMEIPPlayground: Successfully Registered Service!" << std::endl;
    std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();
    std::shared_ptr<PlaygroundStubImpl> playgroundService =
    	std::make_shared<PlaygroundStubImpl>();
    runtime->registerService("local", "1", playgroundService);
    std::cout << "SOMEIPPlayground: Successfully Registered Service!" << std::endl;

    while (true) {
        playgroundService->updateTankVolume();
        playgroundService->monitorTankLevel();
        std::cout << "SOMEIPPlayground: Waiting for calls..." << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
    }
    return 0;
 }
 