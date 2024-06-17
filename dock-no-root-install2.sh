#!/bin/bash

# Add your title here
echo "Title: [docker no-root install  step-2]"

# Add your custom message here
echo "[this script will install dbus-user-session & uidmap for the purposes of setting up the docker daemon as root-less, it will then reboot the machine]"

# Prompt user to proceed or cancel
read -p "Do you want to proceed with the script? (y/n): " user_input

if [[ $user_input == "y" ]]; then
    echo "Proceeding with the script..."
    sudo apt update
    sudo apt-get install -y dbus-user-session
    sudo apt-get install -y uidmap
    echo "The system will now reboot."
    sudo reboot now
elif [[ $user_input == "n" ]]; then
    echo "Script cancelled by the user."
    exit 0
else
    echo "Invalid input. Please run the script again and enter 'y' to proceed or 'n' to cancel."
    exit 1
fi
