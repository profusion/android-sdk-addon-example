project(someip-server-playground)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++0x")

find_package(CommonAPI 3.2 REQUIRED)
find_package(CommonAPI-SomeIP 3.2 REQUIRED)
find_package(vsomeip3 3.1.0 REQUIRED)
find_package(Boost 1.71 REQUIRED COMPONENTS system)

add_executable(HelloWorldClient
    src/HelloWorldClient.cpp
)

include_directories(
    ${COMMONAPI_INCLUDE_DIRS}
    ${VSOMEIP3_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(
    HelloWorldClient
    CommonAPI
    CommonAPI-SomeIP
    vsomeip3
    Boost::system
)

add_executable(HelloWorldService
    src/HelloWorldService.cpp
    src/HelloWorldStubImpl.cpp
)
target_link_libraries(
    HelloWorldService
    CommonAPI
    CommonAPI-SomeIP
    vsomeip3
)
