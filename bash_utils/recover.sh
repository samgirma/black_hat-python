#!/bin/bash
# BHP Recovery Tool
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}[*] Attempting to recover the last backed-up file...${NC}"

# The remove.sh script will update the values below
# RECOVERY_LOGIC_START
if [ -f "/home/nox/cyber/black_hat_python/backup/20260315_220552_basic_TCP.py" ]; then
    mkdir -p "/home/nox/cyber/black_hat_python/networking/client"
    mv "/home/nox/cyber/black_hat_python/backup/20260315_220552_basic_TCP.py" "/home/nox/cyber/black_hat_python/networking/client/basic_TCP.py"
    echo -e "\033[0;32m[✔] Restored: basic_TCP.py -> networking/client/basic_TCP.py\033[0m"
else
    echo -e "\033[0;31m[!] Error: Backup not found at /home/nox/cyber/black_hat_python/backup/20260315_220552_basic_TCP.py\033[0m"
fi
# RECOVERY_LOGIC_END
