## AVR Programming in vscode

This guideline will help you to program your AVR in vscode.

## 1. Tooling

To start pure AVR programming, you need to install the following tools:

* avr-gcc
* avr-objcopy
* avr-objdump
* avr-size
* avrdude

If you're using Arduino UNO, you might want to set your board to DFU mode, and use `dfu-programmer` to program your device. (instead of using `avrdude`), please refer to [this guide](https://support.arduino.cc/hc/en-us/articles/4410804625682-Set-a-board-to-DFU-mode) for more information. In this case, the `Makefile` may not be suitable for you.

**NOTICE: If you want to use arduino again, you have to download the firmware again**

## 2. VS Code

To make sure C/C++ intelligence works, you have to define the `includePath` and `defines` in your `.vscode/c_cpp_properties.json` file.

```json
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${workspaceFolder}/**",
                "/opt/homebrew/Cellar/avr-gcc@9/9.3.0_3/avr/include/" // or replace with your own include path
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE",
                "F_CPU=16000000L",
                "ARDUINO=10805",
                "ARDUINO_AVR_UNO",
                "ARDUINO_ARCH_AVR"
            ],
            "compilerPath": "/opt/homebrew/bin/avr-gcc", // don't use clan-gcc or some variable won't be resolved 
            "compilerArgs": [
							"-mmcu=atmega32u4" // I'm using atmega32u4 but you can use any other AVR mcu
            ],
            "cStandard": "c17",
            "cppStandard": "c++98",
            "intelliSenseMode": "macos-clang-arm64"
        }
    ],
    "version": 4
}
```

## 3. Makefile

This Makefile is used to compile the source code. Some commands available:

* `make xxx.hex`: for example, if you type `make hello.hex`, it will compile the `hello/*.c` files and generate the `hello.hex` file in `hello` folder. If you don't like this structure, you can modify the Makefile.
* `make flash filename=xxx.hex`: It'll first search the `xxx.hex` file and then use `avrdude` to flash the device. The avrdude argument can be modified in the Makefile by changing `PROGRAMMER_TYPE` and `PROGRAMMER_ARGS`. **NOTICE: you might want to change the tty to the correct port!**
* `make size filename=xxx.hex`: It'll search the `xxx.hex` file and then use `avr-size` to get the size of the hex file.
* `make clean`: It'll clean the `.o` files and the `.hex` file for all folder.

