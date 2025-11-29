#!/bin/bash

# =============================================================================
# Minecraft Server Management Script
#
# Author: Gemini
# Description: A script to manage a Minecraft server using 'screen'.
# It allows starting, stopping, checking status, and accessing the console.
# Place this script in the same directory as your server.jar.
# =============================================================================

# --- Configuration ---
# Name for the screen session (must be unique)
SESSION_NAME="minecraft_server"

# Server JAR file name
JAR_FILE="server.jar"

# Java VM options. -Xmx sets max RAM, -Xms sets initial RAM.
# Adjust these values based on your server's available memory.
# e.g., "4G" for 4 Gigabytes, "1024M" for 1024 Megabytes.
JAVA_OPTS="-Xmx2G -Xms1G"

# Command to start the server. The 'nogui' is crucial for server environments.
START_COMMAND="java ${JAVA_OPTS} -jar ${JAR_FILE} nogui"

# --- Script Logic ---

# Function to check if the server is running by looking for the screen session
is_running() {
    screen -list | grep -q "${SESSION_NAME}"
}

# Function to start the server
start_server() {
    if is_running; then
        echo "Server is already running."
        return 1
    fi

    echo "Starting Minecraft server..."
    # Create a new detached screen session named $SESSION_NAME
    # and run the start command inside it.
    screen -S "${SESSION_NAME}" -d -m bash -c "${START_COMMAND}"

    # Wait a few seconds to see if it started successfully
    sleep 3
    if is_running; then
        echo "Server started successfully in screen session '${SESSION_NAME}'."
    else
        echo "Error: Server failed to start. Check logs or try running manually."
        return 1
    fi
}

# Function to stop the server
stop_server() {
    if ! is_running; then
        echo "Server is not running."
        return 1
    fi

    echo "Sending 'stop' command to the server..."
    # Send the "stop" command to the Minecraft console running inside screen
    screen -S "${SESSION_NAME}" -p 0 -X stuff "stop\n"

    echo "Waiting for server to shut down..."
    # Wait until the screen session has terminated
    while is_running; do
        sleep 1
    done

    echo "Server stopped."
}

# Function to show the server status
show_status() {
    if is_running; then
        echo "Minecraft server is RUNNING in screen session '${SESSION_NAME}'."
    else
        echo "Minecraft server is STOPPED."
    fi
}

# Function to attach to the server console
attach_console() {
    if ! is_running; then
        echo "Server is not running. Cannot attach to console."
        return 1
    fi

    echo "Attaching to server console. Press 'Ctrl+A' then 'D' to detach."
    # Attach to the screen session.
    screen -r "${SESSION_NAME}"
}

# --- Command Handling ---
case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    status)
        show_status
        ;;
    restart)
        stop_server
        start_server
        ;;
    console)
        attach_console
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|console}"
        exit 1
        ;;
esac

exit 0
