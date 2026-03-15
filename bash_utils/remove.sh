#!/bin/bash

# --- Dynamic Root Detection ---
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$ROOT_DIR/backup"
UTILS_DIR="$ROOT_DIR/bash_utils"
RECOVER_SCRIPT="$UTILS_DIR/recover.sh"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# --- Graceful Exit ---
trap "echo -e '\n${YELLOW}Action cancelled.${NC}'; exit" SIGINT

echo -e "${RED}${BOLD}==== BHP File Management Tool ====${NC}"

# 1. Search for Python files (excluding system folders)
mapfile -t files < <(find "$ROOT_DIR" -maxdepth 3 -type f -name "*.py" \
    ! -path "*/venv/*" \
    ! -path "*/backup/*" \
    ! -path "*/bash_utils/*" \
    ! -path "*/__pycache__/*")

if [ ${#files[@]} -eq 0 ]; then
    echo -e "${YELLOW}[!] No scripts found to manage.${NC}"
    exit 0
fi

echo -e "${BOLD}Select a file to remove:${NC}"
for i in "${!files[@]}"; do
    rel_path="${files[$i]#$ROOT_DIR/}"
    printf "${CYAN}%2d)${NC} %s\n" "$((i+1))" "$rel_path"
done
echo -e "-------------------------------------"

read -p "Selection (or 'q' to quit): " choice

if [[ "$choice" == "q" ]]; then
    exit 0
elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -le "${#files[@]}" ]; then
    TARGET="${files[$((choice-1))]}"
else
    echo -e "${RED}[!] Invalid selection.${NC}"
    exit 1
fi

# 2. Choose Action
echo -e "\n${BOLD}Target:${NC} ${YELLOW}${TARGET#$ROOT_DIR/}${NC}"
echo -e "1) ${GREEN}Backup${NC}"
echo -e "2) ${RED}Permanent Delete${NC}"
read -p "Selection: " action_choice

case $action_choice in
    1)
        # --- Backup Logic ---
        mkdir -p "$BACKUP_DIR"
        timestamp=$(date +%Y%m%d_%H%M%S)
        filename=$(basename "$TARGET")
        ORIGINAL_DIR=$(dirname "$TARGET")
        BACKUP_PATH="$BACKUP_DIR/${timestamp}_${filename}"
        
        mv "$TARGET" "$BACKUP_PATH"
        
        # --- Recovery Script Initialization (Run Once) ---
        if [ ! -f "$RECOVER_SCRIPT" ]; then
            cat <<'EOF' > "$RECOVER_SCRIPT"
#!/bin/bash
# BHP Recovery Tool
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}[*] Attempting to recover the last backed-up file...${NC}"

# The remove.sh script will update the values below
EOF
            chmod +x "$RECOVER_SCRIPT"
            echo -e "${CYAN}[*] Created new recovery utility: bash_utils/recover.sh${NC}"
        fi

        # --- Update recover.sh with the LATEST backup info ---
        # This replaces the logic lines in recover.sh with the current file's info
        sed -i '/# RECOVERY_LOGIC_START/,/# RECOVERY_LOGIC_END/d' "$RECOVER_SCRIPT"
        cat <<EOF >> "$RECOVER_SCRIPT"
# RECOVERY_LOGIC_START
if [ -f "$BACKUP_PATH" ]; then
    mkdir -p "$ORIGINAL_DIR"
    mv "$BACKUP_PATH" "$TARGET"
    echo -e "${GREEN}[✔] Restored: $filename -> ${TARGET#$ROOT_DIR/}${NC}"
else
    echo -e "${RED}[!] Error: Backup not found at $BACKUP_PATH${NC}"
fi
# RECOVERY_LOGIC_END
EOF
        
        echo -e "${GREEN}[✔] File backed up successfully.${NC}"
        echo -e "${YELLOW}[!] If you need to recover it, run: ${BOLD}./bash_utils/recover.sh${NC}"
        ;;
    2)
        read -p "Type 'yes' to permanently delete: " confirm
        if [[ "$confirm" == "yes" ]]; then
            rm "$TARGET"
            echo -e "${GREEN}[✔] Deleted.${NC}"
        fi
        ;;
    *)
        exit 1
        ;;
esac