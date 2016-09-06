#!/bin/bash

# Makes it possible to grab comments with warnings and have the compiler emit warnings.
# source: http://bendodson.com/weblog/2014/10/02/showing-todo-as-warning-in-swift-xcode-project/
TAGS="WARN:"
echo "note: searching ${SRCROOT} for ${TAGS}..."

# Omit the R.swift pod directory, since it's not a Swift file
find "${SRCROOT}" \
    \( -not -path "${PODS_ROOT}/R.swift" -name "*.swift" \) \
    -print0 \
    | xargs \
    -0 \
    egrep \
    --with-filename \
    --line-number \
    --only-matching \
    "($TAGS).*\$" \
    | perl \
    -p \
    -e "s/($TAGS)/ warning: \$1/"
