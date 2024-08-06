#!/bin/zsh

# A function to list dependencies using otool and copy them to the Frameworks directory
copy_dependencies() {
    local lib="$1"
    local destination="$2"
    # Avoid processing the same library multiple times
    if [[ -z "${seen[$lib]}" ]]; then
        seen[$lib]=1

        # Check if the library exists before attempting to copy
        if [[ -f "$lib" || -L "$lib" ]]; then  # Check for file existence or if it's a symlink
            # Copy library to the destination's Frameworks directory, following symlinks
            echo "Copying $lib to $destination..."
            cp -RL "$lib" "$destination"  # -L follows the symlink to copy the actual file

            # Use otool to list the dependencies
            local deps=("${(@f)$(otool -L "$lib" | awk 'NR>1 {print $1}')}")
            for dep in $deps; do
                if [[ "$dep" != /usr/lib/* && "$dep" != /System/* ]]; then
                    # Recursively copy dependencies of this dependency
                    copy_dependencies "$dep" "$destination"
                fi
            done
        else
            echo "Library $lib not found."
        fi
    fi
}

# Check for the minimum number of arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <library_path1> [<library_path2> ... <library_pathN>] <frameworks_folder_path>"
    exit 1
fi

# Associative array to track which libraries have been seen
typeset -A seen

# Extract the last argument as the destination frameworks folder path
frameworks_folder_path=${@: -1}

# Create the Frameworks directory if it doesn't already exist
mkdir -p "$frameworks_folder_path"

# Loop through all arguments except the last one
for lib in "$@"
do
    # Skip processing for the last argument, which is the frameworks folder path
    if [[ $lib == $frameworks_folder_path ]]; then
        continue
    fi

    # Check if the library file exists or if it's a symlink
    if [[ ! -f "$lib" && ! -L "$lib" ]]; then
        echo "The file $lib does not exist or is not a symlink."
        continue # Continue with next file instead of exiting
    fi

    # Copy dependencies of the library
    copy_dependencies "$lib" "$frameworks_folder_path"
done

# Dependencies are now copied to your Xcode project's Frameworks folder.

