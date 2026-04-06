ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1
THEOS_PACKAGE_SCHEME = rootless
TARGET = iphone:clang:latest:12.1
THEOS_MAKE_PATH ?= $(THEOS)/makefiles

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = FF

FF_FILES = ImGuiDrawView.mm \
           DTTJailbreakDetection.m \
           FTNotificationIndicator.m \
           Il2cpp.cpp \
           LoadView.mm \
           AimKill.cpp \
           imgui.cpp \
           imgui_demo.cpp \
           imgui_draw.cpp \
           imgui_impl_metal.mm \
           imgui_tables.cpp \
           imgui_widgets.cpp \
           mach_excServer.c \
           method.mm \
           oxorany.cpp \
           hook.c

FF_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController Metal MetalKit

# 🔥 INCLUDE PATH (แก้ครบแล้ว)
FF_CFLAGS += -I$(THEOS_PROJECT_DIR) \
             -I$(THEOS_PROJECT_DIR)/Utils \
             -I$(THEOS_PROJECT_DIR)/Security \
             -I$(THEOS_PROJECT_DIR)/imgui

FF_CCFLAGS += -I$(THEOS_PROJECT_DIR) \
              -I$(THEOS_PROJECT_DIR)/Utils \
              -I$(THEOS_PROJECT_DIR)/Security \
              -I$(THEOS_PROJECT_DIR)/imgui

# 🔥 C++ SETTINGS
FF_CCFLAGS += -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -fvisibility=hidden

# 🔥 Obj-C SETTINGS
FF_CFLAGS += -fobjc-arc -fvisibility=hidden

# 🔥 ปิด warning
ifeq ($(IGNORE_WARNINGS),1)
  FF_CFLAGS += -w
  FF_CCFLAGS += -w
endif

include $(THEOS_MAKE_PATH)/library.mk
