#!/bin/bash
# =============================================================================
# Minecraft Server Downloader
#
# Author: Gemini
# Description: Downloads a specified or latest stable Minecraft server JAR
#              using the official Mojang version manifest API.
# Dependencies: curl, jq, wget
# =============================================================================

set -e # Exit immediately if a command exits with a non-zero status.

# --- Load Environment Configuration ---
if [ -f ".env" ]; then
    source ".env"
fi

# --- Default Configuration ---
# Priority: Command-line flag > .env variable > default
TARGET_VERSION=${MC_VERSION:-"latest"}

# --- Function for Usage Info ---
usage() {
    echo "Usage: $0 [-v <version>]"
    echo "  Downloads the latest stable Minecraft server JAR by default."
    echo
    echo "Options:"
    echo "  -v <version>   Specify a version to download (e.g., 1.18.2)."
    echo "  -h             Display this help message."
    exit 1
}

# --- Argument Parsing ---
while getopts "v:h" opt; do
    case ${opt} in
        v)
            TARGET_VERSION=${OPTARG}
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            usage
            ;;
    esac
done

# --- Main Script ---
echo "Verifying required tools (curl, jq, wget)..."
for tool in curl jq wget; do
  if ! command -v $tool &> /dev/null; then
    echo "Error: Required tool '$tool' is not installed. Please install it to continue." >&2
    exit 1
  fi
done

MANIFEST_URL="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
echo "Fetching version manifest from Mojang API..."

# Step 1 & 2: Fetch the main manifest and find the URL for the target version.
if [ "$TARGET_VERSION" == "latest" ]; then
    echo "Finding latest stable version..."
    VERSION_MANIFEST_URL=$(curl -sL "$MANIFEST_URL" | jq -r '.latest.release as $latest | .versions[] | select(.id == $latest) | .url')
else
    echo "Finding version '$TARGET_VERSION'..."
    VERSION_MANIFEST_URL=$(curl -sL "$MANIFEST_URL" | jq -r --arg version "$TARGET_VERSION" '.versions[] | select(.id == $version) | .url')
fi

if [ -z "$VERSION_MANIFEST_URL" ] || [ "$VERSION_MANIFEST_URL" == "null" ]; then
    echo "Error: Could not find manifest URL for version '$TARGET_VERSION'." >&2
    echo "Please make sure the version exists and is spelled correctly." >&2
    exit 1
fi

echo "Found version manifest URL. Fetching details..."

# Step 3 & 4: Fetch the version-specific manifest and find the server JAR download URL.
SERVER_JAR_URL=$(curl -sL "$VERSION_MANIFEST_URL" | jq -r '.downloads.server.url')

if [ -z "$SERVER_JAR_URL" ] || [ "$SERVER_JAR_URL" == "null" ]; then
    echo "Error: Could not find the server.jar download URL for version '$TARGET_VERSION'." >&2
    exit 1
fi

echo "Download URL found: $SERVER_JAR_URL"
echo "Starting download..."

# Step 5: Download the JAR file, naming it server.jar.
# The --show-progress flag provides a clean download bar.
wget --progress=bar:force:noscroll -O server.jar "$SERVER_JAR_URL"

if [ $? -eq 0 ]; then
    echo "Download complete! 'server.jar' has been saved."
else
    echo "Error: wget failed to download the file." >&2
    exit 1
fi

exit 0
