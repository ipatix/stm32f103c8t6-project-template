# main configuration
PROGRAM   := helloworld

INC_DIR   := include
SRC_DIR   := src
BUILD_DIR := build

CFLAGS	  := -O2 -flto -I$(INC_DIR)
LDFLAGS   :=

# compilation paths
C_BUILD_DIR := $(BUILD_DIR)/c
C_SRCS := $(shell find src/ -type f -name '*.c')
C_OBJS := $(patsubst %.c,$(C_BUILD_DIR)/%.o,$(C_SRCS))

OBJS := $(C_OBJS)

# toolchain
PREF    := arm-none-eabi
CC      := $(PREF)-gcc
OBJCOPY := $(PREF)-objcopy

# compilation rules
.PHONY: all clean flash
all: $(PROGRAM).bin

clean:
	rm -rf $(PROGRAM).bin $(PROGRAM).elf build/*

$(PROGRAM).bin: $(PROGRAM).elf
	$(OBJCOPY) -O binary $< $@

$(PROGRAM).elf: $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

$(C_BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS)
