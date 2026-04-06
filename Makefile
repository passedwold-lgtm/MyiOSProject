ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1
THEOS_PACKAGE_SCHEME = rootless
TARGET = iphone:clang:latest:12.1
THEOS_MAKE_PATH ?= $(THEOS)/makefiles

include /var/theos/makefiles/common.mk

TWEAK_NAME = FF

SECURITY_SRC = $(wildcard Security/*.mm) $(wildcard Security/oxorany/*.cpp)
LOADVIEW_SRC = $(wildcard LoadView/*.mm) $(wildcard LoadView/*.m)
IMGUI_SRC = $(wildcard imgui/*.cpp) $(wildcard imgui/*.mm)

FF_FILES = ImGuiDrawView.mm $(SECURITY_SRC) $(LOADVIEW_SRC) $(IMGUI_SRC) $(wildcard hook/*.c) $(wildcard Hosts/*.m)

FF_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController Metal MetalKit

FF_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -fvisibility=hidden

FF_CFLAGS = -fobjc-arc -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function -fvisibility=hidden

ifeq ($(IGNORE_WARNINGS),1)
  FF_CFLAGS += -w
  FF_CCFLAGS += -w
endif

include $(THEOS_MAKE_PATH)/tweak.mk