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

