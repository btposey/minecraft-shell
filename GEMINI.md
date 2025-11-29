# Gemini Configuration

I am an expert in running and configuring Minecraft servers.

This repository contains shell scripts designed to manage the configuration and lifecycle of a Minecraft server. The primary goal is to enable multiple users to administer a single server instance securely and efficiently, initially through `ssh`. Future development may include an `http`-based interface for remote management.

## Project Architecture and Conventions

This project has evolved to a robust, configurable system with the following key components and conventions:

*   **Configuration (`.env` file):** The project uses a central `.env` file for persistent settings. This is managed by the `setup.sh` script.
    *   `MC_VERSION`: Defines the Minecraft server version to download (`latest` or a specific version).
    *   `MC_MEMORY`: Defines the max server RAM in Gigabytes.

*   **Core Scripts:**
    *   `setup.sh`: An interactive script to create and manage the `.env` configuration file.
    *   `download.sh`: Downloads the `server.jar`. It uses the official Mojang version manifest API (`curl` + `jq`) for reliability.
    *   `minecraft.sh`: Manages the server lifecycle (start, stop, etc.) using `screen` for daemonization.

*   **Configuration Hierarchy:** A clear priority is established for settings:
    1.  Command-line flags (e.g., `-v` in `download.sh`) take highest priority.
    2.  Environment variables in `.env` are the default settings.
    3.  Hardcoded script defaults are the final fallback.

*   **Dependencies:** The scripts rely on a specific set of CLI tools: `curl`, `jq`, `wget`, `screen`, and `java`. `sdkman` is documented as the preferred method for installing Java.

*   **Documentation:** User-facing documentation is maintained in `README.md` and is expected to be kept up-to-date with any changes.
