#!/bin/bash
# =============================================================================
# Server Configuration Setup Script
#
# Author: Gemini
# Description: An interactive script to create and update the .env file
#              for Minecraft server configuration.
# =============================================================================

ENV_FILE=".env"
echo "--- Minecraft Server Configuration ---"
echo "This script will help you set up your configuration file ($ENV_FILE)."
echo

# --- Load existing values if .env file exists ---
if [ -f "$ENV_FILE" ]; then
    echo "Loading existing configuration from $ENV_FILE..."
    source "$ENV_FILE"
    echo
fi

# --- Prompt for Minecraft Version ---
DEFAULT_VERSION=${MC_VERSION:-"latest"}
read -p "Enter Minecraft version [Default: $DEFAULT_VERSION]: " USER_VERSION
MC_VERSION=${USER_VERSION:-$DEFAULT_VERSION}

# --- Prompt for Memory ---
DEFAULT_MEMORY=${MC_MEMORY:-"2"}
read -p "Enter memory size in GB (e.g., 4) [Default: $DEFAULT_MEMORY]: " USER_MEMORY
MC_MEMORY=${USER_MEMORY:-$DEFAULT_MEMORY}

# --- Write to .env file ---
echo
echo "Saving configuration to $ENV_FILE..."
echo "# Minecraft Server Configuration" > "$ENV_FILE"
echo "MC_VERSION=$MC_VERSION" >> "$ENV_FILE"
echo "MC_MEMORY=$MC_MEMORY" >> "$ENV_FILE"

echo "Configuration saved:"
cat "$ENV_FILE"
echo
echo "Setup complete."
