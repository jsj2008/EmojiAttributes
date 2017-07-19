PACKAGE_VERSION = 1.3.2

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:6.0
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:latest:6.0
endif

include $(THEOS)/makefiles/common.mk

ifeq ($(SIMULATOR),1)
	TWEAK_NAME = EmojiAttributes
else
	LIBRARY_NAME = EmojiAttributes
	EmojiAttributes_INSTALL_PATH = /Library/Application Support/EmojiAttributes
endif
EmojiAttributes_FILES = CharacterSet.xm WebCoreHack.xm CoreFoundationHack.xm TextInputHack.xm
EmojiAttributes_CFLAGS = -std=c++11
EmojiAttributes_FRAMEWORKS = JavaScriptCore
EmojiAttributes_LIBRARIES = icucore substrate
EmojiAttributes_USE_SUBSTRATE = 1

ifneq ($(SIMULATOR),1)
	TWEAK_NAME = EmojiAttributesRun
	EmojiAttributesRun_FILES = Tweak.xm
	include $(THEOS_MAKE_PATH)/library.mk
endif

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(SIMULATOR),1)
all::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/EmojiAttributesRun.plist /opt/simject/$(TWEAK_NAME).plist
endif
