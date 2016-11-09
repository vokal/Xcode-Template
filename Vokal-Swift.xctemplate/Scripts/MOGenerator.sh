#!/bin/bash

REQUIRED_MAJOR_VERSION=1
REQUIRED_MINOR_VERSION=31
# Determine the version of mogenerator that's installed. This script requires 
# 1.31 or higher, since it assumes the presence of the Swift 3 templates that 
# were added in that version.
# See https://github.com/rentzsch/mogenerator/releases/tag/1.31
MOGEN_VERSION=$(mogenerator --version | sed -nEe 's/.* ([[:digit:]]+(\.[[:digit:]]+)+).*/\1/p')
SPLIT_MOGEN_VERSION=(${MOGEN_VERSION//./ })
MAJOR_MOGEN_VERSION=${SPLIT_MOGEN_VERSION[0]}
MINOR_MOGEN_VERSION=${SPLIT_MOGEN_VERSION[1]}

# Bail if the version isn't high enough
if [[ (${MAJOR_MOGEN_VERSION} < ${REQUIRED_MAJOR_VERSION})
    || (${MAJOR_MOGEN_VERSION} == ${REQUIRED_MAJOR_VERSION}
        && ${MINOR_MOGEN_VERSION} < ${REQUIRED_MINOR_VERSION}) ]]; then
    echo "Upgrade mogenerator to version ${REQUIRED_MAJOR_VERSION}.${REQUIRED_MINOR_VERSION} or higher."
    exit 1
fi

echo "Generating MOs"
PATH="${PATH}:/usr/local/bin"
pwd
cd "${PROJECT_NAME}/CoreDataAndModels"

mogenerator \
    --model ___PACKAGENAMEASIDENTIFIER___.xcdatamodeld/ \
    --machine-dir private \
    --swift
