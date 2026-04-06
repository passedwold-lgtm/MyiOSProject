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

FF_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -fvisibility=hidden
FF_CFLAGS = -fobjc-arc -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -fvisibility=hidden

ifeq ($(IGNORE_WARNINGS),1)
  FF_CFLAGS += -w
  FF_CCFLAGS += -w
endif

include $(THEOS_MAKE_PATH)/library.mk
