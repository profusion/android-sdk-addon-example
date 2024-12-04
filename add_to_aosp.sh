#!/bin/bash

set -e

GIT_ROOT="$(git rev-parse --show-toplevel)"

AOSP="$1"

if [ ! -d "$AOSP" ]; then
    printf "Directory %s does not exists" "$AOSP"
fi

echo "Overriting target"
rsync -a --inplace "$GIT_ROOT"/target/car_generic_system.mk "$AOSP"/packages/services/Car/car_product/build
rsync -a --inplace "$GIT_ROOT"/target/sdk_car_x86_64.mk "$AOSP"/device/generic/car
rsync -a --inplace "$GIT_ROOT"/target/userdata.img "$AOSP"/device/generic/goldfish/data/etc

echo "Copying profusion sdk addon to device"
rsync -a --inplace "$GIT_ROOT"/device "$AOSP"

echo "Copying helloworld service to the framework"
rsync -a --inplace "$GIT_ROOT"/packages "$AOSP"

mkdir -p "$AOSP"/out/target/product/emulator_car64_x86_64/data

date '+%Y/%m/%d %H:%M:%S'
