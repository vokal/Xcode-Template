#!/bin/bash

if [[ "${HOCKEY_API_TOKEN}" == "FIXME" ]] \
    || [[ "${ITC_PASSWORD}" == "FIXME" ]]; then
    echo "HOCKEY_API_TOKEN and/or ITC_PASSWORD are still set to FIXME. Update or remove both of these variables."
    exit 1
fi

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "This is a pull request. No deployment will be done."
    exit 0
fi

# If there's a hockey API token, upload to hockey.
if [ -n "${HOCKEY_API_TOKEN}" ]; then
    echo "========== Using Fastlane to upload a staging IPA to Hockey... =========="
    bundle exec fastlane ios hockey_staging \
        || exit 1
fi

# If there are iTunes Connect creds, upload to TestFlight. 
if [ -n "${ITC_PASSWORD}" ]; then
    echo "========== Using Fastlane to upload a production IPA to TestFlight... =========="
    bundle exec fastlane ios itc \
        || exit 1
fi

if [[ "${TAG_ON_DISTRIBUTION}" == "true" ]]; then
    echo "========== Tagging build on github repository =========="
    ./travis/tag_version.sh \
        || exit 1
fi
