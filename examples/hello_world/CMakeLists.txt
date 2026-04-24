
cmake_minimum_required(VERSION 3.12)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Specify the target board 
  set(PICO_BOARD pico2)
  if(DEFINED PICO_SDK_PATH AND EXISTS "${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
      include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
  elseif(DEFINED ENV{PICO_SDK_PATH} AND EXISTS "$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
      include("$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
  else()
      include("${CMAKE_CURRENT_LIST_DIR}/pico_sdk_import.cmake")
  endif()
endif()

project(hello_world C CXX ASM)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Initialize the Pico SDK
  pico_sdk_init()
  add_subdirectory(${TFLITE_MICRO_PATH} ${CMAKE_CURRENT_BINARY_DIR}/tflite-micro)
endif()

add_executable(hello_world_test "")

target_include_directories(hello_world_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(hello_world_test PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(hello_world_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/hello_world_float_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/hello_world_int8_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/hello_world_test.cpp
)

target_link_libraries(
  hello_world_test
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(hello_world_test 1)
pico_enable_stdio_uart(hello_world_test 0)

pico_add_extra_outputs(hello_world_test)


add_executable(hello_world "")

target_include_directories(hello_world
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(hello_world PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(hello_world
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/constants.cpp
  ${CMAKE_CURRENT_LIST_DIR}/hello_world_float_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/hello_world_int8_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  ${CMAKE_CURRENT_LIST_DIR}/main_functions.cpp
  ${CMAKE_CURRENT_LIST_DIR}/rp2/output_handler.cpp
  ${CMAKE_CURRENT_LIST_DIR}/constants.h
  ${CMAKE_CURRENT_LIST_DIR}/main_functions.h
  ${CMAKE_CURRENT_LIST_DIR}/output_handler.h
)

target_link_libraries(
  hello_world PRIVATE
  hardware_pwm
  tflite-micro-pi-port
)

pico_enable_stdio_usb(hello_world 1)
pico_enable_stdio_uart(hello_world 0)

pico_add_extra_outputs(hello_world)


add_executable(output_handler_test "")

target_include_directories(output_handler_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(output_handler_test PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)
target_sources(output_handler_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/output_handler_test.cpp
  ${CMAKE_CURRENT_LIST_DIR}/rp2/output_handler.cpp
  ${CMAKE_CURRENT_LIST_DIR}/constants.h
  ${CMAKE_CURRENT_LIST_DIR}/output_handler.h
)

target_link_libraries(
  output_handler_test
  tflite-micro-pi-port
  hardware_pwm
)

pico_add_extra_outputs(output_handler_test)

