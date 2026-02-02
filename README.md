# X15 Compensator
### *Hardware-Level Debounce for the EVGA X15 MMO Mouse*

The **X15 Compensator** is a lightweight, system-tray utility written in **AutoHotkey v2.0**. It is designed specifically to solve the "reverse-scroll" jitter common in the [EVGA X15 MMO Mouse](http://googleusercontent.com/shopping_content/0_link). By implementing a time-based directional lock, the software filters out mechanical "bounces" from the encoder before they reach Windows.

(**Note:** _While this tool was specifically to revive the scroll wheel on my EVGA X15, this tool is still a genral AutoHotKey 2.0 script that works on any mouse with dirty hardware sensors on the scroll wheel_)

### **Key Features**
* **Intelligent Debounce:** High-speed filtering (default **`25ms`**) that ignores physical indexing errors without lagging your intentional scrolling.
* **User-Friendly GUI:** A dedicated configuration window to adjust sensitivity and system settings without touching code.
* **Persistence:** Saves your custom threshold and preferences to a local `settings.ini` file.
* **System Tray Integration:** * **Single-click toggle** to enable/disable the fix instantly.
    * **Double-click** to open the Configuration GUI.
* **Startup Management:** Options to run on Windows startup (Current User or All Users) and start minimized to the tray.

### **Installation**
1. Ensure you have [AutoHotkey v2.0+](https://www.autohotkey.com/) installed.
2. Download the `.ahk` script from this repository.
3. Double-click the script to run. Use the GUI to set your preferred threshold.

### **The "Why"**
The [EVGA X15](http://googleusercontent.com/shopping_content/1_link) is a powerhouse MMO mouse, but many units suffer from an encoder "skip" where scrolling down occasionally fires an "up" signal. This tool bridges the gap between hardware failure and a smooth user experience, extending the life of your peripheral, _without_ having to physically disassemble and clean the scroll wheel sensors. This is a happy medium for users who are not confident in their ability to disassemble a complex mouse like this one just to clean it.  

---
*Published: 2026-02-02 | Author: [Jason M Potter]*
