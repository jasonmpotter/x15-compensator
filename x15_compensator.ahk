#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; PROGRAM INFO
; ==============================================================================
app_name := "X15 Scroll Compensator"
app_version := "2.0.1"
app_pub_date := "2026-02-02"
app_author := "Gemini & Community"
app_email := "support@example.com"
app_github := "https://github.com/user/x15-scroll-fix"

; ==============================================================================
; SETTINGS & INITIALIZATION
; ==============================================================================
ini_file := A_ScriptDir "\settings.ini"

; Load settings with your 25ms default
threshold := IniRead(ini_file, "Settings", "Threshold", 25)
start_minimized := IniRead(ini_file, "Settings", "StartMinimized", 0)
is_enabled := IniRead(ini_file, "Settings", "Enabled", 1)
run_for_all := IniRead(ini_file, "Settings", "RunForAll", 0)

lastDirection := ""
lastTime := 0

; Setup Tray Menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Open Config", (*) => ShowGui())
A_TrayMenu.Add("Enabled", ToggleEnabled)
if (is_enabled)
    A_TrayMenu.Check("Enabled")
A_TrayMenu.Add() 
A_TrayMenu.AddStandard()
A_TrayMenu.Default := "Open Config"
A_TrayMenu.ClickCount := 2 

; Left-click on tray icon to toggle
OnMessage(0x404, TrayClick)

if (!start_minimized)
    ShowGui()

; ==============================================================================
; CORE ENGINE
; ==============================================================================
#HotIf is_enabled
$WheelUp:: {
    global lastDirection, lastTime
    if (lastDirection == "Down" && (A_TickCount - lastTime < threshold))
        return
    lastDirection := "Up", lastTime := A_TickCount
    Send("{WheelUp}")
}

$WheelDown:: {
    global lastDirection, lastTime
    if (lastDirection == "Up" && (A_TickCount - lastTime < threshold))
        return
    lastDirection := "Down", lastTime := A_TickCount
    Send("{WheelDown}")
}
#HotIf

; ==============================================================================
; GUI INTERFACE
; ==============================================================================
ShowGui() {
    global threshold, start_minimized, is_enabled, run_for_all
    myGui := Gui("+AlwaysOnTop", app_name " - Configuration")
    
    ; Section: Compensator Settings
    myGui.Add("GroupBox", "w280 h100", "Compensator Settings")
    myGui.Add("Text", "xp+10 yp+25", "Sensitivity Threshold (ms):")
    edit_thresh := myGui.Add("Edit", "w60", threshold)
    
    ; v2.0 way to do "Small" text
    myGui.SetFont("s8") 
    myGui.Add("Text", "xp+70 yp+5 w130", "(Lower = Faster scrollers)")
    myGui.SetFont("s10") ; Reset to normal
    
    chk_enabled := myGui.Add("Checkbox", "xp-70 yp+30" (is_enabled ? " Checked" : ""), "Enable Compensator Active")

    ; Section: System Settings
    myGui.Add("GroupBox", "xm w280 h120", "System Settings")
    chk_startup := myGui.Add("Checkbox", "xp+10 yp+25", "Run on System Startup")
    radio_user := myGui.Add("Radio", "xp+20 yp+20" (!run_for_all ? " Checked" : ""), "This user only")
    radio_all := myGui.Add("Radio", "xp yp+20" (run_for_all ? " Checked" : ""), "Anyone using this computer")
    chk_min := myGui.Add("Checkbox", "xp-20 yp+25" (start_minimized ? " Checked" : ""), "Start window minimized to tray")

    ; Section: Info
    myGui.Add("GroupBox", "xm w280 h90", "Program Info")
    myGui.SetFont("s8")
    myGui.Add("Text", "xp+10 yp+20", app_name " v" app_version " | " app_pub_date)
    myGui.Add("Link", "yp+15", 'GitHub: <a href="' app_github '">Project Link</a>')
    myGui.Add("Text", "yp+15", "Author: " app_author)
    myGui.Add("Text", "yp+15", "Contact: " app_email)
    myGui.SetFont() ; Reset

    btn_save := myGui.Add("Button", "Default w80 x210 y375", "Save")
    btn_save.OnEvent("Click", (*) => SaveAndClose(myGui, edit_thresh, chk_enabled, chk_min, radio_all, chk_startup))

    myGui.Show("w300")
}

; ==============================================================================
; LOGIC HELPERS
; ==============================================================================
SaveAndClose(guiObj, editObj, enabledObj, minObj, radioAllObj, startupObj) {
    global threshold := editObj.Value
    global is_enabled := enabledObj.Value
    global start_minimized := minObj.Value
    global run_for_all := radioAllObj.Value
    
    IniWrite(threshold, ini_file, "Settings", "Threshold")
    IniWrite(is_enabled, ini_file, "Settings", "Enabled")
    IniWrite(start_minimized, ini_file, "Settings", "StartMinimized")
    IniWrite(run_for_all, ini_file, "Settings", "RunForAll")
    
    HandleStartup(startupObj.Value, run_for_all)
    UpdateTrayMenu()
    guiObj.Destroy()
}

ToggleEnabled(*) {
    global is_enabled := !is_enabled
    IniWrite(is_enabled, ini_file, "Settings", "Enabled")
    UpdateTrayMenu()
}

UpdateTrayMenu() {
    if (is_enabled)
        A_TrayMenu.Check("Enabled")
    else
        A_TrayMenu.Uncheck("Enabled")
}

TrayClick(wParam, lParam, msg, hwnd) {
    if (lParam == 0x201) ; Left Click
        ToggleEnabled()
}

HandleStartup(enable, all_users) {
    reg_key := all_users 
        ? "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" 
        : "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
    try {
        if (enable)
            RegWrite('"' A_ScriptFullPath '"', "REG_SZ", reg_key, app_name)
        else
            RegDelete(reg_key, app_name)
    } catch {
        MsgBox "Admin rights required for 'All Users' startup setting.", "Permissions Error", 48
    }
}
