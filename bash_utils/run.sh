#!/bin/bash

# --- Configuration ---
BASE_DIR="$HOME/cyber/black_hat_python/networking"
VENV_PATH="$HOME/cyber/black_hat_python/venv/bin/activate"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' 

# --- Graceful Exit Handler ---
trap ctrl_c INT
function ctrl_c() {
    echo -e "\n${YELLOW}[!] Interrupted. Returning to menu...${NC}"
}

# --- Special Handler for nc.py ---
handle_netcat() {
    local script_path=$1
    echo -e "\n${BOLD}${CYAN}==== Netcat Configuration Wizard ====${NC}"
    echo -e "1) Listener: Command Shell (Reverse Shell)"
    echo -e "2) Listener: Simple (Just receive data)"
    echo -e "3) Client: Connect to a target"
    echo -e "4) Custom: Manual arguments"
    echo -e "q) Back to main menu"
    echo -e "-------------------------------------"
    read -p "Select usage mode: " nc_choice

    case $nc_choice in
        1)
            read -p "Port to listen on (default 5555): " port
            port=${port:-5555}
            # Binding to 0.0.0.0 is crucial for your Penguin/Phone setup
            run_python "$script_path" "-t 0.0.0.0 -p $port -l -c"
            ;;
        2)
            read -p "Port to listen on (default 5555): " port
            port=${port:-5555}
            run_python "$script_path" "-t 0.0.0.0 -p $port -l"
            ;;
        3)
            read -p "Target IP (Phone/Server): " target
            read -p "Target Port: " port
            run_python "$script_path" "-t $target -p $port"
            ;;
        4)
            read -p "Enter manual flags (e.g., -l -p 8080 -u test.txt): " manual_args
            run_python "$script_path" "$manual_args"
            ;;
        *) return ;;
    esac
}

# --- Execution Engine ---
run_python() {
    local script_path=$1
    local extra_args=$2
    
    # Activate venv if it exists
    [ -f "$VENV_PATH" ] && source "$VENV_PATH"

    echo -e "\n${GREEN}[+] Running: python3 $(basename "$script_path") $extra_args${NC}"
    echo -e "${CYAN}--------------------------------------------------${NC}"
    
    # Execute with passed arguments
    python3 "$script_path" $extra_args
    
    local status=$?
    echo -e "${CYAN}--------------------------------------------------${NC}"
    [ $status -eq 130 ] && echo -e "${YELLOW}[!] Interrupted.${NC}"
    [ $status -ne 0 ] && [ $status -ne 130 ] && echo -e "${RED}[✘] Error Code: $status${NC}"
}

# --- Main Menu ---
show_menu() {
    while true; do
        echo -e "\n${BOLD}${GREEN}==== BLACK HAT PYTHON MANAGER ====${NC}"
        mapfile -t files < <(find "$BASE_DIR" -type f -name "*.py" ! -path "*/__pycache__/*")

        for i in "${!files[@]}"; do
            rel_path="${files[$i]#$BASE_DIR/}"
            printf "${CYAN}%2d)${NC} %s\n" "$((i+1))" "$rel_path"
        done
        echo -e "${GREEN}==================================${NC}"
        read -p "Select a script (q to quit): " main_choice

        [[ "$main_choice" == "q" ]] && break

        if [[ "$main_choice" =~ ^[0-9]+$ ]] && [ "$main_choice" -le "${#files[@]}" ]; then
            selected="${files[$((main_choice-1))]}"
            
            # CHECK: Is this the netcat script?
            if [[ "$selected" == *"nc.py" ]]; then
                handle_netcat "$selected"
            else
                run_python "$selected"
            fi
        else
            echo -e "${RED}Invalid selection.${NC}"
        fi
    done
}

show_menu