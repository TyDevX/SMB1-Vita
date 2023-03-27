cmake_minimum_required(VERSION 3.5)

## This includes the Vita toolchain, must go before project definition
# It is a convenience so you do not have to type
# -DCMAKE_TOOLCHAIN_FILE=$VITASDK/share/vita.toolchain.cmake for cmake. It is
# highly recommended that you include this block for all projects.
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  if(DEFINED ENV{VITASDK})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VITASDK}/share/vita.toolchain.cmake" CACHE PATH "toolchain file")
  else()
    message(FATAL_ERROR "Please define VITASDK to point to your SDK path!")
  endif()
endif()

project(smbc)
include("${VITASDK}/share/vita.cmake" REQUIRED)

## Configuration options for this app
# Display name (under bubble in LiveArea)
set(VITA_APP_NAME "SMB1 Vita")
# Unique ID must be exactly 9 characters. Recommended: XXXXYYYYY where X =
# unique string of developer and Y = a unique number for this app
set(VITA_TITLEID  "SMB1V0000")
# Optional version string to show in LiveArea's more info screen
set(VITA_VERSION  "01.00")

# Compiler flags
set(CMAKE_CXX_FLAGS "-std=c++11 -Wno-c++11-narrowing")
set(VITA_MKSFOEX_FLAGS "${VITA_MKSFOEX_FLAGS} -d PARENTAL_LEVEL=1")

include_directories(
  /home/user/vitasdk/arm-vita-eabi/include
)

# Directories
set(SRC_DIR "source")
set(CODEGEN_DIR "codegen")

# Source files
set(SOURCE_FILES
    ${SRC_DIR}/Configuration.cpp
    ${SRC_DIR}/Main.cpp
    ${SRC_DIR}/Emulation/APU.cpp
    ${SRC_DIR}/Emulation/Controller.cpp
    ${SRC_DIR}/Emulation/MemoryAccess.cpp
    ${SRC_DIR}/Emulation/PPU.cpp
    ${SRC_DIR}/SMB/SMB.cpp
    ${SRC_DIR}/SMB/SMBData.cpp
    ${SRC_DIR}/SMB/SMBEngine.cpp
    ${SRC_DIR}/Util/Video.cpp
)

# Library to link to (drop the -l prefix). This will mostly be stubs.
target_link_libraries(smbc
  SDL2
  vita2d
  openal
  vitaGL
  vitashark
  SceShaccCgExt
  mathneon
  mpg123
  taihen_stub
  kubridge_stub
  SceAppMgr_stub
  SceAppUtil_stub
  SceAudio_stub
  SceAudioIn_stub
  SceCtrl_stub
  SceCommonDialog_stub
  SceDisplay_stub
  SceKernelDmacMgr_stub
  SceFios2_stub
  SceGxm_stub
  SceLibcBridge_stub
  SceShaccCg_stub
  SceSysmodule_stub
  ScePower_stub
  SceTouch_stub
  SceVshBridge_stub
  m
)

# Libraries
set(LIBRARIES "-lSDL2")

# Build targets
add_executable(smbc ${SOURCE_FILES})
target_link_libraries(smbc ${LIBRARIES})

# Build code generation
add_custom_target(code_generation ALL
    COMMAND ${CMAKE_MAKE_PROGRAM}
    WORKING_DIRECTORY ${CODEGEN_DIR}
)

## Create Vita files
vita_create_self(${PROJECT_NAME}.self ${PROJECT_NAME})
# The FILE directive lets you add additional files to the VPK, the syntax is
# FILE src_path dst_path_in_vpk. In this case, we add the LiveArea paths.
vita_create_vpk(SMB1Vita.vpk ${VITA_TITLEID} eboot.bin
  VERSION ${VITA_VERSION}
  NAME ${VITA_APP_NAME}
  FILE sce_sys/icon0.png sce_sys/icon0.png
  FILE sce_sys/livearea/contents/bg.png sce_sys/livearea/contents/bg.png
  FILE sce_sys/livearea/contents/startup.png sce_sys/livearea/contents/startup.png
  FILE sce_sys/livearea/contents/template.xml sce_sys/livearea/contents/template.xml
)