ARCHS = armv7 arm64
TARGET := iphone:clang:latest

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = ActiSound
ActiSound_FILES = Listener.xm
ActiSound_LDFLAGS = -lactivator
ActiSound_FRAMEWORKS = UIKit AudioToolbox
ActiSound_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/ActiSound$(ECHO_END)
	$(ECHO_NOTHING)cp -r resources/* $(THEOS_STAGING_DIR)/$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += actisound
include $(THEOS_MAKE_PATH)/aggregate.mk
