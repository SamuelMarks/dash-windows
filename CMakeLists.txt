cmake_minimum_required(VERSION 3.24)

project(dash-windows VERSION 0.5.13.5 LANGUAGES C)

set(CMAKE_C_STANDARD 90)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Upstream DASH Source Location
if(NOT DEFINED DASH_SOURCE_DIR)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/dash/src/main.c")
        set(DASH_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dash")
    elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../dash/src/main.c")
        set(DASH_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../dash")
    else()
        set(DASH_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/dash")
    endif()
endif()
get_filename_component(DASH_SOURCE_DIR "${DASH_SOURCE_DIR}" ABSOLUTE)

# Fallback to FetchContent if local dash repository not found
if(NOT EXISTS "${DASH_SOURCE_DIR}/src/main.c")
    include(FetchContent)
    FetchContent_Declare(
        dash_upstream
        GIT_REPOSITORY https://github.com/SamuelMarks/dash.git
        GIT_TAG master
    )
    FetchContent_MakeAvailable(dash_upstream)
    set(DASH_SOURCE_DIR "${dash_upstream_SOURCE_DIR}")
endif()

# Fallback to FetchContent for auto-win-msvc
include(FetchContent)
if(NOT TARGET auto-win-msvc)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../auto-win-msvc/CMakeLists.txt")
        if(NOT DEFINED FETCHCONTENT_SOURCE_DIR_AUTO_WIN_MSVC)
            set(FETCHCONTENT_SOURCE_DIR_AUTO_WIN_MSVC "${CMAKE_CURRENT_SOURCE_DIR}/../auto-win-msvc" CACHE PATH "Local auto-win-msvc")
        endif()
        if(NOT DEFINED FETCHCONTENT_SOURCE_DIR_AUTO-WIN-MSVC)
            set(FETCHCONTENT_SOURCE_DIR_AUTO-WIN-MSVC "${CMAKE_CURRENT_SOURCE_DIR}/../auto-win-msvc" CACHE PATH "Local auto-win-msvc")
        endif()
    endif()

    FetchContent_Declare(
        auto_win_msvc
        GIT_REPOSITORY https://github.com/SamuelMarks/auto-win-msvc.git
        GIT_TAG master
    )
    FetchContent_MakeAvailable(auto_win_msvc)
endif()

# Include dash build logic
add_subdirectory("${DASH_SOURCE_DIR}" dash_build)

# Install rules
install(TARGETS dash RUNTIME DESTINATION bin)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/README.md" DESTINATION .)
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE-APACHE")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE-APACHE" DESTINATION .)
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE-MIT")
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE-MIT" DESTINATION .)
endif()

# Package with CPack

enable_testing()
add_test(NAME test_dash_echo COMMAND dash -c "echo DASH native build successful")
add_test(NAME test_dash_arith COMMAND dash -c "test 14 -eq 14")
add_test(NAME test_dash_func COMMAND dash -c "echo in_foo")

include(CPack)
