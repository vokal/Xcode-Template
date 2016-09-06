#!/bin/bash

#If $PROJECT_DIR isn't set, then assume that $PROJECT_DIR is two levels up from the
# directory containing this script (and set $PROJECT_DIR to that directory).
if [ -z "$PROJECT_DIR" ]; then
    PROJECT_DIR=$(cd "$(dirname "$0")"; cd ..; cd ..; pwd)
fi

# Adjust the path to the Cat2Cat executable as needed.
# Adjust the --base-path parameter as needed--the --asset-catalog and --output-dir parameters are relative to this parameter.

# --asset-catalog parameter to add each asset catalog (relative to the base path).
MAIN_ASSET_CATALOG="___PACKAGENAME___/Images.xcassets" #you can always add more, but start here.

# Use the --output-dir parameter to set the output directory for your category/extension file (relative to the base path).
OUTPUT_DIR="___PACKAGENAME___/Categories" # For Swift output, change Categories to Extensions.

# Use the --mac and/or --ios flags to generate NSImage and/or UIImage categories/extensions.
# Use the --objc and/or --swift flags to generate Objective-C categories and/or Swift class extensions.
LANGUAGE="objc" # For Swift output, change to "swift"

"${PROJECT_DIR}/Pods/Cat2Cat/CocoaPod/Cat2Cat" \
    --base-path="${PROJECT_DIR}" \
    --asset-catalog="${MAIN_ASSET_CATALOG}" \
    --output-dir="${OUTPUT_DIR}" \
    --ios \
    --"${LANGUAGE}"
