#!/usr/bin/env sh
# ==============================================================================
# Script Name : hazy_hub.sh (Modules Integrated)
# Repository  : hazy-mods (SystemUI/UX & Layout Mods Repository)
# Ecosystem   : hazY.Ecosystem
# Description : Complete Unified SystemUI, QS Automation, & Layout Suite
# Target Env  : Termux / LADB / Shizuku (rish / sh / bash)
# ==============================================================================

# ------------------------------------------------------------------------------
# MODULE 1: SYSTEMUI CONTROL (Icons, Animation Scales, Overlays)
# ------------------------------------------------------------------------------
get_current_scales() {
    win=$(settings get global window_animation_scale 2>/dev/null)
    trans=$(settings get global transition_animation_scale 2>/dev/null)
    anim=$(settings get global animator_duration_scale 2>/dev/null)

    curr_win="${win:-1.0}"; [ "$curr_win" = "null" ] && curr_win="1.0"
    curr_trans="${trans:-1.0}"; [ "$curr_trans" = "null" ] && curr_trans="1.0"
    curr_anim="${anim:-1.0}"; [ "$curr_anim" = "null" ] && curr_anim="1.0"
}

set_anim_scales() {
    scale="$1"
    settings put global window_animation_scale "$scale"
    settings put global transition_animation_scale "$scale"
    settings put global animator_duration_scale "$scale"
    echo ""
    echo "[+] Animation scales updated to ${scale}x."
}

animation_scale_menu() {
    while true; do
        clear
        get_current_scales

        echo "=========================================="
        echo "   hazY-mods | Animation Scaler"
        echo "=========================================="
        echo " Active Values:"
        echo "   • Window Scale:     ${curr_win}x"
        echo "   • Transition Scale: ${curr_trans}x"
        echo "   • Animator Scale:   ${curr_anim}x"
        echo "=========================================="
        echo "  1) Ultra Fast    (0.25x)"
        echo "  2) Fast          (0.50x)"
        echo "  3) Balanced      (0.75x)"
        echo "  4) Stock/Default (1.00x)"
        echo "  5) Off           (0.00x)"
        echo "  6) Custom Value"
        echo "  7) Back to Module Menu"
        echo "=========================================="
        printf "Select an option [1-7]: "
        read choice

        case "$choice" in
            1) set_anim_scales "0.25" ;;
            2) set_anim_scales "0.5" ;;
            3) set_anim_scales "0.75" ;;
            4) set_anim_scales "1.0" ;;
            5) set_anim_scales "0" ;;
            6) 
                printf "Enter decimal value (e.g. 0.15): "
                read custom_val
                if [ -n "$custom_val" ]; then
                    set_anim_scales "$custom_val"
                else
                    echo ""
                    echo "[-] Invalid float format."
                fi
                ;;
            7) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

get_current_blacklist() {
    curr_blacklist=$(settings get secure icon_blacklist 2>/dev/null)
    if [ "$curr_blacklist" = "null" ] || [ -z "$curr_blacklist" ]; then
        display_blacklist="(None - All icons visible)"
        curr_blacklist=""
    else
        display_blacklist="$curr_blacklist"
    fi
}

toggle_icon() {
    target="$1"
    get_current_blacklist

    case ",$curr_blacklist," in
        *",$target,"*)
            new_list=$(echo "$curr_blacklist" | tr ',' '\n' | grep -v "^${target}$" | paste -sd, -)
            echo ""
            echo "[+] Unhiding '${target}' icon..."
            ;;
        *)
            if [ -z "$curr_blacklist" ]; then
                new_list="$target"
            else
                new_list="${curr_blacklist},${target}"
            fi
            echo ""
            echo "[+] Hiding '${target}' icon..."
            ;;
    esac

    settings put secure icon_blacklist "$new_list"
}

status_bar_menu() {
    while true; do
        clear
        get_current_blacklist

        echo "=========================================="
        echo "   hazY-mods | Status Bar Icon Cleaner"
        echo "=========================================="
        echo " Active Blacklist:"
        echo "   ${display_blacklist}"
        echo "=========================================="
        echo " Toggle Common Icons:"
        echo "  1) Volume        (volume)"
        echo "  2) Alarm Clock   (alarm)"
        echo "  3) Cast / Mirror (cast)"
        echo "  4) Bluetooth     (bluetooth)"
        echo "  5) Do Not Disturb (zen)"
        echo "  6) Rotate Lock   (rotate)"
        echo "------------------------------------------"
        echo " Presets & Custom:"
        echo "  7) Clean Mode    (Hide volume,alarm,cast,rotate,zen)"
        echo "  8) Unhide All    (Reset blacklist)"
        echo "  9) Custom Identifier"
        echo " 10) Back to Module Menu"
        echo "=========================================="
        printf "Select an option [1-10]: "
        read choice

        case "$choice" in
            1) toggle_icon "volume" ;;
            2) toggle_icon "alarm" ;;
            3) toggle_icon "cast" ;;
            4) toggle_icon "bluetooth" ;;
            5) toggle_icon "zen" ;;
            6) toggle_icon "rotate" ;;
            7) 
                settings put secure icon_blacklist "volume,alarm,cast,rotate,zen"
                echo ""
                echo "[+] Applied 'Clean Mode' preset."
                ;;
            8) 
                settings put secure icon_blacklist ""
                echo ""
                echo "[+] Reset blacklist. All status bar icons unhidden."
                ;;
            9) 
                printf "Enter icon identifier string: "
                read custom_icon
                if [ -n "$custom_icon" ]; then
                    toggle_icon "$custom_icon"
                else
                    echo ""
                    echo "[-] Input cannot be empty."
                fi
                ;;
            10) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

overlay_menu() {
    while true; do
        clear
        echo "=========================================="
        echo "     hazY-mods | Overlay Manager"
        echo "=========================================="
        echo "  1) List Overlays & States"
        echo "  2) Enable an Overlay"
        echo "  3) Disable an Overlay"
        echo "  4) Back to Module Menu"
        echo "=========================================="
        printf "Select an option [1-4]: "
        read choice

        case "$choice" in
            1) 
                echo ""
                echo "--- Installed System Overlays ---"
                cmd overlay list 2>/dev/null | grep -E "^\[|^[a-zA-Z0-9._]+$" | head -n 30
                echo "---------------------------------"
                echo ""
                ;;
            2) 
                printf "Enter overlay package name to ENABLE: "
                read pkg_name
                if [ -n "$pkg_name" ]; then
                    cmd overlay enable "$pkg_name" 2>/dev/null
                    echo ""
                    echo "[+] Enabled overlay: $pkg_name"
                fi
                ;;
            3) 
                printf "Enter overlay package name to DISABLE: "
                read pkg_name
                if [ -n "$pkg_name" ]; then
                    cmd overlay disable "$pkg_name" 2>/dev/null
                    echo ""
                    echo "[+] Disabled overlay: $pkg_name"
                fi
                ;;
            4) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

sysui_module_menu() {
    while true; do
        clear
        echo "=========================================="
        echo "       hazY-mods | SystemUI Control"
        echo "=========================================="
        echo "  1) Status Bar Icon Cleaner"
        echo "  2) Animation Scale Adjuster"
        echo "  3) System Overlay Manager"
        echo "  4) Return to Master Hub"
        echo "=========================================="
        printf "Select an option [1-4]: "
        read sub_choice

        case "$sub_choice" in
            1) status_bar_menu ;;
            2) animation_scale_menu ;;
            3) overlay_menu ;;
            4) break ;;
            *) echo ""; echo "[-] Invalid option." ; sleep 1 ;;
        esac
    done
}

# ------------------------------------------------------------------------------
# MODULE 2: QUICK SETTINGS AUTOMATION
# ------------------------------------------------------------------------------
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

qs_module_menu() {
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
        echo "  6) Restore Previous Layout Backup"
        echo "  7) Return to Master Hub"
        echo "=========================================="
        printf "Select an option [1-7]: "
        read choice

        case "$choice" in
            1) apply_qs_preset "Minimalist" "internet,bt,flashlight,night" ;;
            2) apply_qs_preset "Power User" "internet,bt,dnd,cast,hotspot,rotation,flashlight,work" ;;
            3) apply_qs_preset "Media Focus" "bt,cast,volume_control,flashlight,night" ;;
            4) apply_qs_preset "Stock Default" "default" ;;
            5) 
                printf "Enter tile specifier (e.g. wifi, cell, bt, dnd, or custom component): "
                read custom_tile
                if [ -n "$custom_tile" ]; then
                    if [ -z "$curr_tiles" ] || [ "$curr_tiles" = "null" ]; then
                        new_tiles="$custom_tile"
                    else
                        new_tiles="${curr_tiles},${custom_tile}"
                    fi
                    settings put secure sysui_qs_tiles "$new_tiles"
                    echo ""
                    echo "[+] Injected tile: $custom_tile"
                fi
                ;;
            6) 
                if [ -n "$backup_tiles" ]; then
                    settings put secure sysui_qs_tiles "$backup_tiles"
                    echo ""
                    echo "[+] Restored previous Quick Settings layout."
                else
                    echo ""
                    echo "[-] No previous layout backup found in this session."
                fi
                ;;
            7) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

# ------------------------------------------------------------------------------
# MODULE 3: LAYOUT & DENSITY MODS
# ------------------------------------------------------------------------------
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
        echo ""
        echo "[+] Reset screen density to physical stock value."
    else
        wm density "$target_dpi"
        echo ""
        echo "[+] Display density updated to ${target_dpi} DPI."
    fi
}

layout_module_menu() {
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
        echo "  6) Return to Master Hub"
        echo "=========================================="
        printf "Select an option [1-6]: "
        read choice

        case "$choice" in
            1) set_density "600" ;;
            2) set_density "480" ;;
            3) set_density "380" ;;
            4) set_density "reset" ;;
            5) 
                printf "Enter target DPI integer (Higher = Smaller UI, Lower = Larger UI): "
                read custom_dpi
                if [ -n "$custom_dpi" ]; then
                    set_density "$custom_dpi"
                fi
                ;;
            6) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

# ------------------------------------------------------------------------------
# MASTER SUITE LAUNCHER
# ------------------------------------------------------------------------------
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
            1) sysui_module_menu ;;
            2) qs_module_menu ;;
            3) layout_module_menu ;;
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
                echo ""
                echo "Exiting. Stay elevated!"
                echo ""
                exit 0
                ;;
            *) 
                echo ""
                echo "[-] Invalid selection."
                sleep 1
                ;;
        esac
    done
}

# Start Suite
main_launcher
