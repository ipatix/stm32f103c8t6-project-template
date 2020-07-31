# stm32f103c8t6 Dummy Project

This is a dummy project for the STM32F103C8T6 part, which is used on so-called "blue-pill boards".
It is supposed to ease setting up projects for these kinds of development boards. You only need to check out the repository and run the Makefile to get a working binary file.

libopencm3 is used for accessing the hardware and there is no need to mess around with ugly proprietary libraries. If a newer version of libopencm3 is required, simply update the submodule.

# Setup and Compilation

Requirements: arm-none-eabi Toolchain

```
git submodule update --init
make
```

# Flashing binary file to device

TODO
