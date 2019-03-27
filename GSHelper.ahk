; Auto Hot Key https://autohotkey.com 
; 단축키 설명은 https://autohotkey.com/docs/Hotkeys.htm

CommaJoin(str)
{
    str := RegExReplace(str, "(\s)+", "`n") ; 공백문자 치환
    str := RegExReplace(str, "^`n|`n$", "") ; 맨 처음과 끝 빈 줄 제거
    return "('" . StrReplace(str, "`n", "', '") . "')" ; ('', '') 형식으로 변경
}

^+v::
    TempClip = %Clipboard%
    Clipboard := CommaJoin(Clipboard)
    Send ^v
    Sleep 50 ; 클립보드 꼬임 방지
    Clipboard = %TempClip%
return