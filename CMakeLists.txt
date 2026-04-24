cmake_minimum_required(VERSION 3.12)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Specify the target board 
  set(PICO_BOARD pico)
 
  if(DEFINED PICO_SDK_PATH AND EXISTS "${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
      include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
  elseif(DEFINED ENV{PICO_SDK_PATH} AND EXISTS "$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
      include("$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
  else()
     include("${CMAKE_CURRENT_LIST_DIR}/pico_sdk_import.cmake")
  endif()
endif()

project(tflite-micro C CXX ASM)


if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Initialize the Pico SDK
  pico_sdk_init()
endif()

option(TFLITE_MICRO_EXAMPLES "Build tflite micro examples" OFF)

include(project_files.cmake)

add_library(${PROJECT_NAME} STATIC)


target_include_directories(${PROJECT_NAME}
  PUBLIC
  ${CMAKE_CURRENT_LIST_DIR}/
  ${CMAKE_CURRENT_LIST_DIR}/third_party/ruy
  ${CMAKE_CURRENT_LIST_DIR}/third_party/gemmlowp
  ${CMAKE_CURRENT_LIST_DIR}/third_party/flatbuffers/include
  ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS_5/CMSIS/Core/Include
  ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS_5/CMSIS/Core/
  ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS-NN/Include
  ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS-NN//
)

target_compile_definitions(
  ${PROJECT_NAME}
  PUBLIC
  COMPILE_DEFINITIONS TF_LITE_DISABLE_X86_NEON=1
  COMPILE_DEFINITIONS TF_LITE_STATIC_MEMORY=1
  COMPILE_DEFINITIONS TF_LITE_USE_CTIME=1
  COMPILE_DEFINITIONS CMSIS_NN=1
)

target_compile_options(${PROJECT_NAME} PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(${PROJECT_NAME}
  PRIVATE
  ${TENSORFLOW_CMSIS_SOURCE_FILES}
  ${TFLITE_MICRO_SOURCE_FILES}
  ${CMSIS_SOURCE_FILES}
)

add_library(tflite-micro-pi-port INTERFACE)
target_sources(tflite-micro-pi-port INTERFACE 
  ${PICO_PORT_FILES}
)

target_link_libraries(tflite-micro-pi-port INTERFACE tflite-micro pico_stdlib hardware_timer)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND TFLITE_MICRO_EXAMPLES)
  add_subdirectory(examples/hello_world)
  add_subdirectory(examples/person_detection)
  message("Build example code!")
endif()