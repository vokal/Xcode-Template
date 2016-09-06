#!/bin/bash 

# For new versions of SwiftLint, you can create the portable_swiftlint.zip file by running "make portable_zip"
# from the root of the SwiftLint repo: https://github.com/realm/SwiftLint.

SWIFTLINT_DIR="${SRCROOT}/swiftlint"

unzip -o "${SWIFTLINT_DIR}/portable_swiftlint.zip" -d "${SWIFTLINT_DIR}" >/dev/null

# Run SwiftLint from the swiftlint folder in the repo.
"${SWIFTLINT_DIR}/swiftlint"
