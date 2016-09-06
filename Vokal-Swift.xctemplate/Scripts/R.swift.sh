#!/bin/bash

if [[ "${CI}" == 'true' && "${TRAVIS}" == 'true' ]]; then
    echo "R.swift will not be executed on Travis"
    exit 0
fi

"$PODS_ROOT/R.swift/rswift" "$SRCROOT"
