#!/bin/bash

get_latest_version() {
    curl --silent "https://api.github.com/repos/runreal/cli/releases/latest" | 
    grep '"tag_name":' | 
    sed -E 's/.*"([^"]+)".*/\1/' |
    cut -c 2-
}

compare_versions() {
    if [ "$1" = "$2" ]; then
        echo "Version matches: $1"
    else
        echo "Version mismatch: expected $1, got $2"
        exit 1
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <expected_version>"
    exit 1
fi

expected_version="$1"
actual_version=$(runreal --version | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $2}')

if [ "$expected_version" = "latest" ]; then
    expected_version=$(get_latest_version)
fi

compare_versions "$expected_version" "$actual_version"