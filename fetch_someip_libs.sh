#!/bin/bash

echo "Clonning COMMONAPI libs"
if [ ! -d "libs" ]; then
    mkdir libs
fi
cd libs
if [ ! -d "capicxx-someip-runtime" ]; then
    git clone -b 3.2.0 https://github.com/COVESA/capicxx-someip-runtime.git capicxx-someip-runtime
    sed -i '26s/.*/    "libvsomeip3",/' capicxx-someip-runtime/Android.bp
fi
if [ ! -d "capicxx-core-runtime" ]; then
    git clone -b 3.2.0 https://github.com/COVESA/capicxx-core-runtime.git capicxx-core-runtime
fi
mkdir -p someip-generators
if [ ! -d "someip-generators/commonapi_someip_generator" ]; then
    wget https://github.com/COVESA/capicxx-someip-tools/releases/download/3.2.0.1/commonapi_someip_generator.zip
    unzip commonapi_someip_generator.zip -d someip-generators/commonapi_someip_generator
    rm commonapi_someip_generator.zip
fi
if [ ! -d "someip-generators/commonapi_core_generator" ]; then
    wget https://github.com/COVESA/capicxx-core-tools/releases/download/3.2.0.1/commonapi_core_generator.zip
    unzip commonapi_core_generator.zip -d someip-generators/commonapi_core_generator
    rm commonapi_core_generator.zip
fi
