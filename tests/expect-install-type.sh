#!/bin/bash

get_install_type() {
    local runreal_path=$(which runreal 2>/dev/null)
    
    if [ -z "$runreal_path" ]; then
        echo "unknown"
        return
    fi
    
    # Check if it's a deno script in the .deno/bin directory
    if echo "$runreal_path" | grep -q ".deno/bin"; then
        echo "source"
    # Check if the command comes from the plugin bin directory
    elif echo "$runreal_path" | grep -q "bin/runreal"; then
        echo "binary"
    else
        echo "unknown"
    fi
}

compare_install_types() {
    if [ "$1" = "$2" ]; then
        echo "Install type matches: $1"
        return 0
    else
        echo "Install type mismatch: expected $1, got $2"
        return 1
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <expected_install_type>"
    echo "Expected install types: 'binary' or 'source'"
    exit 1
fi

expected_type="$1"
actual_type=$(get_install_type)

compare_install_types "$expected_type" "$actual_type"
exit $? 