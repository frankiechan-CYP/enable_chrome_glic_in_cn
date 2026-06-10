#!/bin/bash

# Determine directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make python script executable
chmod +x "$DIR/mac_enable_glic.py"

# Run it
python3 "$DIR/mac_enable_glic.py"
