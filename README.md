# stm32f103c8t6 C Project Template

This is a project template for the STM32F103C8T6 part, which is used on so-called "blue-pill boards".
It is supposed to ease setting up projects for these kinds of development boards. You only need to check out the repository and run the Makefile to get a working binary file.
Also, using this project for a different STM32 part is reasonably straight-forward. See the section below.

libopencm3 is used for accessing the hardware and there is no need to mess around with ugly proprietary libraries. If a newer version of libopencm3 is required, simply update the submodule.

# Motivation

I created this because I was annoyed by how complicated other project templates are structured if you just want to start working on a simple program with the GNU-Toolchain.

For example, libopencm3-examples is a project that's easy to compile and it's easy to modify it. However, just taking a single example program of these sub-projects and putting it into a new project is unnecessarily complicated.
Even though I've used it before, I really do not like STM32CubeMX since it comes with all this garbage you don't need. libopencm3 is nice and lightweight and does almost all the things you need, hence why I chose it.

This project works out of the box and only comes with (in my opinion) the necessary components. Only a single Makefile, easy to adjust and to be used as template for any new project.

# Setup and Compilation

Requirements: arm-none-eabi Toolchain

Put your code into the `src` directory, your headers into `include` and you're good to go.

```
git submodule update --init
make
```

# Flashing binary file to device

Because the blue-pill devices do not come with any type of USB bootloader and programmer, we have to rely on the flash method that should work on all STM32 parts.
This works by flashing the device over the STM32's UASRT1 with the pins BOOT0=HIGH and BOOT1=LOW. For this purpose, I like to use [stm32flash](https://github.com/ARMinARM/stm32flash).

Hook up your device like this:
```
PA9  (TX) <----> USB-Serial-Adapter (RX)
PA10 (RX) <----> USB-Serial-Adapter (TX)
```
Also remember to always check the datasheet for voltages. The STM32F103C8T6 has 5V tolerant pins, so you can use a 5V TTL level USB-adapter. This may be different for other STM32 devices!
Obviously, your device should be powered when trying to write to flash.

For this purpose, the Makefile contains a setting `UART_DEV` which you should set to whatever is your UART device (e.g. `/dev/ttyUSB0` on Linux, `COM3` on Windows).

After the program is compiled, simply type the following to check whether the device is detected:
```
make devstat
```
If the device shows up correctly proceed to the next step.
```
make flash
```
After this is done, change your boot pins to BOOT0=LOW and BOOT1=LOW, reset the device and enjoy your running program.

# Porting this project to other STM32 devices

By default, this project is intended to run on a "blue-pill board" which has an STM32F103C8T6 part. If you want to use a different STM32 part you have to do the following:

- Change the 'libopencm3 configuration' section in the Makefile to reference the correct libopencm3 library for the correct part.
- Update the 'linker.ld' linkerscript. Most of the time, you'll just have to adjust the ROM and RAM size to match your part. The one which comes with this project was taken from `libopencm3/lib/stm32/f1/stm32f103_x8.ld`. Other valid linker scripts can be found in the `libopencm3/lib/` tree for reference. Please remember that these only get generated once the `make` has been executed in the libopencm3 directory.
- (Optional) Adjust your own code: This dummy project doesn't contain any code yet. However, if you have already started working on your own code, you may have to adjust your own code to be compatible with your new target part.

# Using C++

Currently the Makefile does not support C++ out of the box. I originally intended to just add it but it appears that the linkerscripts of libopencm3 do not fully support C++ at the moment.
If you want to try it nevertheless, just edit the Makefile in the 'compilation paths' section and add C++ (aka CXX) paths. You will also have to add a C++ rule ('compilation rules' section) for compiling the files.

# Misc

By default, the STM32F103C8T6 only has 64k of flash memory. However, in practice a lot of the boards you can by out there actually have 128k of flash.
To utilize all the flash

# License

This project is licensed under the MIT License.
