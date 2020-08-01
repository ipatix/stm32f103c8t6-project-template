####################
# main configuration
####################
PROGRAM   := helloworld

INC_DIR   := include
SRC_DIR   := src
BUILD_DIR := build

CFLAGS	  := -O2 -Wall -Wextra -flto -I $(INC_DIR)
LDFLAGS   := -nostartfiles -Wl,--script,linker.ld,--gc-sections --specs=nano.specs --specs=nosys.specs

UART_DEV  := /dev/ttyUSB0

##########################
# libopencm3 configuration
##########################
LIBOPENCM3     := libopencm3
LIBOPENCM3_LIB := $(LIBOPENCM3)/lib/libopencm3_stm32f1.a
LIBOPENCM3_INC := $(LIBOPENCM3)/include
CFLAGS := $(CFLAGS) -I $(LIBOPENCM3_INC) -DSTM32F1 -mcpu=cortex-m3 -mthumb

###################
# compilation paths
###################
C_BUILD_DIR := $(BUILD_DIR)/c
C_SRCS := $(shell find src/ -type f -name '*.c')
C_OBJS := $(patsubst %.c,$(C_BUILD_DIR)/%.o,$(C_SRCS))
# If needed, you can add the same macros for C++ files

OBJS := $(C_OBJS)

###########
# toolchain
###########
PREF    := arm-none-eabi-
CC      := $(PREF)gcc
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
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

$(C_BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS)

$(LIBOPENCM3_LIB):
	$(MAKE) -C $(LIBOPENCM3)
