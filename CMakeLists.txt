cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(JoltC-BindGen LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD          17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS        OFF)

find_package(LLVM REQUIRED CONFIG
    HINTS
        /usr/lib/llvm-22/lib/cmake/llvm
        /usr/lib/llvm-21/lib/cmake/llvm
        /usr/lib/llvm-20/lib/cmake/llvm
        /usr/lib/llvm-19/lib/cmake/llvm
        /usr/lib/llvm-18/lib/cmake/llvm
        /usr/lib/llvm-cmake
        /usr/local/lib/cmake/llvm
        /opt/homebrew/opt/llvm/lib/cmake/llvm
    NO_DEFAULT_PATH
)

if(LLVM_VERSION_MAJOR LESS 20)
    message(FATAL_ERROR
        "LLVM >= 20 required, but found LLVM ${LLVM_PACKAGE_VERSION} "
        "(LLVM_DIR=${LLVM_DIR}).")
endif()

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVM include dirs: ${LLVM_INCLUDE_DIRS}")
message(STATUS "LLVM library dirs: ${LLVM_LIBRARY_DIRS}")

add_definitions(${LLVM_DEFINITIONS})

find_library(LIBCLANG_LIBRARY
    NAMES clang libclang
    HINTS ${LLVM_LIBRARY_DIRS}
    DOC "Path to the libclang shared library"
)

if(NOT LIBCLANG_LIBRARY)
    message(FATAL_ERROR
        "libclang not found under ${LLVM_LIBRARY_DIRS}. "
        "Pass -DLLVM_DIR=/path/to/llvm-20/lib/cmake/llvm to help CMake find it.")
endif()

message(STATUS "Found libclang: ${LIBCLANG_LIBRARY}")

set(JOLTC_BINDGEN_SRC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Core.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Database.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Parse.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Jai/Jai.cpp
)

add_executable(joltc-bindgen ${JOLTC_BINDGEN_SRC_FILES})

target_include_directories(joltc-bindgen PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(joltc-bindgen PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(joltc-bindgen PRIVATE ${LIBCLANG_LIBRARY})
