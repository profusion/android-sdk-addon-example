
echo "Clonning SOME/IP libs"
if [ ! -d libs/temp/capicxx-someip-runtime ]; then
    git clone https://github.com/COVESA/capicxx-someip-runtime.git libs/temp/capicxx-someip-runtime
fi
if [ ! -d libs/temp/capicxx-core-runtime ]; then
    git clone https://github.com/COVESA/capicxx-core-runtime.git libs/temp/capicxx-core-runtime
fi
if [ ! -d libs/temp/boost ]; then
    git clone https://github.com/boostorg/log.git libs/temp/boost/log
fi
