#!/bin/bash

# JSON file path to update
fileJson="platform.json"

# Update a JSON value 
updateJsonValue() {
    local -a replaceElement=("${@}")              # Capture all arguments as an array
    # Get the Infos from array-argument
    local fileJson="platform.work.json"           # Working file
    local toJsonPath=${replaceElement[0]}         # Path to elemen (e.g. .packages. or .repository.url)
    local recordPath=${replaceElement[1]}         # to Record-Name (e.g. tool-ninja) if empty, no record
    local inRecordPath=${replaceElement[2]}       # in Record Path (e.g. .version)
    local newValue=${replaceElement[3]}           # New Value to be updated
    # Check Record is included: 
    if [ -z "$recordPath" ] || [ -z "$inRecordPath" ];
    then
        # no RECORD
        local jqPath=$toJsonPath                  # Constructing the jqPath to value needs replacement
    else
        # with RECORD 
        local jqPath=$toJsonPath"."\"$recordPath\"$inRecordPath # Constructing the jqPath to value needs replacement
    fi
    # Get current value
    local currValue=$(jq -r $jqPath "$fileJson")      # Read current value
    if [ $currValue = $newValue ]; then # Check if the values is already up to date
        echo -e "... '$jqPath' > Already up to date" # Alreaedy up to date
    else # update it! 
        jq "$jqPath= \"$newValue\"" $fileJson > temp.json # # Set new value (replace), update the value
        # Write back and echo
        mv -f temp.json "$fileJson"
        echo -e "... '$jqPath' > Updated"
        echo -e "    from:  \"$currValue\""
        echo -e "    to  :  \"$newValue\""
    fi
}
# Remove a JSON element
removeJsonEleme() {
    local -a replaceElement=("${@}")              # Capture all arguments as an array
    # Get the Infos from array-argument
    local fileJson="platform.work.json"           # Working file
    local toJsonPath=${replaceElement[0]}         # Path to elemen (e.g. .packages. or .repository.url)
    local recordPath=${replaceElement[1]}         # to Record-Name (e.g. tool-ninja) if empty, no record
    local inRecordPath=${replaceElement[2]}       # in Record Path (e.g. .version)
    # Check Record is included: 
    if [ -z "$recordPath" ] || [ -z "$inRecordPath" ];
    then # no RECORD
        local jqPath=$toJsonPath                  # Constructing the jqPath what should be removed
    else # with RECORD
        local jqPath=$toJsonPath"."\"$recordPath\"$inRecordPath # Constructing the jqPath what should be removed
    fi
    # Get current value
    local currValue=$(jq -r $jqPath "$fileJson")  # Read current value
    if [ $currValue = 'null' ]; then              # Check if element exits in the json
        echo -e "... '$jqPath' > Not exists, nothing to remove!" # NOT EXISTING 
    else # EXISTING 
        currValue=$(echo "$currValue" | tr -d '\n' | tr -d ' ') # Remove line breaks and spaces
        # Remove the element
        jq "del($jqPath)" $fileJson > temp.json       # Remove the Path
        # Write back and echo
        mv -f temp.json "$fileJson"
        echo -e "... '$jqPath' Removed this Element had value \"$currValue\""
    fi
}
#-----------------------------------------------------------------------------------------------
# HOW to USE? 
#--------- NO Record ---------------------------------------------------------------------------
#                  $toJsonPath          ..no record!..         ..NO record!..      $newValue
# replaceElement=(".engines.platformio"       ""                     ""            ">=6.1.15  ) 
#--------- with RECORD nested  -----------------------------------------------------------------
#                  $toJsonPath          $recordName            $inRecordPath      $newValue
# replaceElement=(".packages"  "framework-arduinoespressif32"    ".owner"          "twischi"  ) 
#-----------------------------------------------------------------------------------------------

# create the working file temp.json 
cp -f $fileJson platform.work.json # use be updateJsonValue()

# You can find the IDF download-URLs @
# https://github.com/espressif/esp-idf/releases
# It should-tobe/neeed fits-to the version you useed for the lib-build  
urlfrwkIDF="https://github.com/espressif/esp-idf/releases/download/$rlIdfTag/esp-idf-$rlIdfTag.zip"
#urlfrwkIDF="https://github.com/espressif/esp-idf/releases/download/v5.1.4/esp-idf-v5.1.4.zip"


# Set minimum PIO version
#replaceElement=(".engines.platformio"  ""   ""   ">=6.1.15")                             && updateJsonValue "${replaceElement[@]}"

# Set to own repository
replaceElement=(".repository.url"      ""   ""   "$urlGIT")                              && updateJsonValue "${replaceElement[@]}"
# Version of platform-espressif32 = Date of build with lib-builder  
replaceElement=(".version"              ""   ""   "$rlVersionPkg")                       && updateJsonValue "${replaceElement[@]}"

# .packages Replacements with download URL
replaceElement=(".packages" "framework-arduinoespressif32" ".owner"   "$userGH")         && updateJsonValue "${replaceElement[@]}"
replaceElement=(".packages" "framework-arduinoespressif32" ".version" "$urlfrwkArEsp32") && updateJsonValue "${replaceElement[@]}"
replaceElement=(".packages" "framework-espidf"             ".owner"   "espressif")       && updateJsonValue "${replaceElement[@]}"
replaceElement=(".packages" "framework-espidf"             ".version" $urlfrwkIDF)       && updateJsonValue "${replaceElement[@]}"
#REMOVE_Element=(".packages" "framework-espidf"             ".optionalVersions")          && removeJsonEleme "${REMOVE_Element[@]}"

# .packages Normal Replacements 
#replaceElement=(".packages" "toolchain-xtensa-esp32"   ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-xtensa-esp32s2" ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-xtensa-esp32s3" ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-riscv32-esp"    ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#REMOVE_Element=(".packages" "toolchain-riscv32-esp"    ".optionalVersions")           && removeJsonEleme "${REMOVE_Element[@]}"
#replaceElement=(".packages" "tool-openocd-esp32"       ".version" "~2.1200.0")        && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "tool-ninja"               ".version" "^1.9.0")          && updateJsonValue "${replaceElement[@]}"

# Finalize
mv -f platform.work.json $fileJson # Overwrite with updated file
rm -f platform.work.json           # Remove working file