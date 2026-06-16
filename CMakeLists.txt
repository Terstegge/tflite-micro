cmake_minimum_required(VERSION 3.16)

# In multi-binary projects every target has to have a different
# name. So combine the target name with the current project name!
set(TFL_MICRO_TARGET tflite-micro_${PROJECT_NAME})

set(SETUP_MARKER_FILE "${CMAKE_CURRENT_LIST_DIR}/third_party/flatbuffers/LICENSE")
add_custom_command(
        OUTPUT  "${SETUP_MARKER_FILE}"
        COMMAND bash ${CMAKE_CURRENT_LIST_DIR}/setup_pico.sh
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMENT "Initialize tflite-micro Library ..."
)
add_custom_target(tflite_setup_deps DEPENDS "${SETUP_MARKER_FILE}")

add_library(${TFL_MICRO_TARGET} INTERFACE)

add_dependencies(${TFL_MICRO_TARGET}
        tflite_setup_deps
)

target_compile_options(${TFL_MICRO_TARGET}
        INTERFACE -Os -Wno-unused-parameter
)

set_property(TARGET ${TFL_MICRO_TARGET}
        PROPERTY CXX_STANDARD 20
)

include(project_files.cmake)
target_sources(${TFL_MICRO_TARGET} INTERFACE
        ${TENSORFLOW_CMSIS_SOURCE_FILES}
        ${TFLITE_MICRO_SOURCE_FILES}
        ${CMSIS_SOURCE_FILES}
        ${YAHAL_PORT_FILES}
)

target_compile_definitions(${TFL_MICRO_TARGET} INTERFACE
        COMPILE_DEFINITIONS TF_LITE_DISABLE_X86_NEON=1
        COMPILE_DEFINITIONS TF_LITE_STATIC_MEMORY=1
        COMPILE_DEFINITIONS TF_LITE_USE_CTIME=1
        COMPILE_DEFINITIONS CMSIS_NN=1
)

target_include_directories(${TFL_MICRO_TARGET} INTERFACE
        ${CMAKE_CURRENT_LIST_DIR}/
        ${CMAKE_CURRENT_LIST_DIR}/third_party/ruy
        ${CMAKE_CURRENT_LIST_DIR}/third_party/gemmlowp
        ${CMAKE_CURRENT_LIST_DIR}/third_party/flatbuffers/include
        ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS_5/CMSIS/Core/Include
        ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS_5/CMSIS/Core/
        ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS-NN/Include
        ${CMAKE_CURRENT_LIST_DIR}/third_party/CMSIS-NN//
)


#if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
#  # Specify the target board
#  set(PICO_BOARD pico)
#
#  if(DEFINED PICO_SDK_PATH AND EXISTS "${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
#      include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
#  elseif(DEFINED ENV{PICO_SDK_PATH} AND EXISTS "$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
#      include("$ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake")
#  else()
#     include("${CMAKE_CURRENT_LIST_DIR}/pico_sdk_import.cmake")
#  endif()
#endif()

#project(tflite-micro C CXX ASM)


#if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
#  # Initialize the Pico SDK
#  pico_sdk_init()
#endif()

#option(TFLITE_MICRO_EXAMPLES "Build tflite micro examples" OFF)


#add_library(${PROJECT_NAME} STATIC)






#add_library(tflite-micro-pi-port INTERFACE)
#target_sources(tflite-micro-pi-port INTERFACE
#  ${PICO_PORT_FILES}
#)

#target_link_libraries(tflite-micro-pi-port INTERFACE tflite-micro pico_stdlib hardware_timer)

#if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND TFLITE_MICRO_EXAMPLES)
#  add_subdirectory(examples/hello_world)
#  add_subdirectory(examples/person_detection)
#  message("Build example code!")
#endif()


#set(CMAKE_C_STANDARD 11)
#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
