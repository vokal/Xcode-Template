#!/bin/bash

if [[ "${CI}" == 'true' && "${TRAVIS}" == 'true' ]]; then
    echo "xUnique will not be executed on Travis"
    exit 0
fi

# Get the path to the local copy of xUnique
XUNIQUE_PATH="${PODS_ROOT}/xUnique/xUnique.py"

# Run it against the main project
python "${XUNIQUE_PATH}" "${PROJECT_FILE_PATH}/project.pbxproj"

# Run it against CocoaPods
python "${XUNIQUE_PATH}" "${PODS_ROOT}/Pods.xcodeproj"
