TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Isla

Isla_FILES = Tweak.m View/IslaView.m
Isla_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
