#NoTrayIcon
Menu, Tray, Icon, main.cpl, 1
SetBatchLines, -1
OnMessage(0x404, "TrayClick")

RegRead, MinTrayChk, HKCU\SOFTWARE\AutoclickerAHK, MinTray
MinTrayChk += 0

Gui, Font, s11
Gui, Add, Text, x10 y12 w370 vLabelHours, Hours: 0
Gui, Add, Slider, x10 y32 w370 vSliderHours gUpdate Range0-24, 0
Gui, Add, Text, x10 y92 w370 vLabelMins, Minutes: 0
Gui, Add, Slider, x10 y112 w370 vSliderMins gUpdate Range0-60, 0
Gui, Add, Text, x10 y172 w370 vLabelSecs, Seconds: 0
Gui, Add, Slider, x10 y192 w370 vSliderSecs gUpdate Range0-60, 0
Gui, Add, Text, x10 y252 w370 vLabelMs, Milliseconds: 0
Gui, Add, Slider, x10 y272 w370 vSliderMs gUpdate Range0-1000, 0

Gui, Add, Button, x10 y320 w180 h38 vBtn gToggle, Start (F6)
Gui, Add, Button, x210 y320 w180 h20 gDeleteReg, Delete Registry Value
Gui, Add, CheckBox, x210 y339 w180 h20 vMinTrayChk gUpdateTrayReg Checked%MinTrayChk%, Minimize to tray

Gui, Show, w400 h380, AutoClicker
Interval := 1
return

UpdateTrayReg:
Gui, Submit, NoHide
RegWrite, REG_DWORD, HKCU\SOFTWARE\AutoclickerAHK, MinTray, %MinTrayChk%
return

DeleteReg:
RegDelete, HKCU\SOFTWARE\AutoclickerAHK
GuiControl,, MinTrayChk, 0
MinTrayChk := 0
return

GuiSize:
Gui, Submit, NoHide
if (A_EventInfo = 1 && MinTrayChk) {
    Menu, Tray, Icon
    Gui, Hide
}
return

Update:
Gui, Submit, NoHide
GuiControl,, LabelHours, Hours: %SliderHours%
GuiControl,, LabelMins, Minutes: %SliderMins%
GuiControl,, LabelSecs, Seconds: %SliderSecs%
GuiControl,, LabelMs, Milliseconds: %SliderMs%
Interval := Max(1, SliderHours*1440000 + SliderMins*60000 + SliderSecs*1000 + SliderMs)
If (T)
    SetTimer, Clicker, % Interval
return

F6::
Toggle:
SetTimer, Clicker, % (T := !T) ? Interval : "Off"
GuiControl,, Btn, % T ? "Stop (F6)" : "Start (F6)"
return

Clicker:
Click
return

GuiClose:
ExitApp

TrayClick(wParam, lParam) {
    if (lParam = 0x202 || lParam = 0x205) {
        Menu, Tray, NoIcon
        Gui, Show
    }
}