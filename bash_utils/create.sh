#!/bin/bash

# --- Dynamic Root Detection ---
# This finds the folder containing bash_utils and goes up one level
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Colors ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# --- Graceful Exit ---
trap "echo -e '\n${RED}Aborted.${NC}'; exit" SIGINT

echo -e "${GREEN}==== BHP Universal File Creator ====${NC}"

# 1. Select or Create a Module (Top-level folder)
echo -e "${BOLD}Current Modules in Root:${NC}"
# Lists only directories in the root, excluding hidden ones, venv, and utils
mapfile -t modules < <(find "$ROOT_DIR" -maxdepth 1 -type d ! -name ".*" ! -name "bash_utils" ! -name "venv" ! -path "$ROOT_DIR" -printf "%f\n")

for i in "${!modules[@]}"; do
    echo -e "${CYAN}$((i+1)))${NC} ${modules[$i]}"
done
echo -e "${CYAN}n)${NC} [Create New Module]"

read -p "Selection: " mod_choice

if [[ "$mod_choice" == "n" ]]; then
    read -p "Enter new module name: " target_module
    TARGET_PATH="$ROOT_DIR/$target_module"
elif [[ "$mod_choice" =~ ^[0-9]+$ ]] && [ "$mod_choice" -le "${#modules[@]}" ]; then
    TARGET_PATH="$ROOT_DIR/${modules[$((mod_choice-1))]}"
else
    echo -e "${RED}[!] Invalid selection.${NC}"
    exit 1
fi

# 2. Sub-directory handling
read -p "Enter sub-folder (optional, e.g., 'client'): " sub_folder
[[ -n "$sub_folder" ]] && TARGET_PATH="$TARGET_PATH/$sub_folder"

# Ensure the directory exists
mkdir -p "$TARGET_PATH"

# 3. File Creation
read -p "Python filename: " file_name
[[ "$file_name" != *.py ]] && file_name="$file_name.py"
FULL_PATH="$TARGET_PATH/$file_name"

if [ -f "$FULL_PATH" ]; then
    echo -e "${RED}[!] File already exists.${NC}"
    exit 1
fi

# 4. Write Boilerplate
cat <<EOF > "$FULL_PATH"
#!/usr/bin/env python3
import socket
import sys

"""
Project: $file_name
Module: ${TARGET_PATH#$ROOT_DIR/}
"""

def main():
    print("[*] Script started...")

if __name__ == '__main__':
    main()
EOF

chmod +x "$FULL_PATH"

echo -e "\n${GREEN}[✔] Created:${NC} ${FULL_PATH#$ROOT_DIR/}"