LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

TMP_LOCAL_PATH := $(LOCAL_PATH)

include $(TMP_LOCAL_PATH)/libbt-vendor/Android.mk

include $(TMP_LOCAL_PATH)/tools/Android.mk

ifeq ($(TARGET_USE_QTI_BT_STACK),true)
include $(TMP_LOCAL_PATH)/bthost_ipc/Android.mk
endif #TARGET_USE_QTI_BT_STACK
