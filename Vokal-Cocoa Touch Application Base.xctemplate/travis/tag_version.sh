#!/bin/bash

rootPath="${TRAVIS_BUILD_DIR}/fastlane/Build"
buildOutput="${rootPath}/${APPNAME}.ipa"
unpackedPath="${rootPath}/Unpacked"
plistLocation="${unpackedPath}/Payload/${APPNAME}.app/Info.plist"

#Unpack the ipa file to expose the Info.plist file.
unzip "${buildOutput}" "Payload/${APPNAME}.app/Info.plist" -d "${unpackedPath}" || exit 1

buildNumber=$(/usr/libexec/PlistBuddy \
    -c "Print :CFBundleVersion" \
    "${plistLocation}" \
    ) \
    || exit 1

versionNumber=$(/usr/libexec/PlistBuddy \
    -c "Print :CFBundleShortVersionString" \
    "${plistLocation}" \
    ) \
    || exit 1

echo "Build Number is ${buildNumber}"
echo "Version Number is ${versionNumber}"

newTag="builds/${versionNumber}/${buildNumber}"

echo "Creating tag ${newTag}"
git tag "${newTag}"

echo "Pushing tag to remote..."
git push origin "${newTag}"
