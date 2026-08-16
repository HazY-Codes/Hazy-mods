#!/usr/bin/env sh
# ==============================================================================
# Module 2 : Quick Settings Automation
# Suite    : hazY-mods (hazY.Ecosystem)
# ==============================================================================

get_active_tiles() {
    curr_tiles=$(settings get secure sysui_qs_tiles 2>/dev/null)
    if [ -z "$curr_tiles" ] || [ "$curr_tiles" = "null" ]; then
        display_tiles="(System Default Layout)"
        curr_tiles="default"
    else
        display_tiles="$curr_tiles"
    fi
}

apply_qs_preset() {
    preset_name="$1"
    preset_string="$2"

    get_active_tiles
    backup_tiles="$curr_tiles"

    settings put secure sysui_qs_tiles "$preset_string"
    echo ""
    echo "[+] Applied '${preset_name}' preset!"
    echo "    Active Tiles: ${preset_string}"
}

# Module Entry Point
while true; do
    clear
    get_active_tiles

    echo "=========================================="
    echo "   hazY-mods | Quick Settings Automation"
    echo "=========================================="
    echo " Current Active Layout:"
    echo "   ${display_tiles}"
    echo "=========================================="
    echo " Layout Presets:"
    echo "  1) Minimalist QS   (Internet, BT, Flashlight, Night)"
    echo "  2) Power User QS  (Net, BT, DND, Cast, Hotspot, Rotate)"
    echo "  3) Media Focus    (BT, Cast, Volume, Flashlight)"
    echo "  4) Reset Stock    (System Default OS tiles)"
    echo "------------------------------------------"
    echo " Actions:"
    echo "  5) Inject Custom Tile Specifier"
    echo "  6) Restore Session Backup"
    echo "  7) Exit Script"
    echo "=========================================="
    printf "Select an option [1-7]: "
    read choice

    case "$choice" in
        1) apply_qs_preset "Minimalist" "internet,bt,flashlight,night" ;;
        2) apply_qs_preset "Power User" "internet,bt,dnd,cast,hotspot,rotation,flashlight,work" ;;
        3) apply_qs_preset "Media Focus" "bt,cast,volume_control,flashlight,night" ;;
        4) apply_qs_preset "Stock Default" "default" ;;
        5) 
            printf "Enter tile specifier (e.g. wifi, cell, bt, dnd): "
            read custom_tile
            if [ -n "$custom_tile" ]; then
                [ -z "$curr_tiles" ] || [ "$curr_tiles" = "null" ] && new_tiles="$custom_tile" || new_tiles="${curr_tiles},${custom_tile}"
                settings put secure sysui_qs_tiles "$new_tiles"
                echo ""; echo "[+] Injected tile: $custom_tile"
            fi
            ;;
        6) 
            if [ -n "$backup_tiles" ]; then
                settings put secure sysui_qs_tiles "$backup_tiles"
                echo ""; echo "[+] Restored previous layout."
            else
                echo ""; echo "[-] No backup found in this session."
            fi
            ;;
        7) exit 0 ;;
        *) echo ""; echo "[-] Invalid option." ;;
    esac
    printf "Press Enter to continue..."
    read dummy
done
