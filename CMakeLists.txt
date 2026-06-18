cmake_minimum_required(VERSION 3.16)

include(setup.cmake)

# In multi-binary projects every target has to have a different
# name. So combine the target name with the current project name!
set(TFL_MICRO_TARGET tflite-micro_${PROJECT_NAME})

add_library(${TFL_MICRO_TARGET} INTERFACE)

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
        ${ruy_SOURCE_DIR}
        ${gemmlowp_SOURCE_DIR}
        ${flatbuffers_SOURCE_DIR}/include
        ${cmsis_5_SOURCE_DIR}/CMSIS/Core/Include
        ${cmsis_5_SOURCE_DIR}/CMSIS/Core/
        ${cmsis_nn_SOURCE_DIR}/Include
        ${cmsis_nn_SOURCE_DIR}/
)

