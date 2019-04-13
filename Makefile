ARCHS = armv7 arm64
THEOS_DEVICE_IP=xxx-xxx-xxx-xxx
THEOS_DEVICE_PORT=22
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ReplaceThis
ReplaceThis_FILES = Tweak.xm
ReplaceThis_FRAMEWORKS = UIKit WebKit
ReplaceThis_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk
