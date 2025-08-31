cmake_minimum_required(VERSION 3.12)

project(tflite-micro C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

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

set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES
  COMPILE_FLAGS -Os
  COMPILE_FLAGS -ffreestanding
  COMPILE_FLAGS -fno-rtti
  COMPILE_FLAGS -fno-exceptions
  COMPILE_FLAGS -fno-threadsafe-statics
  COMPILE_FLAGS -nostdlib
)

target_link_libraries(
  ${PROJECT_NAME}
  pico_stdlib
)


target_sources(${PROJECT_NAME}
  PRIVATE
  ${TENSORFLOW_CMSIS_SOURCE_FILES}
  ${TFLITE_MICRO_SOURCE_FILES}
  ${CMSIS_SOURCE_FILES}
  ${PICO_PORT_FILES}
)

if(TFLITE_MICRO_EXAMPLES)
  add_subdirectory(examples/hello_world)
  add_subdirectory(examples/person_detection)
endif(TFLITE_MICRO_EXAMPLES)
