#!/usr/bin/env sh
# ==============================================================================
# Script Name : hazy_hub.sh (Standalone) 
# Repository  : hazy-mods (SystemUI/UX & Layout Mods Repository)
# Ecosystem   : hazY.Ecosystem
# Description : Master Launcher Script for Modular hazY-mods Suite
# Target Env  : Termux / LADB / Shizuku (rish / sh / bash)
# ==============================================================================

# Script execution directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

main_launcher() {
    while true; do
        clear
        echo "=========================================="
        echo "            hazY.Ecosystem"
        echo "        hazY-mods Master Hub"
        echo "=========================================="
        echo " Active Repository Modules:"
        echo "=========================================="
        echo "  1) SystemUI Control"
        echo "     └─ (Icons, 0.25x Scales, Overlays)"
        echo ""
        echo "  2) Quick Settings Automation"
        echo "     └─ (Tile Injection, Layout Presets)"
        echo ""
        echo "  3) Layout & Density Mods"
        echo "     └─ (DPI, Density, Grid Layouts)"
        echo "------------------------------------------"
        echo "  4) Environment Status Check"
        echo "  5) Exit"
        echo "=========================================="
        printf "Select a module [1-5]: "
        read choice

        case "$choice" in
            1)
                if [ -f "$SCRIPT_DIR/hazy_sysui_control.sh" ]; then
                    sh "$SCRIPT_DIR/hazy_sysui_control.sh"
                else
                    echo ""; echo "[-] Error: hazy_sysui_control.sh not found!"
                    sleep 2
                fi
                ;;
            2)
                if [ -f "$SCRIPT_DIR/hazy_qs_automation.sh" ]; then
                    sh "$SCRIPT_DIR/hazy_qs_automation.sh"
                else
                    echo ""; echo "[-] Error: hazy_qs_automation.sh not found!"
                    sleep 2
                fi
                ;;
            3)
                if [ -f "$SCRIPT_DIR/hazy_layout_mods.sh" ]; then
                    sh "$SCRIPT_DIR/hazy_layout_mods.sh"
                else
                    echo ""; echo "[-] Error: hazy_layout_mods.sh not found!"
                    sleep 2
                fi
                ;;
            4)
                clear
                echo "=========================================="
                echo "       Environment Status Check"
                echo "=========================================="
                echo " Shell User   : $(whoami 2>/dev/null || echo 'Unknown')"
                echo " Shizuku/rish : $(command -v rish &>/dev/null && echo 'Detected' || echo 'Not in PATH')"
                echo " Settings Tool: $(command -v settings &>/dev/null && echo 'Available' || echo 'Missing')"
                echo " WM Tool      : $(command -v wm &>/dev/null && echo 'Available' || echo 'Missing')"
                echo "=========================================="
                printf "Press Enter to return..."
                read dummy
                ;;
            5)
                echo ""; echo "Exiting. Stay elevated!"; echo ""
                exit 0
                ;;
            *)
                echo ""; echo "[-] Invalid selection."
                sleep 1
                ;;
        esac
    done
}

main_launcher
