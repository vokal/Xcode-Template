#!/bin/bash

# Update the Info.plist build number with number of git commits
buildNumber=$(git rev-list HEAD --count) \
    || exit 1
echo "note: Updating build number to ${buildNumber}..."

# Update the Info.plist build number with number of git commits
/usr/libexec/PlistBuddy \
    -c "Set CFBundleVersion ${buildNumber}" \
    "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}" \
    || exit 1

# Update the build number in the dsym's info.plist if it exists
# (prevents potential version mismatches with the dsym)
if [[ -e "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist" ]]; then
    /usr/libexec/PlistBuddy \
        -c "Set CFBundleVersion ${buildNumber}" \
        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist" \
        || exit 1
fi

# Update the Settings.bundle
settingsBundlePlistPath="${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Settings.bundle/Root.plist"

if [[ -e "${settingsBundlePlistPath}" ]]; then
    bundleShortVersionString=$(/usr/libexec/PlistBuddy \
        -c "Print :CFBundleShortVersionString" \
        "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}" \
        ) \
        || exit 1
    newVersion="${bundleShortVersionString} (${buildNumber})"
    echo "note: Setting version number in settings bundle to ${newVersion}..."
    /usr/libexec/PlistBuddy \
        -c "Set PreferenceSpecifiers:1:DefaultValue ${newVersion}" \
        "${settingsBundlePlistPath}" \
        || exit 1
fi

echo "note: Done."
