#!/bin/bash

# Determine OS name
OS=$(uname)

if [ "$OS" == "Linux" ]; then
  echo "Linux OS detected"

  # Determine Linux distribution
  if [[ -f /etc/fedora-release ]]; then
    echo "Fedora detected"

    # Determine graphics card
    if [[ $(lspci | grep -i nvidia) ]]; then
      echo "Nvidia graphics card detected"
      # sudo dnf install -y akmod-nvidia
    fi # End of Nvidia graphics card detection

  fi # End of Fedora detection

fi # End of Linux OS detection
