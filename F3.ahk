#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force  
start:
inifile = fileinfo.ini

#IfWinActive ahk_class CabinetWClass ; If Windows Explorer window is active

F3::
Clipboard := ""
Gui, Destroy
SendInput, ^c
Sleep 150
Clipboard := Clipboard
SplitPath, Clipboard, name,, ext
If (ext!="evm")
	{
		MsgBox, 16, Notice, Selected file is not EVM, 3
		Goto start
	}
Run FileInfo.exe
Process, WaitClose, FileInfo.exe , 30
Gosub CheckIni
Gosub LoadFileInfo
Return


LoadFileInfo:
		param=file,roof,pens,iapens,wall,footprint,soffits,stamps,som,history
		loop, parse, param, `,
		IniRead, %A_LoopField% , %inifile%, FileInfo, % A_LoopField

;if (Clipboard!=file)
;    Goto LoadFileInfo


Gui, Font, s10, Courier
Gui, Add, Text,, %name%
Gui, Add, Text,section, Roof     : %roof%
Gui, Add, Text,, Pens     : %pens%
Gui, Add, Text,, 3D-Pens  : %iapens%
If (iapens>0)
	wall := 0
Gui, Add, Text,, Walls    : %wall%
Gui, Add, Text,, FootPrint: %footprint%
Gui, Add, Text,, Soffits  : %soffits%
Gui, Add, Text,, Stamps   : %stamps%
Gui, Add, Text,, SOM      : %som%
total := roof+pens+iapens+wall+footprint+soffits+stamps+som
Gui, Add, Text,, ---------------
Gui, Add, Text,, Total    : %total%
fhistory1 := StrReplace(history, "'", "")
fhistory2 := StrReplace(fhistory1, "[", "")
fhistory3 := StrReplace(fhistory2, "]", "`n")
Gui, Add, Edit, ys r20 w380 readonly, %fhistory3%
Gui, +LastFound
Gui, Show,, F3
ControlSend, Edit1, {End}
;Clipboard := ""
FileDelete, fileinfo.ini
Return



CheckIni:
ifexist, %inifile%
	{
		Return
	}
Else
	{
		Goto CheckIni
	} 
Return

;#IfWinActive