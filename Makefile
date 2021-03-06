ARCHS = armv7 armv7s arm64 arm64e
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PowerTap
PowerTap_FILES = Tweak.xm PTPreferences.m
PowerTap_FRAMEWORKS = UIKit CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += powertapprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
