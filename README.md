# 🔓 A & D WiFi Hack Tool

A simple and effective Bash-based WiFi hacking automation tool built using the Aircrack-ng suite.  
This tool is created by the **Attack & Defend Group** for educational and ethical hacking purposes.

---

## 📖 What is this tool?

**A & D WiFi Hack Tool** automates the process of WiFi penetration testing.  
Instead of typing long commands manually, this tool provides a step-by-step interactive flow to:
- Enable monitor mode on your wireless interface.
- Scan for nearby WiFi networks.
- Capture the WPA handshake from a specific network.
- Launch a deauthentication attack to trigger the handshake.
- Perform a dictionary attack to try cracking the WiFi password.

---

## ⚙️ How it Works

Here’s how the tool operates:

1. **Enable Monitor Mode**  
   Starts your wireless card in monitor mode to allow sniffing WiFi traffic.

2. **Scan WiFi Networks**  
   Uses `airodump-ng` to display nearby WiFi networks.

3. **Capture Target Info**  
   You enter the BSSID and channel of the network you want to target.

4. **Start Capturing Handshake**  
   Begins listening and saving the handshake packets from the target.

5. **Deauthentication Attack**  
   Sends fake disconnect packets to speed up handshake capture.

6. **Dictionary Attack**  
   After handshake is captured, it runs `aircrack-ng` with your wordlist to crack the password.

7. **Cleanup**  
   Monitor mode is turned off, and the tool exits cleanly.

---

## 🧰 Requirements

- Linux OS
- `aircrack-ng` suite
- `xterm` installed for launching background attack windows
- Root access

Install required tools (if not already):

```bash
sudo apt update
sudo apt install aircrack-ng xterm

