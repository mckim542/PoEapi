;
; poeapikit.ahk, 9/16/2020 7:41 PM
;

#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#IfWinActive, Path of Exile ahk_class POEWindowClass

SetWorkingDir %A_ScriptDir%

#Include, %A_ScriptDir%\lib\PoEapi.ahk
#Include, %A_ScriptDir%\Settings.ahk

global logger := new Logger("PoEapiKit log")
DllCall("poeapi\poeapi_get_version", "int*", major_version, "int*", minor_version, "int*", patch)
debug("PoEapiKit v0.2 (powered by PoEapi v{}.{}.{})", major_version, minor_version, patch)

global ptask := new PoETask()
ptask.activate()

Hotkey, IfWinActive, ahk_class POEWindowClass
Hotkey, ~%AttackSkillKey%, Attack
Hotkey, %QuickDefenseKey%, QuickDefense
Hotkey, IfWinActive

; end of auto-execute section
return

dumpObj(obj, name = "", prefix = "") {
    if (Not IsObject(obj)) {
        debug("Not a object")
        return
    }

    if (name)
        debug(prefix "@" name)

    for k, v in obj {
        debug("{}   {}{}, {}", prefix, IsObject(v) ? "*" : " ", k, IsObject(v) ? v.Count() : v)
        if (IsObject(v))
            dumpObj(v,, prefix "    ")
    }
}

Attack:
    ptask.onAttack()
return

QuickDefense:
    SendInput, %QuickDefenseAction%
return

`::
    ptask.logout()
return

F1::
    SendInput, %AruasKey%
return

F5::
    ptask.sendKeys("/Hideout")
return

AutoClick:
    MouseGetPos, x0, y0
    Loop {
        if (Not GetKeyState("Ctrl", "P"))
            break

        MouseGetPos, x, y
        if (abs(x - x0) > 100 || abs(y - y0) > 100)
            break

        x0 := x
        y0 := y
        SendInput ^{Click}
        Sleep, 30
    }
return

~^LButton::
    If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 200)
        SetTimer, AutoClick, -200
return

#d::
    WinMinimize, A
return

^m::
    ptask.toggleMaphack()
return

#IfWinActive

^r::
    Reload
return

^q::
    ExitApp
return

F10::
return
