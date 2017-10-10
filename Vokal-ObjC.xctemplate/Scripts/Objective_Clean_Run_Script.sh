#!/bin/bash

if [[ "${CI}" == 'true' && "${TRAVIS}" == 'true' ]]; then
    echo "Objective-Clean will not be executed on Travis"
    exit 0
fi

if [[ -z "${SKIP_OBJCLEAN}" || "${SKIP_OBJCLEAN}" != 1 ]]; then
    if [[ -d "${LOCAL_APPS_DIR}/Objective-Clean.app" ]]; then
        "${LOCAL_APPS_DIR}"/Objective-Clean.app/Contents/Resources/ObjClean.app/Contents/MacOS/ObjClean \
        "${SRCROOT}"?!!___PACKAGENAME___/Scripts,!!___PACKAGENAME___/Resources/TrueColors,!!___PACKAGENAME___/Categories/UIImage+AssetCatalog,!!fastlane
    else
        echo "error: You have to install and set up Objective-Clean to use its features!"
        exit 1
    fi
fi
