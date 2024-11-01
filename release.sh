#!/bin/bash
# ----------------------------------------------------------------
# PIO Platform JSON Update Script 
# ----------------------------------------------------------------
# This script updates the platform.json file with the new values
# and than creates a new release.
# ----------------------------------------------------------------

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
#.................................................................
# Read (YOUR) configuration
#.................................................................
source config/config.sh
#.................................................................
# Derive Repository - Infos/URLs from the configuration
#.................................................................
urlREPO="https://github.com/$userGH/platform-espressif32"
urlGIT=$urlREPO.git 
currBranch=$(git rev-parse --abbrev-ref HEAD)
urlApi4Release="https://api.github.com/repos/$userGH/platform-espressif32/releases"
urlUpload4Release="https://uploads.github.com/repos/$userGH/platform-espressif32/releases"
#.................................................................
# Read infos from build
#.................................................................
# Check if needed file 'forRelease/pio-release-info.sh' is there
if [ ! -f "forRelease/pio-release-info.sh" ]; then
    # Needes file not found, try to locate it 
    # Search for 'forRelease' Folder that contains 'pio-release-info.sh'
    forReleasePath=$(find ./../ -type d -name 'forRelease' -exec test -e '{}/pio-release-info.sh' \; -print 2>/dev/null)
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
echo "Read variables from 'forRelease/pio-release-info.sh'"
source forRelease/pio-release-info.sh
echo 
#.................................................................
# Udate platform.json for the new release
#.................................................................
# Downlod-URL to the new release -- used in-> platfrom.json 
urlfrwkArEsp32="$urlREPO/releases/download/$rlVersionBuild/$rlFN"
echo -e "\n--- 1) Update platform.json for the new release\n"
source config/updatePlatformJson.sh
echo 
#.................................................................
# Commit and push the changes platform.json
#.................................................................
echo -e "\n--- 2) Push updated platform.json to the repository\n"
git add platform.json
git commit -m "updated to new release $rlVersionBuild" >/dev/null
git push origin $currBranch
#.................................................................
# Create a tag for this release
#.................................................................
echo -e "\n--- 3) Create new tag for the release\n"
git fetch --prune origin "+refs/tags/*:refs/tags/*" --quiet # Make sure to have the latest tags locally
tagExists=$(git tag -l "$rlVersionBuild") # Check it the tag exists
if [ -n "$tagExists" ]; then
    echo -e "$eRD!!! Tag= '$rlVersionBuild' already exists!\n$eNO"
    if [[ -n "$_Dbg_file" ]]; then # Is running in bash debug mode?
        response="y"
    else
        echo -e "$eRD Do you want to REPLACE the existing release? (y/n)$eNO"
        read -r response
    fi
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        # Commands to delete the release
        echo "    Deleting the release..."
        # Find the release ID by the tag name
        tempReleaseID=$(curl -su $userGH:$tokenGH $urlApi4Release/tags/$rlVersionBuild | jq '.id')
        # Delete the release
        response=$(curl -su $userGH:$tokenGH -X DELETE $urlApi4Release/$tempReleaseID)
        git tag -d $rlVersionBuild # Delete the tag locally
        git push --delete origin $rlVersionBuild --quiet # Delete the tag remotely
    else
        echo -e "!!! SCRIPT STOPPED\n!!! YOU MAY DELETE THE TAG at GitHub FIRST!\n\n$urlREPO/releases\n" && exit 1
    fi
fi
git tag -a $rlVersionBuild -m "Release version $rlVersionBuild"
git push origin $rlVersionBuild --quiet
git fetch --tags --quiet # Make sure to have the new tag locally too
#.................................................................
# Write the release info
#.................................................................
echo -e "\n--- 4) Create the new release\n"
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
#.................................................................
# Load File to Relase: 'Packed release file'  
#.................................................................
echo -e "\n--- 5) Upload the release file\n"
loadFileApiUrl="$urlUpload4Release?name=$rlFN"
#echo $loadFileApiUrl
rlFN_PATH="forRelease/$rlFN"
echo -e "    Upload tar.gz will take a while ...\n$eBL"
response=$(curl -u $userGH:$tokenGH -X POST \
-H "Content-Type: $(file -b --mime-type $rlFN_PATH)" --data-binary @$rlFN_PATH \
$loadFileApiUrl)
#.................................................................
# Load File to Relase: pio-release-info.txt
#.................................................................
echo -e "$eNO\n--- 6) Upload pio-release-info.txt file\n"
loadFileApiUrl="$urlUpload4Release?name=pio-release-info.txt"
echo "Upload pio-release-info.sh ..."
response=$(curl -su $userGH:$tokenGH -X POST \
-H "Content-Type: $(file -b --mime-type forRelease/pio-release-info.txt)" \
--data-binary @forRelease/pio-release-info.txt \
$loadFileApiUrl)
#.................................................................
# DONE, FINSHED
#.................................................................
echo -e "\nRelease done!\n"
[[ "$runningOS" == "macos" ]] && osascript -e 'beep 10' || echo -e "\a\a\a"