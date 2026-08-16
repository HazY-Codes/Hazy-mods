#!/usr/bin/env sh
# hazY-mods Environment Setup Helper

echo "[+] Checking Termux & Shizuku environment..."

# Check for rish executable
if command -v rish >/dev/null 2>&1; then
    echo "[✓] Shizuku (rish) detected in PATH."
else
    echo "[!] Shizuku (rish) not found in PATH."
    echo "    Please configure rish inside Termux via Shizuku settings."
fi

# Make hazY scripts executable
chmod +x hazy_hub.sh 2>/dev/null
echo "[✓] Updated script permissions."
