#!/bin/bash

# Title and message
echo "Title: Docker No-Root Install Step-2"
echo "This script will install dbus-user-session & uidmap for the purposes of setting up the Docker daemon as root-less, it will then reboot the machine."

# Prompt user to proceed or cancel
read -rp "Do you want to proceed with the script? (y/n): " user_input

case $user_input in
    [Yy]* )
        echo "Proceeding with the script..."
        sudo apt update
        sudo apt-get install -y dbus-user-session
        sudo apt-get install -y uidmap
        echo "The system will now reboot."
        sudo reboot now
        ;;
    [Nn]* )
        echo "Script cancelled by the user."
        exit 0
        ;;
    * )
        echo "Invalid input. Please run the script again and enter 'y' to proceed or 'n' to cancel."
        exit 1
        ;;
esac
