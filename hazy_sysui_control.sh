#!/usr/bin/env sh
# ==============================================================================
# Module 1 : SystemUI Control
# Suite    : hazY-mods (hazY.Ecosystem)
# ==============================================================================

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
        echo "  7) Exit Sub-Menu"
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
                    echo ""; echo "[-] Invalid float format."
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
            echo ""; echo "[+] Unhiding '${target}' icon..."
            ;;
        *)
            if [ -z "$curr_blacklist" ]; then
                new_list="$target"
            else
                new_list="${curr_blacklist},${target}"
            fi
            echo ""; echo "[+] Hiding '${target}' icon..."
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
        echo " 10) Exit Sub-Menu"
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
            7) settings put secure icon_blacklist "volume,alarm,cast,rotate,zen"; echo ""; echo "[+] Applied 'Clean Mode' preset." ;;
            8) settings put secure icon_blacklist ""; echo ""; echo "[+] Reset blacklist. All icons unhidden." ;;
            9) 
                printf "Enter icon identifier string: "
                read custom_icon
                [ -n "$custom_icon" ] && toggle_icon "$custom_icon"
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
        echo "  4) Exit Sub-Menu"
        echo "=========================================="
        printf "Select an option [1-4]: "
        read choice

        case "$choice" in
            1) 
                echo ""; echo "--- Installed System Overlays ---"
                cmd overlay list 2>/dev/null | grep -E "^\[|^[a-zA-Z0-9._]+$" | head -n 30
                echo "---------------------------------"; echo ""
                ;;
            2) 
                printf "Enter overlay package name to ENABLE: "
                read pkg_name
                [ -n "$pkg_name" ] && cmd overlay enable "$pkg_name" 2>/dev/null
                ;;
            3) 
                printf "Enter overlay package name to DISABLE: "
                read pkg_name
                [ -n "$pkg_name" ] && cmd overlay disable "$pkg_name" 2>/dev/null
                ;;
            4) break ;;
            *) echo ""; echo "[-] Invalid option." ;;
        esac
        printf "Press Enter to continue..."
        read dummy
    done
}

# Module Entry Point
while true; do
    clear
    echo "=========================================="
    echo "       hazY-mods | SystemUI Control"
    echo "=========================================="
    echo "  1) Status Bar Icon Cleaner"
    echo "  2) Animation Scale Adjuster"
    echo "  3) System Overlay Manager"
    echo "  4) Exit Script"
    echo "=========================================="
    printf "Select an option [1-4]: "
    read choice

    case "$choice" in
        1) status_bar_menu ;;
        2) animation_scale_menu ;;
        3) overlay_menu ;;
        4) exit 0 ;;
        *) echo ""; echo "[-] Invalid option." ; sleep 1 ;;
    esac
done
