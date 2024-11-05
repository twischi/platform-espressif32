# Platform.json for [PlatformIO](https://platformio.org)

To install the PIO-platform `espressif32` the file **`platform.json`** steers the installation process.  

## Toolchain

```json
"type": "toolchain"
```

* **gdb**: The **GNU Debugger**, a powerful debugging tool that lets you inspect what happens inside a program as it executes.
* **elf**: Refers to the **Executable and Linkable Format**, the standard file format for executable binaries on many platforms, including embedded systems.<br><br>

* **Xtensa**: Is a proprietary, customizable RISC (Reduced Instruction Set Computer) architecture developed by Tensilica. Espressif customized the Xtensa core for its ESP8266 and early ESP32 series like ESP32-S3.
* **RISC-V**: Is an **open-source** and open-standard RISC architecture developed by the RISC-V Foundation. It comes without licensing costs and is used in latest EPS32 series like ESP32-H2 .

### toolchain-xtensa-esp-elf

> *`toolchain-xtensa-esp-elf`* is a generic Xtensa toolchain provided to support Espressif’s older ESP8266 microcontrollers. It includes tools like the compiler (xtensa-lx106-elf-gcc), assembler, and linker, all configured to produce machine code for the Xtensa LX106 core used in the ESP8266.

* ### Sources

  * [Registry PIO "toolchain-xtensa-esp-elf"](https://registry.platformio.org/search?q=toolchain-xtensa-esp-elf)

### toolchain-xtensa-esp32

> *`toolchain-xtensa-esp32`* provided the customized Xtensa toolchain needed to build and compile code for Espressif's ESP32 microcontrollers with the Xtensa architecture. This toolchain includes essential components such as the compiler (xtensa-esp32-elf-gcc), assembler, and linker, optimized for the Xtensa architecture used in these ESP32 chips.

* ### Sources

  * [Registry PIO "toolchain-xtensa-esp32"](https://registry.platformio.org/search?q=toolchain-xtensa-esp32)

### toolchain-xtensa-esp32s2

> *`toolchain-xtensa-esp32s2`* provided the Xtensa toolchain designed specifically for the ESP32-S2 microcontrollers. Although both ESP32 and ESP32-S2 use Xtensa cores, the ESP32-S2 has different hardware features, such as fewer cores, lower power consumption, and added native USB support, which require specific optimizations in the toolchain. It is  tailored to handle these unique attributes and capabilites of the ESP32-S2.

* ### Sources

  * [Registry PIO "toolchain-xtensa-esp32s2"](https://registry.platformio.org/search?q=toolchain-xtensa-esp32s2)

### toolchain-xtensa-esp32s3

> *`toolchain-xtensa-esp32s3`* provided the Xtensa toolchain designed specifically for the ESP32-S3 microcontrollers. Although both ESP32 and ESP32-S3 use Xtensa cores, the ESP32-S3 has different hardware features and is optimized for the ESP32-S3’s Xtensa LX7 core, which supports new instructions and enhanced AI acceleration features.

* ### Sources

  * [Registry PIO "toolchain-xtensa-esp32s3"](https://registry.platformio.org/search?q=toolchain-xtensa-esp32s3)

### toolchain-riscv32-esp

* ### Sources

  * [Registry PIO "toolchain-riscv32-esp"](https://registry.platformio.org/search?q=toolchain-riscv32-esp)

### toolchain-esp32ulp

> support for the Espressif ESP32 Ultra-Low-Power(ULP) Co-processor

* ### Sources

  * [Registry PIO "toolchain-esp32ulp"](https://registry.platformio.org/search?q=toolchain-esp32ulp)

## Debugger

```json
"type": "debugger"
```

**GNU Debugger (gdb)**  
is a open-source debugging tool used to analyze and control the execution of programs. It allows developers to set breakpoints, step through code, inspect variables, and manage memory, aiding in troubleshooting and optimizing software. GDB supports multiple programming languages (like C, C++, and Fortran). When used with embedded systems, GDB often connects through tools like OpenOCD to interface with hardware directly-

**OpenOCD** (Open On-Chip Debugger)  
is an open-source tool used to interface with embedded systems for on-chip debugging through **JTAG** or SWD (Serial Wire Debug) interfaces. In combination with the GNU Debugger (gdb), OpenOCD acts as a bridge between GDB and the microcontroller hardware.  
<br>

### tool-xtensa-esp-elf-gdb

> The *`xtensa-esp-elf-gdb`* is a version of the **GNU Debugger (gdb)** specifically built for **Xtensa**- processors, which are used in **ESP32** (& ESP8266) microcontrollers by Espressif. It allows ESP32-Chips based on the Xtensa-architecture, to do debugging direclty on ESP processors.

* ### Sources

  * [Registry PIO "xtensa-esp-elf-gdb"](https://registry.platformio.org/search?q=xtensa-esp-elf-gdb)
  * [List of ESP-IDF-Tools > xtensa-esp-elf-gdb](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-tools.html?#xtensa-esp-elf-gdb)

### xtool-riscv32-esp-elf-gdb

> Some of the latest ESP32-Chips - like ESP32H2 - based on **RISC-V**-Archriteture. *`xtool-riscv32-esp-elf-gdb`* is used to debugging direclty on this EPS processors.

* ### Sources

  * [Registry PIO "xtool-riscv32-esp-elf-gdb"](https://registry.platformio.org/search?q=tool-riscv32-esp-elf-gdb)
  * [List of ESP-IDF-Tools > riscv32-esp-elf-gdb](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-tools.html#riscv32-esp-elf-gdb)

### tool-openocd-esp32

> *`"tool-openocd-esp32`* is to a customized version of OpenOCD (Open On-Chip Debugger) specifically adapted for Espressif’s ESP32 family of microcontrollers.

* ### Sources

  * [Registry PIO "tool-openocd-esp32"](https://registry.platformio.org/search?q=tool-openocd-esp32)
  * [List of ESP-IDF-Tools > openocd-esp32](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-tools.html?#openocd-esp32)

# Uploader

```json
"type": "uploader"
```

### tool-esptoolpy

### tool-dfuutil-arduino

> `tool-dfuutil-arduino` is used for flashing firmware onto devices uses the <br> ***DFU*** (Device Firmware Upgrade) mode.

### Sources

* [Registry PIO "tool-dfuutil-arduino"](https://registry.platformio.org/search?q=tool-dfuutil-arduino)
* [PIO - Packages > tool-dfuutil-arduino](https://docs.platformio.org/en/latest/platforms/espressif32.html#packages)

### tool-mkspiffs

### Sources

* [Registry PIO "tool-mkspiffs"](https://registry.platformio.org/search?q=tool-mkspiffs)
* [PIO - Packages > tool-mkspiffs](https://docs.platformio.org/en/latest/platforms/espressif32.html#packages)


### tool-mklittlefs
> `tool-mklittlefs` is used to create a <br> ***Little File System*** during build or upload. LittleFS is resilient and optimized for flash memory, which makes it particularly useful in embedded applications that require stable storage.

### Sources

* [Registry PIO "tool-mklittlefs"](https://registry.platformio.org/search?q=tool-mklittlefs)
* [Espressif - Other Storages - LittleFS](https://docs.espressif.com/projects/esp-faq/en/latest/software-framework/storage/other-storages.html)
* [Espressif - Details - LittleFS](https://components.espressif.com/components/joltwallet/littlefs)

### tool-mkfatfs

> `tool-mkfatfs` is used to create a **FAT-File-System-Image** during build or upload.

***FAT (File Allocation Table)*** file system is needed, often for managing files on **SD cards** or other external storage connected to the microcontroller.

### Sources

* [Registry PIO](https://registry.platformio.org/search?q=tool-mkfatfs)
* [Espressif - FAT FS](https://docs.espressif.com/projects/esp-faq/en/latest/software-framework/storage/fatfs.html)

# No Type specified

```json
"type": "***NONE**"
```

### tool-idf

### tool-cmake

`tool-cmake` is used to **cross**-compiling and linking source files..

**CMake** is a widely used open-source, cross-platform tool designed to manage the build process in a compiler-independent manner.

### Sources

* [Registry PIO "tool-cmake"](https://registry.platformio.org/search?q=tool-cmake)
* [PIO - Packages > tool-cmake](https://docs.platformio.org/en/latest/platforms/espressif32.html#packages)
* [Espressif - API Guides - CMake](https://docs.espressif.com/projects/esp-idf/en/release-v3.3/api-guides/build-system-cmake.html)

### tool-ninja

`tool-ninja` is used ....

### Sources

* [Registry PIO](https://registry.platformio.org/search?q=tool-ninja)

### tool-xtensa-esp-elf-gdb

```json 
    "tool-xtensa-esp-elf-gdb": {
        "type": "debugger",
        "optional": true,
        "owner": "espressif",
        "version": "~12.1.0"}
```




