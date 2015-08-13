#
# Copyright 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifeq ($(BOARD_HAVE_BLUETOOTH_QCOM),true)

include $(CLEAR_VARS)

#logging headers
LOCAL_HEADER_LIBRARIES := libutils_headers
LOCAL_SRC_FILES := \
        src/bt_vendor_qcom.c \
        src/hardware.c \
        src/hci_uart.c \
        src/hci_smd.c \
        src/hw_rome.c \
        src/hw_ar3k.c \
        src/bt_vendor_persist.cpp

# By default, "ENABLE_FM_OVER_UART" is un-defined.
# To enable the feature, set it as "true" in "BoardConfig.mk".
ifeq ($(ENABLE_FM_OVER_UART), true)
LOCAL_CFLAGS := -DFM_OVER_UART
endif

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
LOCAL_CFLAGS += -DPANIC_ON_SOC_CRASH
LOCAL_CFLAGS += -DENABLE_DBG_FLAGS
endif

LOCAL_C_INCLUDES += \
        $(LOCAL_PATH)/include \
        external/bluetooth/bluedroid/hci/include \
        vendor/qcom/opensource/commonsys/system/bt/hci/include \
        $(TARGET_OUT_HEADERS)/bt/hci_qcomm_init \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include

LOCAL_ADDITIONAL_DEPENDENCIES += \
$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

ifeq ($(BOARD_HAS_QCA_BT_AR3002), true)
LOCAL_C_FLAGS := \
        -DBT_WAKE_VIA_PROC
endif #BOARD_HAS_QCA_BT_AR3002

ifeq ($(WIFI_BT_STATUS_SYNC), true)
LOCAL_CFLAGS += -DWIFI_BT_STATUS_SYNC
endif #WIFI_BT_STATUS_SYNC

LOCAL_SHARED_LIBRARIES := \
        libcutils \
        liblog

LOCAL_MODULE := libbt-vendor
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_OWNER := qcom

ifdef TARGET_2ND_ARCH
LOCAL_MODULE_PATH_32 := $(TARGET_OUT_VENDOR)/lib
LOCAL_MODULE_PATH_64 := $(TARGET_OUT_VENDOR)/lib64
else
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)
endif

ifeq ($(QCOM_BT_USE_BTNV),true)
LOCAL_CFLAGS += -DBT_NV_SUPPORT
LOCAL_CFLAGS += -Wno-unused-variable
LOCAL_CFLAGS += -Wno-unused-label
LOCAL_CFLAGS += -Wno-user-defined-warnings
LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-incompatible-pointer-types-discards-qualifiers
LOCAL_CFLAGS += -Wno-unused-function
LOCAL_CFLAGS += -Wno-enum-conversion

ifeq ($(QCPATH),)
LOCAL_SHARED_LIBRARIES += libdl
LOCAL_CFLAGS += -DBT_NV_SUPPORT_DL
else
LOCAL_SHARED_LIBRARIES += libbtnv
endif
endif

ifneq ($(BOARD_ANT_WIRELESS_DEVICE),)
LOCAL_CFLAGS += -DENABLE_ANT
endif
#LOCAL_CFLAGS += -DREAD_BT_ADDR_FROM_PROP

#include $(LOCAL_PATH)/vnd_buildcfg.mk

include $(BUILD_SHARED_LIBRARY)

endif # BOARD_HAVE_BLUETOOTH_QCOM
