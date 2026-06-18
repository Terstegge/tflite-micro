# This script will automatically pull in all needed
# dependencies for this version of tflite-micro.

if (NOT DEFINED YAHAL_DIR)
    message(FATAL_ERROR "YAHAL_DIR not set. Please call this script only after importing YAHAL!")
else()
    include(FetchContent)

    # Avoid CMP0169 deprecation warning for FetchContent_Populate.
    # We use Populate (not MakeAvailable) because these deps are
    # header/source-only and must NOT be add_subdirectory'd with
    # the ARM cross-compiler (flatbuffers builds a host tool 'flatc',
    # ruy uses std::mutex/condition_variable unavailable with -fno-exceptions).
    if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.30)
        cmake_policy(SET CMP0169 OLD)
    endif()

    message("Installing tflite-micro dependencies. Please wait...")

    FetchContent_Declare(flatbuffers
            GIT_REPOSITORY https://github.com/google/flatbuffers.git
            GIT_TAG v25.9.23
            GIT_SHALLOW TRUE
    )
    FetchContent_Declare(ruy
            GIT_REPOSITORY https://github.com/google/ruy.git
            GIT_TAG master
            GIT_SHALLOW TRUE
    )
    FetchContent_Declare(cmsis_nn
            GIT_REPOSITORY https://github.com/ARM-software/CMSIS-NN.git
            GIT_TAG v7.0.0
            GIT_SHALLOW TRUE
    )
    FetchContent_Declare(cmsis_5
            GIT_REPOSITORY https://github.com/ARM-software/CMSIS_5.git
            GIT_TAG master
            GIT_SHALLOW TRUE
    )
    FetchContent_Declare(gemmlowp
            GIT_REPOSITORY https://github.com/google/gemmlowp.git
            GIT_TAG master
            GIT_SHALLOW TRUE
    )

    foreach(DEP flatbuffers ruy cmsis_nn cmsis_5 gemmlowp)
        FetchContent_GetProperties(${DEP})
        if(NOT ${DEP}_POPULATED)
            FetchContent_Populate(${DEP})
        endif()
    endforeach()
endif()
