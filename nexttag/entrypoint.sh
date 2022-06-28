#!/bin/bash

# Changelog "items" sorted in relevance order
#
#   Breaking - for a backwards-incompatible enhancement.
#   New - implemented a new feature.
#   Upgrade - for a dependency upgrade.
#   Update - for a backwards-compatible enhancement.
#   Fix - for a bug fix.
#   Build - changes to build process only.
#   Docs - changes to documentation only.
#   Security - for security skills.
#   Deprecated - for deprecated features.

set -eo pipefail

function echo_debug () {
    if [ "$KD_DEBUG" == "1" ]; then
        echo >&2 ">>>> DEBUG >>>>> $(date "+%Y-%m-%d %H:%M:%S") $KD_NAME: " "$@"
    fi
}

KD_NAME="get-next-release-number"
echo_debug "begin"

# Calculate next release number
function calculateNextReleaseNumber () {
    local tagFrom
    tagFrom=$(git describe --abbrev=0 2> /dev/null || echo '')
    if [ "$tagFrom" == "" ]; then
        major="0"
        minor="1"
        patch="0"
    else
#        tagFrom=$(git describe --tags $(git rev-list --tags --max-count=1)||true 2> /dev/null)
#        read -r -a tagArray <<< "$tagFrom"
        tagArray=( ${tagFrom//./ } )
        major="${tagArray[0]}"
        minor="${tagArray[1]}"
        patch="${tagArray[2]}"
        OLDIFS="$IFS"
        IFS=$'\n' # bash specific
        if [ "${major:0:1}" == "v" ]; then
            major=${major:1}
        fi
        commitList=$(git log "${tagFrom}..HEAD" --no-merges --pretty=format:"%h %s")
        itemToIncrease="patch"
        for commit in $commitList; do
            type=$(echo "$commit"|awk '{print $2}')
            if [ "$type" == "New:" ] || [ "$type" == "Upgrade:" ]; then
                if [ "$itemToIncrease" == "patch" ]; then
                    itemToIncrease="minor"
                fi
            elif [ "$type" == "Breaking:" ]; then
                if [ "$itemToIncrease" != "major" ]; then
                    itemToIncrease="major"
                fi
            fi
        done
        case $itemToIncrease in
            "patch") 
                patch=$((patch + 1))
                ;;
            "minor")
                minor=$((minor + 1))
                patch="0"
                ;;
            "major")
                major=$((major + 1))
                minor="0"
                patch="0"
                ;;
        esac
        IFS=$OLDIFS
    fi
    echo "v${major}.${minor}.${patch}"

}

calculateNextReleaseNumber

echo_debug "end"
