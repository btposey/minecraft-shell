# Minecraft Server Management Scripts

A collection of shell scripts to simplify the management of a Minecraft: Java Edition server on a Linux host. These scripts allow a non-root user to easily download, start, stop, and interact with the server, making multi-user management over SSH straightforward and secure.

## Features

-   **Download Utility**: Automatically download the latest stable Minecraft server JAR or a specific version using the official Mojang API.
-   **Lifecycle Management**: Start the server in a detached background session, stop it gracefully, restart it, and check its status.
-   **Interactive Console**: Easily attach to the live server console to monitor logs and run admin commands.
-   **Secure by Design**: Designed to be run by a non-root user, enhancing server security.

## Prerequisites

These scripts require a Java runtime and several command-line utilities to function correctly.

### Java (JRE/JDK)

A Java Runtime Environment (JRE) version 17 or newer is required to run the Minecraft server. The recommended method for installing and managing Java versions is SDKMAN!

#### Preferred Method: SDKMAN!

SDKMAN! is a tool for managing parallel versions of multiple Software Development Kits on most Unix-like systems.

1.  **Install SDKMAN!** (if you don't already have it):
    ```bash
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    ```
    *You may need to open a new terminal session after installation for the `sdk` command to be available.*

2.  **Install a Long-Term Support (LTS) version of Java**:
    This command will install a recommended Java 17 version from the Adoptium project (Temurin).
    ```bash
    sdk install java 17.0.11-tem
    ```

#### Alternative: Platform-Specific Package Managers

If you prefer not to use SDKMAN!, you can use your system's package manager as a fallback.

-   **On Debian/Ubuntu:**
    ```bash
    sudo apt-get update && sudo apt-get install -y default-jre
    ```
-   **On Fedora/RHEL/CentOS:**
    ```bash
    sudo dnf install -y java-17-openjdk-headless
    ```
-   **On macOS (using Homebrew):**
    ```bash
    brew install openjdk@17
    ```
    *Note: After installing, you may need to follow post-install instructions from Homebrew to correctly symlink the JDK for command-line use.*

### Other Tools

You will also need `curl`, `jq`, `wget`, and `screen`.

-   **On Debian/Ubuntu:**
    ```bash
    sudo apt-get update && sudo apt-get install -y curl jq wget screen
    ```
-   **On Fedora/RHEL/CentOS:**
    ```bash
    sudo dnf install -y curl jq wget screen
    ```
-   **On macOS (using Homebrew):**
    ```bash
    brew install jq wget screen
    ```

## Scripts Guide

### `setup.sh` (Server Configuration)

This project uses a `.env` file to store persistent configuration for your server. To get started, run the interactive setup script:

```bash
./setup.sh
```

This will ask for your desired Minecraft version and memory allocation and will generate the `.env` file for you.

#### Environment Variables

The following variables are supported:

-   `MC_VERSION`: The version of the Minecraft server to download. This can be a specific version number (e.g., `1.18.2`) or `latest` for the newest stable release.
-   `MC_MEMORY`: The maximum memory (in Gigabytes) to allocate to the server (e.g., `4`). This controls the `-Xmx` Java flag.
-   `MC_USE_NEOFORGE`: Set to `FALSE` by default. If you want to use NeoForge, set this to the version you wish to use (e.g., `21.4.111-beta`).

The settings in the `.env` file serve as defaults.

---

### `download.sh`

This script downloads the official `server.jar` file from Mojang or a NeoForge server, if configured. It's the first step to setting up your server.

**Usage**

-   **To download the server:**
    ```bash
    ./download.sh
    ```
    If `MC_USE_NEOFORGE` is set in your `.env` file, this will download and install the specified NeoForge version. Otherwise, it will download the vanilla Minecraft server version specified by `MC_VERSION`.

-   **To download a specific version:**
    Use the `-v` flag followed by the version number.
    ```bash
    ./download.sh -v 1.18.2
    ```
    
    Using the `-v` flag in the `download.sh` script overrides the `MC_VERSION` variable in the `.env` file.

-   **To display help:**
    ```bash
    ./download.sh -h
    ```

---

### `minecraft.sh`

This script is used to control the server's lifecycle (start, stop, etc.). It uses `screen` to run the server in a detached session, meaning it will keep running even if you log out.

**Configuration**

Before using this script, you may want to adjust the configuration variables at the top of the file:

-   `SESSION_NAME`: The unique name for the `screen` session. You generally don't need to change this.
-   `JAR_FILE`: The name of your server JAR file. Defaults to `server.jar`.
-   `JAVA_OPTS`: The Java Virtual Machine options, most importantly the memory allocation.
    -   `-Xmx2G` sets the maximum RAM to 2 Gigabytes or the maximum set by the `MC_MEMORY` variable in the `.env` file.
    -   `-Xms1G` sets the initial RAM to 1 Gigabyte.

**Usage**

-   **To start the server:**
    ```bash
    ./minecraft.sh start
    ```

-   **To stop the server:**
    This sends a graceful `stop` command to ensure the world is saved properly.
    ```bash
    ./minecraft.sh stop
    ```

-   **To check the server's status:**
    ```bash
    ./minecraft.sh status
    ```

-   **To restart the server:**
    This will gracefully stop and then start the server again.
    ```bash
    ./minecraft.sh restart
    ```

-   **To view the server console:**
    This attaches you to the live console.
    ```bash
    ./minecraft.sh console
    ```
    To detach from the console and leave the server running in the background, press **`Ctrl+A`** followed by **`D`**.

## Quick Start Workflow

1.  **Clone this repository** and `cd` into the directory.
2.  **Download the server JAR**:

    ```bash

    ./download.sh

    ```
3.  **Start your server**:

    ```bash

    ./minecraft.sh start

    ```

    Your server is now running in the background!
