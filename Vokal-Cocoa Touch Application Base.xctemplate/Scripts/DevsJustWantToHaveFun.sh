#!/bin/bash

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

#If $PROJECT_DIR isn't set, then assume that $PROJECT_DIR is two levels up from the
# directory containing this script (and set $PROJECT_DIR to that directory).
if [ -z "${PROJECT_DIR}" ]; then
    PROJECT_DIR=$(cd "$(dirname "$0")"; cd ..; cd ..; pwd)
fi

if [ -z "${PROJECT_NAME}" ]; then
    PROJECT_NAME="___PACKAGENAME___"
fi

# Path relative to this script where the TrueColors file you want to use to generate
# classes is located. Must include the .truecolors extension. 
TRUECOLORS_PATH="../Resources/___PACKAGENAME___.truecolors"

# Path relative to this script where files should be output.
OUTPUT_DIR="../Resources/TrueColors"

# Path relative to this script where fonts should be placed 
FONT_DIR="../Resources/Fonts"

# Prefix to use for extensions/categories, ex: VOK. 
PREFIX="FIXME"

# Change this to "swift" if you want your files to output in swift.
LANGUAGE="objc"

# Make sure everything is set up before trying to run
if [ "${PREFIX}" = "FIXME" ];  then
    echo "ERROR: You need to set up your category/extension prefix for Devs Just Want To Have Fun!"
    exit 1
fi

"${PROJECT_DIR}/Pods/DevsJustWantToHaveFun/Cocoapod/DevsJustWantToHaveFun" \
    --truecolors "${TRUECOLORS_PATH}" \
    --output-dir "${OUTPUT_DIR}" \
    --font-dir "${FONT_DIR}" \
    --prefix "${PREFIX}" \
    --"${LANGUAGE}"

