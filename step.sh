#!/usr/bin/env bash

REPO_SLUG="$BITRISE_APP_TITLE"
BUILD_URL="$BITRISE_BUILD_URL"
BASE_REPOSITORY_URL="https://api.bitbucket.org/2.0/repositories/m2y/$REPO_SLUG"
COMMIT_HASH=$(git log -1 --format=%H)

if [ "$build_status" != "AUTO" ]; then
    BUILD_STATUS=$build_status
else
    if [ "$BITRISE_BUILD_STATUS" == "0" ]; then
        BUILD_STATUS="SUCCESSFUL"
    else
        BUILD_STATUS="FAILED"
    fi
fi

CURL_BITRISE_URL="$BASE_REPOSITORY_URL/commit/$COMMIT_HASH/statuses/build"

echo "Preset status: $build_status"
echo "Build Status: $BUILD_STATUS"
echo "Updating build status for commit: $COMMIT_HASH"
echo "API Endpoint: $CURL_BITRISE_URL"

curl $CURL_BITRISE_URL \
    -X POST \
    -i \
    -u $username:$password \
    -H 'Content-Type: application/json' \
    --data-binary \
        $"{
            \"state\": \"$BUILD_STATUS\",
            \"key\": \"Bitrise - #$BITRISE_BUILD_NUMBER\",
            \"name\": \"Bitrise #$BITRISE_BUILD_NUMBER\",
            \"url\": \"$BUILD_URL\",
            \"description\": \"Build status updated from Bitrise\"
        }" \
    --compressed