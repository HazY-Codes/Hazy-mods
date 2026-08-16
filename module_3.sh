#!/usr/bin/env sh
# ==============================================================================
# Module 3 : Layout & Density Mods
# Suite    : hazY-mods (hazY.Ecosystem)
# ==============================================================================

get_current_density() {
    curr_density=$(wm density 2>/dev/null | grep "Override density" | awk '{print $3}')
    if [ -z "$curr_density" ]; then
        curr_density=$(wm density 2>/dev/null | grep "Physical density" | awk '{print $3}')
        density_label="${curr_density} (Stock Physical)"
    else
        density_label="${curr_density} (Custom Override)"
    fi
}

set_density() {
    target_dpi="$1"
    if [ "$target_dpi" = "reset" ]; then
        wm density reset
        echo ""; echo "[+] Reset screen density to physical stock value."
    else
        wm density "$target_dpi"
        echo ""; echo "[+] Display density updated to ${target_dpi} DPI."
    fi
}

# Module Entry Point
while true; do
    clear
    get_current_density

    echo "=========================================="
    echo "     hazY-mods | Layout & Density Mods"
    echo "=========================================="
    echo " Active Display Density:"
    echo "   • DPI: ${density_label}"
    echo "=========================================="
    echo " Presets & Controls:"
    echo "  1) Tablet / Dual-Pane (600 DPI - Smaller UI, High Space)"
    echo "  2) Compact Desktop    (480 DPI - More Content On-Screen)"
    echo "  3) Large Mode         (380 DPI - Bigger Icons/Text)"
    echo "  4) Reset Stock        (Reset to Default Device Physical DPI)"
    echo "  5) Enter Custom DPI"
    echo "  6) Exit Script"
    echo "=========================================="
    printf "Select an option [1-6]: "
    read choice

    case "$choice" in
        1) set_density "600" ;;
        2) set_density "480" ;;
        3) set_density "380" ;;
        4) set_density "reset" ;;
        5) 
            printf "Enter target DPI (Higher = Smaller UI, Lower = Larger UI): "
            read custom_dpi
            [ -n "$custom_dpi" ] && set_density "$custom_dpi"
            ;;
        6) exit 0 ;;
        *) echo ""; echo "[-] Invalid option." ;;
    esac
    printf "Press Enter to continue..."
    read dummy
done
