#!/bin/bash

# JSON file path to update
fileJson="platform.json"

# Update a JSON value 
updateJsonValue() {
    local -a replaceElement=("${@}")              # Capture all arguments as an array
    # Get the Infos from array-argument
    local fileJson="platform.work.json"           # Working file
    local toJsonPath=${replaceElement[0]}         # Path to element (e.g. .packages. or .repository.url)
    local recordPath=${replaceElement[1]}         # to Record-Name  (e.g. tool-ninja) if empty, no record
    local inRecordPath=${replaceElement[2]}       # in Record Path  (e.g. .version)
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
        # Use sed to update the value
        sed -i '' "s|\"$currValue\"|\"$newValue\"|g" "$fileJson"
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
cp -f $fileJson platform.work.json # This file(-copy) use is by function: updateJsonValue() to change values from current "platform.json"

# You can find the IDF download-URLs @ https://github.com/espressif/esp-idf/releases
# It should-tobe/neeed fits-to the version you useed for the lib-build
echo "rlIdfTag=" $rlIdfTag
echo "rIDF_DLurlAddPathElement=" $rIDF_DLurlAddPathElement
urlfrwkIDF="https://github.com/espressif/esp-idf/releases/download"$rIDF_DLurlAddPathElement".zip"
#https://github.com/espressif/esp-idf/releases/download/v5.3/esp-idf-v5.3.zip
https://github.com/espressif/esp-idf/releases/download/v5.3/esp-idf-v5.3.zip
https://github.com/espressif/esp-idf/releases/download/5.3/esp-idf-v5.3.zip


#urlfrwkIDF="https://github.com/espressif/esp-idf/releases/download/v5.1.4/esp-idf-v5.1.4.zip" # Example for a fixed version

# Set minimum PIO version
#replaceElement=(".engines.platformio"  ""   ""   ">=6.1.15")                             && updateJsonValue "${replaceElement[@]}"

# Set to own repository changes the GH-url & the version of the platform-espressif32 
replaceElement=(".repository.url"      ""   ""   "$urlGIT")                              && updateJsonValue "${replaceElement[@]}"
# Version of platform-espressif32 = Date of build with lib-builder  
replaceElement=(".version"              ""   ""   "$rlVersionPkg")                       && updateJsonValue "${replaceElement[@]}"

# Replacements for the .packged."framework-arduinoespressif32" to use a OWN build stored at GH
replaceElement=(".packages" "framework-arduinoespressif32" ".owner"   "$userGH")         && updateJsonValue "${replaceElement[@]}"
replaceElement=(".packages" "framework-arduinoespressif32" ".version" "$urlfrwkArEsp32") && updateJsonValue "${replaceElement[@]}"

# Replacements for the .packged."framework-espidf" to use a IDF-Framwork fitting to the OWN build (see above)
replaceElement=(".packages" "framework-espidf"             ".owner"   "espressif")       && updateJsonValue "${replaceElement[@]}"
replaceElement=(".packages" "framework-espidf"             ".version" $urlfrwkIDF)       && updateJsonValue "${replaceElement[@]}"
#REMOVE_Element=(".packages" "framework-espidf"             ".optionalVersions")          && removeJsonEleme "${REMOVE_Element[@]}"

# Replacements "NORMAL" .pagages within platform.json to diffrent verstion. Guess the need to be in line what is uses during build
#replaceElement=(".packages" "toolchain-xtensa-esp32"   ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-xtensa-esp32s2" ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-xtensa-esp32s3" ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "toolchain-riscv32-esp"    ".version" "12.2.0+20230208") && updateJsonValue "${replaceElement[@]}"
#REMOVE_Element=(".packages" "toolchain-riscv32-esp"    ".optionalVersions")           && removeJsonEleme "${REMOVE_Element[@]}"
#replaceElement=(".packages" "tool-openocd-esp32"       ".version" "~2.1200.0")        && updateJsonValue "${replaceElement[@]}"
#replaceElement=(".packages" "tool-ninja"               ".version" "^1.9.0")          && updateJsonValue "${replaceElement[@]}"

# Finalize
# check if dry-run is true
echo "dryrun: $dryrun"
if [ $dryrun = true ]; then
    # Dont overwrite the platform.json, just show the changes
    echo -e "\n$eBL DRY-RUN: $eNO platform.json HAS NOT be updated. Take a look at: 'platform.work.json'"


    # Compare the JSON files and show differences
    if ! diff <(jq -S . "platform.work.json") <(jq -S . "platform.json") > /dev/null; then
        echo "Differences detected between:"
        diff <(jq -S . "platform.work.json") <(jq -S . "platform.json")
    else
        echo "No differences found."
    fi
#    jq -r . platform.work.json
#    echo -e "\n$eBL Please check the changes above!$eNO"
    exit 0
else
    mv -f platform.work.json $fileJson # Overwrite with updated file
    rm -f platform.work.json           # Remove working file
fi