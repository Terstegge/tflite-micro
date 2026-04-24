
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


project(person_detection C CXX ASM)
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Initialize the Pico SDK
  pico_sdk_init()
  add_subdirectory(${TFLITE_MICRO_PATH} ${CMAKE_CURRENT_BINARY_DIR}/tflite-micro)
endif()

add_executable(detection_responder_test "")

target_include_directories(detection_responder_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(detection_responder_test PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(detection_responder_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/detection_responder.cpp
  ${CMAKE_CURRENT_LIST_DIR}/detection_responder_test.cpp
  ${CMAKE_CURRENT_LIST_DIR}/detection_responder.h
)

target_link_libraries(
  detection_responder_test
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(detection_responder_test 1)
pico_enable_stdio_uart(detection_responder_test 0)

pico_add_extra_outputs(detection_responder_test)


add_executable(person_detection_benchmark "")

target_include_directories(person_detection_benchmark
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(person_detection_benchmark PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(person_detection_benchmark
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/benchmarks/person_detection_benchmark.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/no_person_image_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/person_detect_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/person_image_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/person_detect_model_data.h
)

target_link_libraries(
  person_detection_benchmark
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(person_detection_benchmark 1)
pico_enable_stdio_uart(person_detection_benchmark 0)

pico_add_extra_outputs(person_detection_benchmark)


add_executable(person_detection_test "")

target_include_directories(person_detection_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(person_detection_test PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(person_detection_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.cpp
  ${CMAKE_CURRENT_LIST_DIR}/person_detection_test.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/no_person_image_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/person_detect_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/person_image_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.h
  ${CMAKE_CURRENT_LIST_DIR}/no_person_image_data.h
  ${CMAKE_CURRENT_LIST_DIR}/person_detect_model_data.h
  ${CMAKE_CURRENT_LIST_DIR}/person_image_data.h
)

target_link_libraries(
  person_detection_test
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(person_detection_test 1)
pico_enable_stdio_uart(person_detection_test 0)

pico_add_extra_outputs(person_detection_test)


add_executable(person_detection "")

target_include_directories(person_detection
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(person_detection PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(person_detection
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/detection_responder.cpp
  ${CMAKE_CURRENT_LIST_DIR}/image_provider.cpp
  ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  ${CMAKE_CURRENT_LIST_DIR}/main_functions.cpp
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.cpp
  ${CMAKE_CURRENT_LIST_DIR}/tensorflow/lite/micro/tools/make/downloads/person_model/person_detect_model_data.cpp
  ${CMAKE_CURRENT_LIST_DIR}/detection_responder.h
  ${CMAKE_CURRENT_LIST_DIR}/image_provider.h
  ${CMAKE_CURRENT_LIST_DIR}/main_functions.h
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.h
  ${CMAKE_CURRENT_LIST_DIR}/person_detect_model_data.h
)

target_link_libraries(
  person_detection
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(person_detection 1)
pico_enable_stdio_uart(person_detection 0)

pico_add_extra_outputs(person_detection)


add_executable(image_provider_test "")

target_include_directories(image_provider_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/.
)

target_compile_options(image_provider_test PUBLIC 
  -Os 
  -fno-exceptions 
  -nostdlib 
  $<$<COMPILE_LANGUAGE:CXX>:
      -fno-rtti
      -fno-threadsafe-statics
  >
)

target_sources(image_provider_test
  PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/image_provider.cpp
  ${CMAKE_CURRENT_LIST_DIR}/image_provider_test.cpp
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.cpp
  ${CMAKE_CURRENT_LIST_DIR}/image_provider.h
  ${CMAKE_CURRENT_LIST_DIR}/model_settings.h
)

target_link_libraries(
  image_provider_test
  tflite-micro-pi-port
  hardware_pwm
)

pico_enable_stdio_usb(image_provider_test 1)
pico_enable_stdio_uart(image_provider_test 0)

pico_add_extra_outputs(image_provider_test)

