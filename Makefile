####################
# main configuration
####################
PROGRAM   := helloworld

INC_DIR   := include
SRC_DIR   := src
BUILD_DIR := build

CFLAGS	  := -O2 -Wall -Wextra -flto -I $(INC_DIR)
CXXFLAGS  := -O2 -Wall -Wextra -flto -I $(INC_DIR) -fno-exceptions -fno-rtti
LDFLAGS   := -nostartfiles -Wl,--script,linker.ld,--gc-sections,-Map=$(PROGRAM).map --specs=nano.specs --specs=nosys.specs

UART_DEV  := /dev/ttyUSB0

##########################
# libopencm3 configuration
##########################
LIBOPENCM3     := libopencm3
LIBOPENCM3_LIB := $(LIBOPENCM3)/lib/libopencm3_stm32f1.a
LIBOPENCM3_INC := $(LIBOPENCM3)/include
LIBOPENCM3_FLAGS := -I $(LIBOPENCM3_INC) -DSTM32F1 -mcpu=cortex-m3 -mthumb
CFLAGS   := $(CFLAGS) $(LIBOPENCM3_FLAGS)
CXXFLAGS := $(CXXFLAGS) $(LIBOPENCM3_FLAGS)

###################
# compilation paths
###################
C_BUILD_DIR := $(BUILD_DIR)/c
C_SRCS := $(shell find src/ -type f -name '*.c')
C_OBJS := $(patsubst %.c,$(C_BUILD_DIR)/%.o,$(C_SRCS))

CXX_BUILD_DIR := $(BUILD_DIR)/cxx
CXX_SRCS := $(shell find src/ -type f -name '*.cpp')
CXX_OBJS := $(patsubst %.cpp,$(CXX_BUILD_DIR)/%.o,$(CXX_SRCS))

OBJS := $(C_OBJS) $(CXX_OBJS)

###########
# toolchain
###########
PREF    := arm-none-eabi-
CC      := $(PREF)gcc
CXX     := $(PREF)g++
LD      := $(CXX)
OBJCOPY := $(PREF)objcopy

###################
# compilation rules
###################
.PHONY: all clean flash devstat $(LIBOPENCM3)
all: $(PROGRAM).bin

clean:
	rm -rf $(PROGRAM).bin $(PROGRAM).elf build/*
	make -C $(LIBOPENCM3) clean

flash: $(PROGRAM).bin
	stm32flash -w $(PROGRAM).bin $(UART_DEV)

devstat:
	stm32flash $(UART_DEV)

$(PROGRAM).bin: $(PROGRAM).elf
	$(OBJCOPY) -O binary $< $@

$(PROGRAM).elf: $(OBJS) $(LIBOPENCM3_LIB)
	$(LD) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

$(C_BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS)

$(CXX_BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

$(LIBOPENCM3_LIB):
	$(MAKE) -C $(LIBOPENCM3)
