#!/bin/zsh

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <FRAMEWORKS_DIR> <NEW_INSTALL_NAME_DIR>"
    exit 1
fi

FRAMEWORKS_DIR="$1"
NEW_INSTALL_NAME_DIR="$2"

# Function to change install_name for a single library
change_install_name() {
    local lib="$1"
    local filename=$(basename "$lib")
    install_name_tool -id "$NEW_INSTALL_NAME_DIR/$filename" "$lib"
}

# Change install_name for each .dylib file
find "$FRAMEWORKS_DIR" -type f -name "*.dylib" | while read -r lib; do
    echo "Changing install_name for $lib"
    change_install_name "$lib"
done

echo "Install_name changes complete."

