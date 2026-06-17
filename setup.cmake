# This script will automatically call the setup_pico.sh script,
# which initializes some third party repositories needed by
# this version of tflite-micro.

if (NOT DEFINED YAHAL_DIR)
    message(FATAL_ERROR "YAHAL_DIR not set. Please call this script only after importing YAHAL!")
else()
    # Marker file to check if script was already run
    set(SETUP_MARKER_FILE "${CMAKE_CURRENT_LIST_DIR}/third_party/ruy/LICENSE")

    # Check is marker file is existing
    if(NOT EXISTS "${SETUP_MARKER_FILE}")
        # Run setup script
        execute_process(
                COMMAND sh ${CMAKE_CURRENT_LIST_DIR}/setup.sh
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                RESULT_VARIABLE SCRIPT_ERROR_CODE
        )
        if(NOT SCRIPT_ERROR_CODE EQUAL 0)
            message(FATAL_ERROR "setup script for tflite-micro failed!")
        endif()
    endif()
endif()
