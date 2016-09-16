#!/bin/sh

# This file contains the local values for Fastlane to be able to mimic being
# run on Travis with secure environment variables.
#
# To get fastlane to see the environment variables contained here, run this
# command from your repo root (use both dots or it won't work):
#   . ./fastlane/local_config.sh
#
# More info on this technique:
# http://macoscope.com/blog/automate-testing-and-build-delivery/
#
# NOTE: If variables are securely encrypted, they will not be available on a
#       PR on travis, and anything trying to make use of them will likely fail.
#
# DO NOT COMMIT THIS FILE UNDER PENALTY OF CATAPULT
# https://frinkiac.com/meme/S08E18/1207956.jpg?lines=%22AND+HE+WHO+SHALL+VIOLATE%0ATHIS+LAW+SHALL+BE+PUNISHED%0ABY+CATAPULT.%22

# To use a different email address to create/fetch signing certs and provisioning profiles, specify it here.
# This should be your personal account, rather than the shared account used by Travis. Make sure you have access to the 
# Apple Developer portal for the client. Note that this variable refers to match, but it's also used by sigh, apparently.
# export MATCH_USERNAME="FIXME"

# Password for the Apple Developer account specified in apple_dev_portal_id in the Appfile (or the MATCH_USERNAME,
# if set above)
export FASTLANE_PASSWORD='FIXME'

# The username (ie, email) of the iTunes Connect user to use to upload a build to iTunes 
# Connect for either TestFlight or App Store distribution.
# The corresponding password goes in the ITC_PASSWORD environment variable  
export ITC_USERNAME='FIXME'

# Password for the build server's iTunes Connect account.
# This is the password for the ITC_USERNAME user above.
# Remove this line if merge builds should not be uploaded to iTunes Connect, for App Store and/or TestFlight release.
export ITC_PASSWORD='FIXME'

# API Token for hockey uploading.
# Create one at https://rink.hockeyapp.net/manage/auth_tokens
# Remove this line if merge builds should not be uploaded to HockeyApp for distribution.
export HOCKEY_API_TOKEN='FIXME'

# Mimics Travis's pull request variable.
export TRAVIS_PULL_REQUEST=true

# folder containing all fastlane files
export FASTLANE_FOLDER='fastlane'

# folder name for builds, relative to FASTLANE_FOLDER
export BUILD_FOLDER='Build'

# folder name for test output, relative to FASTLANE_FOLDER
export TEST_OUTPUT_FOLDER='test_output'

# filename for test output, relative to TEST_OUTPUT_FOLDER
export TEST_COVERAGE_FILE='cobertura.xml'
