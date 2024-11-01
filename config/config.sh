#!/bin/bash
# ----------------------------------------------------------------
# config.sh of PIO Platform JSON Update Script 
# ----------------------------------------------------------------
# This script HOLDS YOUR OWN configuration
# ----------------------------------------------------------------
#.................................................................
# YOUR GitHub user name, 
#      where your fork of the platform-espressif32 exits
#.................................................................
userGH="twischi"
#.................................................................
# YOUR PIRIVATE GitHub token, 
#      needed to upload the RELEASE assets
#      KEEP PRIVATE! >> It is covered by .gitignore
#.................................................................
if [ -f "config/.gitHubToken" ]; then
    tokenGH=$(<config/.gitHubToken) # Read token from file
else
    echo -e "\nERROR: File 'config/.gitHubToken' DOES NOT exist!"
    echo -e   "       Please create the file 'config/.gitHubToken' with your GitHub token."
    echo -e   "       The token is needed to upload the RELEASE assets.\n"
    exit 1
fi