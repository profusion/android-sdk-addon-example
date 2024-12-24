
echo "Clonning SOME/IP libs"
if [ ! -d "libs/temp" ]; then
    mkdir libs/temp
fi
cd libs/temp
if [ ! -d "capicxx-someip-runtime" ]; then
    git clone https://github.com/COVESA/capicxx-someip-runtime.git capicxx-someip-runtime
fi
if [ ! -d "capicxx-core-runtime" ]; then
    git clone https://github.com/COVESA/capicxx-core-runtime.git capicxx-core-runtime
fi
if [ ! -d "boost" ]; then
    git clone https://github.com/boostorg/log.git boost/log
fi
cd ..
mkdir -p generators
if [ ! -d "generators/commonapi_someip_generator" ]; then
    wget https://github.com/COVESA/capicxx-someip-tools/releases/download/3.2.15/commonapi_someip_generator.zip
    unzip commonapi_someip_generator.zip -d generators/commonapi_someip_generator
    rm commonapi_someip_generator.zip
fi
if [ ! -d "generators/commonapi_core_generator" ]; then
    wget https://github.com/COVESA/capicxx-core-tools/releases/download/3.2.15/commonapi_core_generator.zip
    unzip commonapi_core_generator.zip -d generators/commonapi_core_generator
    rm commonapi_core_generator.zip
fi