ARCHS = armv7 arm64
TARGET := iphone:clang:latest

include theos/makefiles/common.mk

BUNDLE_NAME = ActiSound
ActiSound_FILES = ActiSound.mm
ActiSound_INSTALL_PATH = /Library/PreferenceBundles
ActiSound_FRAMEWORKS = UIKit AudioToolbox
ActiSound_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ActiSound.plist$(ECHO_END)
