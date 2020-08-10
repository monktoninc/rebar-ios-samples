#!/bin/sh
set -e

HAS_ARGS=1
if [ $# -ne 4 ]; 
then
    HAS_ARGS=0
fi

bundle_identifier=''
prefix_identifier=''
url_identifier=''
url_scheme=''


if [ $HAS_ARGS = 1 ]; 
then
    bundle_identifier="$1"
else
    echo "Please enter bundle identifier: "
    read bundle_identifier
fi

if [ $HAS_ARGS = 1 ]; 
then
    prefix_identifier="$2"
else
    # Find the bundle prefix
    echo "Please enter team identifier: (From Developer Portal) "
    read prefix_identifier
fi

if [ $HAS_ARGS = 1 ]; 
then
    url_identifier="$3"
else
    # Add the API URL
    echo "Please enter api host: e.g. api.example.com "
    read url_identifier
fi

if [ $HAS_ARGS = 1 ]; 
then
    url_scheme="$4"
else
    # Add the API URL
    echo "Please enter URL scheme: "
    read url_scheme
fi




# Replace the bundle identifier
find . -name '*.pbxproj' -print0 | xargs -0 sed -i "" "s/io.monkton.rebarapp/$bundle_identifier/g"

# Replace the bundle identifier in entitlements
find . -name '*.entitlements' -print0 | xargs -0 sed -i "" "s/io.monkton.rebarapp/$bundle_identifier/g"

# Org Prefix
find . -name '*.json' -print0 | xargs -0 sed -i "" "s/your-app-identifier/$prefix_identifier/g"
find . -name '*.entitlements' -print0 | xargs -0 sed -i "" "s/your-app-identifier/$prefix_identifier/g"

# URL for Web Services
find . -name '*.json' -print0 | xargs -0 sed -i "" "s#api.example.com#$url_identifier#g"

# URL Scheme for opening apps
find . -name '*.json' -print0 | xargs -0 sed -i "" "s#rebarapp-scheme#$url_scheme#g"
find . -name 'Info.plist' -print0 | xargs -0 sed -i "" "s#rebarapp-scheme#$url_scheme#g"

printf '\e[32mFinished setting up %s\e[0m\n' "Sample App"
