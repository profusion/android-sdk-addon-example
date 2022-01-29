#!/bin/bash

set -e

GIT_ROOT="$(git rev-parse --show-toplevel)"

AOSP="$1"

if [ ! -d "$AOSP" ]; then
    printf "Directory %s does not exists" "$AOSP"
fi

echo "Overriting build/target"
rsync -a --inplace "$GIT_ROOT"/build/target "$AOSP"/build/make

echo "Copying profusion sdk addon to device"
rsync -a --inplace "$GIT_ROOT"/device "$AOSP"

echo "Copying helloworld service to the framework"
rsync -a --inplace "$GIT_ROOT"/packages "$AOSP"

date '+%Y/%m/%d %H:%M:%S'
