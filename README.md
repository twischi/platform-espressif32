# Espressif 32: development platform for [PlatformIO](https://platformio.org)

This is a [fork of](https://github.com/platformio/platform-espressif32) to use a newer version of **Espressif's IoT Development Framework 5.1x** [(IDF)](https://idf.espressif.com) with **Adruiono-Framework 3.x** in PlatformIO.
Only the newer IDF Versions supports newer ESP32 chips [see source](https://github.com/espressif/esp-idf).

**This Repsitory fills the current gap**, until there is an offical Version.
<br>
<br>

The new IDF-Versions are not supported yet (state 2024/06), as it waits for the official Relaease for Arduiono Release.

**But** you need the newer IDF, when  want to work with the newer ESP32-Chips, see following list.


| Chip vs IDF  |&nbsp;&nbsp; v4.4, PIO ![alt text][official]&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; v5.1 ![alt text][This]&nbsp;|   v5.3 ![alt text][future] |
|:------------ | :-------------------------:| :-----------------------: | :--------------------: |
| ESP32        | ![alt text][supported] | ![alt text][suppo2]  |                     |
| ESP32-S2     | ![alt text][supported] | ![alt text][suppo2]  |                     |
| ESP32-C3     | ![alt text][supported] | ![alt text][suppo2]  |                     |
| ESP32-S3     | ![alt text][supported] | ![alt text][suppo2]  |                     |
| ESP32-C2     | ![alt text][missing]   | ![alt text][suppo2]  |                     |
| ESP32-C6     | ![alt text][missing]   | ![alt text][suppo2]  |                     |
| ESP32-H2     | ![alt text][missing]   | ![alt text][suppo2]  |                     |
| ESP32-P4     | ![alt text][missing]   | ![alt text][missing] | ![alt text][future] |
| ESP32-C5     | ![alt text][missing]   | ![alt text][missing] | ![alt text][future] |

[This]: https://img.shields.io/badge/-THIS-brightgreen "This"
[official]: https://img.shields.io/badge/-official-grey "official"
[supported]: https://img.shields.io/badge/-supported-green "supported"
[suppo2]: https://img.shields.io/badge/-supported-brightgreen "supported"
[future]: https://img.shields.io/badge/-future-lightblue "future"
[missing]: https://img.shields.io/badge/-missing-red "missing"

----

## Usage

1. [Install PlatformIO](https://platformio.org)
2. Create PlatformIO project and configure a platform option in [platformio.ini](https://docs.platformio.org/page/projectconf.html) file

### To use this version, add this line

#### Add to `platform.ini` file

```ini
[env]
platform = https://github.com/twischi/platform-espressif32.git
board = ...
...
```

Help for the `platform`-option see: [documentation](https://docs.platformio.org/en/latest/projectconf/sections/env/options/platform/platform.html#projectconf-env-platform)

```json
"tool-xtensa-esp-elf-gdb": {
    "type": "debugger",
    "optional": true,
    "owner": "espressif",
    "version": "~12.1.0"
}
```
The `xtensa-esp-elf-gdb` is a version of the **GNU Debugger (GDB)** specifically built for **Xtensa** processors, which are commonly used in **ESP32** (& ESP8266) microcontrollers by Espressif. The name breaks down as follows:

- **gdb**: The **GNU Debugger**, a powerful debugging tool that lets you inspect what happens inside a program as it executes.

- **elf**: Refers to the **Executable and Linkable Format**, the standard file format for executable binaries on many platforms, including embedded systems.

- **xtensa**: Refers to the Xtensa processor architecture, a highly customizable microcontroller core architecture developed by Tensilica, which is used in Espressif’s ESP32 chips.


##### What It Does

`xtensa-esp-elf-gdb` enables you to:

- **Set breakpoints** in your code to pause execution at certain points.
- **Inspect registers** and memory to understand the state of the system.
- **Step through code** line by line, which helps with pinpointing issues in code execution.
- **Examine variables and expressions** to track values during runtime.
- **Debug remotely** on the ESP chip by connecting over a serial or JTAG connection, useful for hardware debugging.

#### Why It’s Necessary for ESP32

Some ESP32-chips are based on the Xtensa architecture, so the standard `gdb` debugger for common architectures wouldn’t work with them. Espressif’s toolchain includes the `xtensa-esp-elf-gdb` specifically to debug programs on ESP processors. This tool integrates well with popular IDEs (like **VS Code with PlatformIO**) and allows embedded developers to debug ESP-based projects directly on the hardware.

#### Sources
xtensa-esp-elf-gdb

- [List of ESP-IDF-Tools](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-tools.html?highlight=xtensa%20esp%20elf%20gdb#list-of-esp-idf-tools)

- [Registry PIO](https://registry.platformio.org/search?q=xtensa-esp-elf-gdb)

> - [platform/... Versions](https://registry.platformio.org/tools/platformio/tool-xtensa-esp-elf-gdb/versions)

> - [espressif/... Versions](https://registry.platformio.org/tools/espressif/tool-xtensa-esp-elf-gdb/versions)


## Work in progress

```json
 "packages": {
    "framework-arduinoespressif32": {
      "type": "framework",
      "optional": true,
      "owner": "twischi",
      "version": "https://github.com/twischi/platform-espressif32/releases/download/IDF_tag_v5.1.4-AR_tag_3.0.1/framework-arduinoespressif32-IDF_tag_v5.1.4-AR_tag_3.0.1.tar.gz"
    },
    "framework-espidf": {
      "type": "framework",
      "optional": true,
      "owner": "espressif",
      "version": "https://github.com/espressif/esp-idf/releases/download/v5.1.4/esp-idf-v5.1.4.zip"
    },
    "toolchain-xtensa-esp32": {
      "type": "toolchain",
      "optional": true,
      "owner": "espressif",
      "version": "12.2.0+20230208"
    },
    "toolchain-xtensa-esp32s2": {
      "type": "toolchain",
      "optional": true,
      "owner": "espressif",
      "version": "12.2.0+20230208"
    },
    "toolchain-xtensa-esp32s3": {
      "type": "toolchain",
      "optional": true,
      "owner": "espressif",
      "version": "12.2.0+20230208"
    },
    "toolchain-riscv32-esp": {
      "type": "toolchain",
      "optional": true,
      "owner": "espressif",
      "version": "12.2.0+20230208"
    },
    "toolchain-esp32ulp": {
      "type": "toolchain",
      "optional": true,
      "owner": "platformio",
      "version": "~1.23500.0"
    },
    "tool-xtensa-esp-elf-gdb": {
      "type": "debugger",
      "optional": true,
      "owner": "espressif",
      "version": "~12.1.0"
    },
    "tool-riscv32-esp-elf-gdb": {
      "type": "debugger",
      "optional": true,
      "owner": "espressif",
      "version": "~12.1.0"


```
Normal 