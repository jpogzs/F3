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


Gui, Font, s10, Consolas
Gui, Add, Edit, ReadOnly -E0x200, %name%
Gui, Add, Edit, ReadOnly -E0x200 section, Roof     : %roof%
Gui, Add, Edit, ReadOnly -E0x200, Pens     : %pens%
Gui, Add, Edit, ReadOnly -E0x200, 3D-Pen   : %iapens%
If (iapens>=1)
	wall := 0
Gui, Add, Edit, ReadOnly -E0x200, Walls    : %wall%
Gui, Add, Edit, ReadOnly -E0x200, FootPrint: %footprint%
Gui, Add, Edit, ReadOnly -E0x200, Soffits  : %soffits%
Gui, Add, Edit, ReadOnly -E0x200, Stamps   : %stamps%
Gui, Add, Edit, ReadOnly -E0x200, SOM      : %som%
total := roof+pens+iapens+wall+footprint+soffits+stamps+som
Gui, Add, Text,, ---------------
Gui, Add, Edit, ReadOnly -E0x200, Total    : %total%
fhistory1 := StrReplace(history, "'", "")
fhistory2 := StrReplace(fhistory1, "[", "")
fhistory3 := StrReplace(fhistory2, "]", "`n")
Gui, Add, Edit, ys r18 w380 ReadOnly, %fhistory3%
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
		Goto start
	} 
Return

;#IfWinActive
