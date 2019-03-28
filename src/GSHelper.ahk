#SingleInstance force

; 단축키 등록
Try {
    DefaultCommaPasteKey = CtrlShiftV
    IniRead, CommaPasteKeyVar, config.ini, Default, CommaPasteKey

    if(CommaPasteKeyVar = "ERROR") {
        CommaPasteKeyVar := DefaultCommaPasteKey
        IniWrite, %CommaPasteKeyVar%, config.ini, Default, CommaPasteKey
    } 

    CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Ctrl", "^")
    CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Alt", "!")
    CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Shift", "+")
    CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Win", "#")

    Hotkey, %CommaPasteKeyVar%, CommaPaste
} catch e {
    MsgBox, [config.ini]`n`n존재하지 않는 키입니다.`n단축키는 기본 값 (Ctrl + Shift + V) 으로 설정됩니다.
    Hotkey, ^+v, CommaPaste
}

; 콤마로 연결한 문자로 치환
CommaJoin(str)
{
    str := RegExReplace(str, "(\s)+", "`n") ; 공백문자 치환
    str := RegExReplace(str, "^`n|`n$", "") ; 맨 처음과 끝 빈 줄 제거
    return "('" . StrReplace(str, "`n", "', '") . "')" ; ('', '') 형식으로 변경
}

; 콤바로 연결한 문자 붙여넣기
CommaPaste() {
    TempClip = %Clipboard%
    Clipboard := CommaJoin(Clipboard)
    Send ^v
    Sleep 50 ; 클립보드 꼬임 방지
    Clipboard = %TempClip%
    return
}