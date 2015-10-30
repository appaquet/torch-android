LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := torch-lua-static
LOCAL_SRC_FILES := ../../lib/libtorch-lua-static.a
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := luaT
LOCAL_SRC_FILES := ../../lib/libluaT.a
LOCAL_STATIC_LIBRARIES += torch-lua-static
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := TH
LOCAL_SRC_FILES := ../../lib/libTH_static.a
LOCAL_STATIC_LIBRARIES += luaT
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := paths
LOCAL_SRC_FILES := ../../lib/libpaths.a
LOCAL_STATIC_LIBRARIES += TH
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := sys
LOCAL_SRC_FILES := ../../lib/libsys.a
LOCAL_STATIC_LIBRARIES += paths
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := torch
LOCAL_SRC_FILES := ../../lib/libtorch.a
LOCAL_STATIC_LIBRARIES += sys
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := nn
LOCAL_SRC_FILES := ../../lib/libnn.a
LOCAL_STATIC_LIBRARIES += torch
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := nnx
LOCAL_SRC_FILES := ../../lib/libnnx.a
LOCAL_STATIC_LIBRARIES += nn
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := fftw
LOCAL_SRC_FILES := ../../../fftw-3.3.4/build/lib/libfftw3.a
LOCAL_STATIC_LIBRARIES += nnx
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := audio
LOCAL_SRC_FILES := ../../lib/libaudio.a
LOCAL_STATIC_LIBRARIES += fftw
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := image
LOCAL_SRC_FILES := ../../lib/libimage.a
LOCAL_STATIC_LIBRARIES += audio
include $(PREBUILT_STATIC_LIBRARY)

LOCAL_MODULE := imgraph
LOCAL_SRC_FILES := ../../lib/libimgraph.a
LOCAL_STATIC_LIBRARIES += image
include $(PREBUILT_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_MODULE := torchdemo
LOCAL_STATIC_LIBRARIES += imgraph
LOCAL_C_INCLUDES += ../include/torch
LOCAL_C_INCLUDES += ../include/
LOCAL_SRC_FILES := torchandroid.cpp torchdemo.cpp android_fopen.c

LOCAL_LDLIBS := -llog -landroid

include $(BUILD_SHARED_LIBRARY)
