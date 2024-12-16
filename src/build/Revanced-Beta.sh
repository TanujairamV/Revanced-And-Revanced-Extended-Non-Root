#!/bin/bash
# Revanced build with update check for YouTube Anddea Beta, YouTube Music Anddea Beta, and Instagram Beta

source ./src/build/utils.sh

# Download requirements
revanced_dl(){
    dl_gh "revanced-patches" "revanced" "prerelease"
    dl_gh "revanced-cli" "revanced" "latest"
}

# Function to check if an update is available for an app
check_for_update() {
    local package_name="$1"
    local version_file="$2"
    
    # Assume that we manually update the version file if a new version is available
    local latest_version=$(cat "$version_file")  # Get the latest version from version file

    # Compare current installed version with the latest available version
    if [[ "$latest_version" != "$current_version" ]]; then
        echo "Update found for $package_name: $current_version -> $latest_version"
        return 0 # Update available
    else
        echo "No update for $package_name."
        return 1 # No update
    fi
}

# Patch YouTube Anddea Beta
1() {
    revanced_dl
    if check_for_update "com.google.android.youtube" "youtube-anddea-version.txt"; then
        get_patches_key "youtube-rve-anddea"
        get_apk "com.google.android.youtube" "youtube-beta" "youtube" "google-inc/youtube/youtube" "Bundle_extract"
        split_editor "youtube-beta" "youtube-beta"
        patch "youtube-beta" "anddea" "inotia"
    else
        echo "Skipping YouTube Anddea Beta update."
    fi
}

# Patch YouTube Music Anddea Beta
2() {
    revanced_dl
    if check_for_update "com.google.android.apps.youtube.music" "youtube-music-anddea-version.txt"; then
        get_patches_key "youtube-music-rve-anddea"
        get_apk "com.google.android.apps.youtube.music" "youtube-music-beta-arm64-v8a" "youtube-music" "google-inc/youtube-music/youtube-music" "arm64-v8a"
        patch "youtube-music-beta-arm64-v8a" "anddea" "inotia"
    else
        echo "Skipping YouTube Music Anddea Beta update."
    fi
}

# Patch Instagram Beta
3() {
    revanced_dl
    if check_for_update "com.instagram.android" "instagram-version.txt"; then
        get_patches_key "instagram"
        version="360.0.0.52.192"
        get_apk "com.instagram.android" "instagram-arm64-v8a-beta" "instagram-instagram" "instagram/instagram-instagram/instagram-instagram" "arm64-v8a" "nodpi"
        patch "instagram-arm64-v8a-beta" "revanced"
    else
        echo "Skipping Instagram Beta update."
    fi
}

# Default case to handle different patching functions
case "$1" in
    1)
        1
        ;;
    2)
        2
        ;;
    3)
        3
        ;;
esac
