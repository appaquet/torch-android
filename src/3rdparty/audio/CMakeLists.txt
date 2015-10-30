CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
CMAKE_POLICY(VERSION 2.8)


FIND_PACKAGE(Torch REQUIRED)

SET(SOX_INCLUDE_DIR "/path/to/sox-code/build/include/")
SET(SOX_LIBRARIES "/path/to/sox-code/build/lib/liblibsox.a")
SET(FFTW_INCLUDE_DIR "/path/to/fftw-3.3.4/build/include/")
SET(FFTW_LIBRARIES "/path/to/fftw-3.3.4/build/lib/libfftw3.a")

SET(src sox.c)
include_directories (${SOX_INCLUDE_DIR})
ADD_TORCH_PACKAGE(sox "${src}" "${luasrc}" "Audio Processing")
TARGET_LINK_LIBRARIES(sox luaT TH ${SOX_LIBRARIES})

include_directories (${FFTW_INCLUDE_DIR})
SET(src audio.c)
SET(luasrc init.lua voice.mp3)
ADD_TORCH_PACKAGE(audio "${src}" "${luasrc}" "Audio Processing")
TARGET_LINK_LIBRARIES(audio luaT TH ${SOX_LIBRARIES} ${FFTW_LIBRARIES})
