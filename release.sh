#!/bin/bash
# ----------------------------------------------------------------
# PIO Platform JSON Update Script 
# ----------------------------------------------------------------
# This script updates the platform.json file with the new values
# and than creates a new release.
# 
# --- Introduce 'dryrun'-option (2024-11-14)
#     Call this script with 'dryrun' as argument for TESTING  
# ----------------------------------------------------------------
clear
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# ---------------------------------------------------------
# Check if the script is called with 'dryrun' as argument
# -> Set and export flag 'dryrun'
# ---------------------------------------------------------
[ "$1" == "dryrun" ] && echo -e "--- DRY-RUN MODE ---\n"  || NdR=1 && export NdR # Set flag for dry-run
# //  $NdR Set = Dry-run  // Unset = Real run >> [ $NdR ] && COMMAND

# *********************************************
# Several common Funtions partly OS dependent
# *********************************************
function get_os(){
    OSBITS=`uname -m`
    if [[ "$OSTYPE" == "darwin"* ]]; then 
        echo "macos"
    else 
        echo "$OSTYPE"
    fi 
    return 0
}
runningOS=`get_os`
#---------------------------------------
# Define the colors for the echo output
#---------------------------------------
export eBL="\x1B[34m"   # echo Color (blue) for Files that are executed or used
export eRD="\x1B[31m"   # echo Color (Red) for Targets
export eNO="\x1B[0m"    # Back to    (Black)
# ----------------------------------------------------------------------------------
# Read (YOUR) configuration: Gets userGH & tokenGH, needed for GitHub authentication
# ----------------------------------------------------------------------------------
source config/config.sh # Used for API calls
echo "...................................................................................."

#.................................................................
# Derive Repository - Infos/URLs from the configuration
#.................................................................
echo "-- 1) Get Infos from this <platform-espressif32>-Repository"
urlREPO="https://github.com/$userGH/platform-espressif32"
urlGIT=$urlREPO.git 
currBranch=$(git rev-parse --abbrev-ref HEAD)
urlApi4Release="https://api.github.com/repos/$userGH/platform-espressif32/releases"
urlUpload4Release="https://uploads.github.com/repos/$userGH/platform-espressif32/releases"
echo -e "Repository:     $eBL$urlGIT$eNO"
echo -e "Current Branch: $eRD$currBranch$eNO"
echo "...................................................................................."

#.................................................................
# Read infos from build
#.................................................................
echo "-- 2) Read variables from 'forRelease/pio-release-info.sh'"
# Check if needed file 'forRelease/pio-release-info.sh' is there
if [ ! -f "forRelease/pio-release-info.sh" ]; then
    # FILE NOT FOUND found, try to locate it 
    # Search for 'forRelease' Folder that contains 'pio-release-info.sh'
    forReleasePath=$(find ./../PIO-Out/ -type d -name 'forRelease' -exec test -e '{}/pio-release-info.sh' \; -print 2>/dev/null)
    # If not found, try one more level up
    if [ -z "$forReleasePath" ]; then
        forReleasePath=$(find ./../../ -type d -name 'forRelease' -exec test -e '{}/pio-release-info.sh' \; -print 2>/dev/null)
    fi
    # Check if the variable is empty (i.e., the folder or the file wasn't found)
    if [ -z "$forReleasePath" ]; then
        echo -e "$eRD ERROR: File 'forRelease/pio-release-info.sh' not found!\n$eNO Read '/forRelease/README.md for more information."
        exit 1
    else
        forReleasePath=$(realpath $forReleasePath)
        echo -e "$eBL\n--- 0) Release-Files was not found in forRelease-Folder$eNO"
        echo -e       "      Searched & FOUND in Folder ABOVE:\n         $forReleasePath"
        echo -e       "    > This Release-Files will be copied now!\n"
        cp -r $forReleasePath/* forRelease/
    fi
fi
# Read variables from the file
source forRelease/pio-release-info.sh
echo -e "Build-Date:     $eRD$rlVersionPkg$eNO"
echo -e "for Targets:    $eRD$rlTagets$eNO"
echo -e "IDF-Version:    $eRD$rlIdfTag$eNO"
echo -e "AR-Version:     $eRD$rlAR$eNO"
echo -e "PIO-FrmwkFile:  $eBL$rlFrmwFN$eNO"
echo -e "EspArLibsFile:  $eBL$rlArLibsFN$eNO"
echo -e "IDF-DL-Url:     $eBL$rlIDF_DL_URL$eNO"
echo "...................................................................................."

#.................................................................
# Udate platform.json for the new release
#.................................................................
# Downlod-URL to the new release -- used in-> platfrom.json 
urlfrwkArEsp32="$urlREPO/releases/download/$rlVersionBuild/$rlFrmwFN"    # URL to the new framework file
urlArLibsEsp32="$urlREPO/releases/download/$rlVersionBuild/$rlArLibsFN"  # URL to the new Arduino libs file
echo -e "-- 3) Update platform.json for the new release"
source config/updatePlatformJson.sh
echo "...................................................................................."

#.................................................................
# Commit and push the changes platform.json
#.................................................................
echo -e "-- 4) Push updated platform.json to the repository"
git add platform.json
git commit -m "updated to new release $rlVersionBuild" >/dev/null
git push origin $currBranch >/dev/null
if [ $? -ne 0 ]; then
    echo -e $eRD"Git push failed for branch $eBL$currBranche$NO"
    echo -e     "Are you logged in to GitHub at your machine running this?"
    exit 1
fi
echo "...................................................................................."
#.................................................................
# Create a tag for this release
#.................................................................
echo -e "-- 5) Create new tag for the release"
git fetch --prune origin "+refs/tags/*:refs/tags/*" --quiet # Make sure to have the latest tags locally
tagExists=$(git tag -l "$rlVersionBuild") # Check it the tag exists
if [ -n "$tagExists" ]; then
    echo -e "   $eRD!!! Tag= '$rlVersionBuild' already exists!$eNO"
    if [[ -n "$_Dbg_file" ]]; then # Is running in bash debug mode?
        response="y"
    else
        echo -e "$eRD Do you want to REPLACE the existing release? (y/n)$eNO"
        read -r response
    fi
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        # Commands to delete the release
        echo "   Deleting the release..."
        # Find the release ID by the tag name
        tempReleaseID=$(curl -su $userGH:$tokenGH $urlApi4Release/tags/$rlVersionBuild | jq '.id')
        # Delete the release
        response=$(curl -su $userGH:$tokenGH -X DELETE $urlApi4Release/$tempReleaseID)
        echo -n "   "
        git tag -d $rlVersionBuild # Delete the tag locally
        git push --delete origin $rlVersionBuild --quiet # Delete the tag remotely
    else
        echo -e "!!! SCRIPT STOPPED\n!!! YOU MAY DELETE THE TAG at GitHub FIRST!\n\n$urlREPO/releases\n" && exit 1
    fi
else
    echo -e "  Tag= $eBL'$rlVersionBuild'$eNO does not exist, creating it...\n"
fi
git tag -a $rlVersionBuild -m "Release version $rlVersionBuild"
git push origin $rlVersionBuild --quiet
git fetch --tags --quiet # Make sure to have the new tag locally too
echo "...................................................................................."

#.................................................................
# Write the release info
#.................................................................
echo -e "-- 6) Create the new release"
# Build the body of the release
textIDF="esp-idf"
textAR="arduino-esp32"
 bodyMd="#### Version in PIO package.json: &nbsp; &nbsp; \`$rlVersionPkg\`\n"
bodyMd+="##### Used for the build:\n"
bodyMd+="&nbsp; &nbsp; &nbsp;${textIDF} : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; \`$rlIDF\`\n"
bodyMd+="&nbsp; &nbsp; &nbsp;${textAR} : &nbsp; &nbsp; \`$rlAR\`\n"
bodyMd+="##### Build for this targets:\n"
bodyMd+="&nbsp; &nbsp; &nbsp;$rlTagets\n"
#echo -e "VALID body:\n$bodyMd"

# Create the release at GitHub
response=$(curl -su $userGH:$tokenGH -X POST -H "Accept: application/vnd.github.v3+json" \
$urlApi4Release \
-d "{
  \"tag_name\": \"${rlVersionBuild}\",
  \"target_commitish\":  \"${currBranch}\",
  \"name\": \"${rlVersionBuild}\",
  \"body\": \"${bodyMd}\",
  \"draft\": false,
  \"prerelease\": false
}")
# Extract important Info from the response for file upload
ReleaseID=$(echo "$response" | jq -r '.id')
if [ "$ReleaseID" == 'null' ]; then
  echo -e "ERROR: NO ReleaseID found! \n   -- This is the response of the api-call:"
  echo $response | jq
  exit 1
else
  echo -e "    Got this ReleaseID for file-upload: $eRD$ReleaseID$eNO"
fi
urlUpload4Release="https://uploads.github.com/repos/$userGH/platform-espressif32/releases/$ReleaseID/assets"
echo "...................................................................................."

#.................................................................
# Load Files to Relase: 'Packed release file: for 'FRAMEWORK'   
#.................................................................
echo -e "-- 7a) Upload the release file (FRAMEWORK)" 
loadFileApiUrl="$urlUpload4Release?name=$rlFrmwFN"
#echo $loadFileApiUrl
rlFN_PATH="forRelease/$rlFrmwFN"
echo -e "    Upload tar.gz will take a while ...$eBL" && echo -n "    "
response=$(curl -u $userGH:$tokenGH -X POST \
-H "Content-Type: $(file -b --mime-type $rlFN_PATH)" --data-binary @$rlFN_PATH \
$loadFileApiUrl)
#.................................................................
# Load Files to Relase: 'Packed release file: for 'ESP32-AR-LIBS'   
#.................................................................
echo -e "-- 7b) Upload the release file (ESP32-AR-LIBS)" 
loadFileApiUrl="$urlUpload4Release?name=$rlArLibsFN"
#echo $loadFileApiUrl
rlFN_PATH="forRelease/$rlArLibsFN"
echo -e "    Upload tar.gz will take a while ...$eBL" && echo -n "    "
response=$(curl -u $userGH:$tokenGH -X POST \
-H "Content-Type: $(file -b --mime-type $rlFN_PATH)" --data-binary @$rlFN_PATH \
$loadFileApiUrl)
echo "...................................................................................."

#.................................................................
# Load File to Relase: pio-release-info.txt
#.................................................................
echo -e "$eNO-- 8) Upload pio-release-info.txt file"
loadFileApiUrl="$urlUpload4Release?name=pio-release-info.txt"
echo "   Upload pio-release-info.sh ..."
response=$(curl -su $userGH:$tokenGH -X POST \
-H "Content-Type: $(file -b --mime-type forRelease/pio-release-info.txt)" \
--data-binary @forRelease/pio-release-info.txt \
$loadFileApiUrl)
echo "   $urlREPO/releases"
echo "...................................................................................."

#.................................................................
# DONE, FINSHED
#.................................................................
echo -e "                             Release DONE!"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
[[ "$runningOS" == "macos" ]] && osascript -e 'beep 10' || echo -e "\a\a\a"