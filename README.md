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
