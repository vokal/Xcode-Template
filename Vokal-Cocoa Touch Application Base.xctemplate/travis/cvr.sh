#!/bin/bash

# Get the output folder for where the output is going to live
COBERTURA_FILE="${TRAVIS_BUILD_DIR}/${FASTLANE_FOLDER}/${TEST_OUTPUT_FOLDER}/${TEST_COVERAGE_FILE}"

echo "COBERTURA_FILE = ${COBERTURA_FILE}"

if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    # On a merge build, $TRAVIS_COMMIT is the merge commit
    LAST_COMMIT="${TRAVIS_COMMIT}"
else
    # For PRs, we have to do some more fiddling to get the proper commit hash ($TRAVIS_COMMIT is the hash of a merge
    # that Travis makes, not the hash of the last commit in the PR)
    LAST_COMMIT="${TRAVIS_COMMIT_RANGE##*...}"
fi

# Split the repo slug to get repo owner and name.
REPO_OWNER="${TRAVIS_REPO_SLUG%%/*}"
REPO_NAME="${TRAVIS_REPO_SLUG##*/}"

# Combine the git details into query parameters
GIT_PARAMS="owner=${REPO_OWNER}&repo=${REPO_NAME}&commit=${LAST_COMMIT}"

# Do the actual upload of PR coverage to cvr.vokal.io.
curl \
    -F coverage=@"${COBERTURA_FILE}" \
    "https://cvr.vokal.io/coverage?coveragetype=cobertura&${GIT_PARAMS}"
