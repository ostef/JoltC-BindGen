cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(JoltC-BindGen LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD          20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS        OFF)

set(CLANG_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/llvm-21/include")
set(CLANG_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/llvm-21/lib")

if(NOT EXISTS ${CLANG_INCLUDE_DIR})
    set(CLANG_INCLUDE_DIR "/usr/lib/llvm-21/include")
endif()

if(NOT EXISTS ${CLANG_INCLUDE_DIR})
    message(FATAL_ERROR "Clang include directory not found: ${CLANG_INCLUDE_DIR}")
endif()

if(NOT EXISTS ${CLANG_LIB_DIR})
    set(CLANG_LIB_DIR "/usr/lib/llvm-21/lib")
endif()

if(NOT EXISTS ${CLANG_LIB_DIR})
    message(FATAL_ERROR "Clang library directory not found: ${CLANG_LIB_DIR}")
endif()

find_library(LIBCLANG_LIBRARY
    NAMES clang libclang
    PATHS "${CLANG_LIB_DIR}"
    NO_DEFAULT_PATHS
    DOC "Path to the libclang library"
)

if(NOT LIBCLANG_LIBRARY)
    message(FATAL_ERROR "libclang not found under ${CLANG_LIB_DIR}")
endif()

set(JOLTC_BINDGEN_SRC_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Core.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Database.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Parse.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Jai/Jai.cpp
)

add_executable(joltc-bindgen ${JOLTC_BINDGEN_SRC_FILES})

target_include_directories(joltc-bindgen PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(joltc-bindgen PRIVATE ${CLANG_INCLUDE_DIR})
target_link_libraries(joltc-bindgen PRIVATE ${LIBCLANG_LIBRARY})

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(CLANG_LIB_FILE "${CLANG_LIB_DIR}/libclang.dll")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CLANG_LIB_FILE "${CLANG_LIB_DIR}/libclang.so")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CLANG_LIB_FILE "${CLANG_LIB_DIR}/libclang.dylib")
endif()

add_custom_command(TARGET joltc-bindgen POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CLANG_LIB_FILE}"
        "$<TARGET_FILE_DIR:joltc-bindgen>"
)
