#Persistent
#SingleInstance force

JoinStyle = Quote

Menu, Tray, Add
Menu, Tray, Add, 콤마 따옴표, ToggleStyle
Menu, Tray, Add, 콤마, ToggleStyle
Menu, Tray, Default, 콤마 따옴표
Menu, Tray, Check, 콤마 따옴표
RegisterKey()
return

ToggleStyle:
JoinStyle := (JoinStyle = "Quote")? "Comma" : "Quote"
Menu, Tray, ToggleCheck, 콤마 따옴표
Menu, Tray, ToggleCheck, 콤마
return

; 단축키 등록
RegisterKey() {
    Try {
        DefaultCommaPasteKey = Ctrl Shift V
        IniRead, CommaPasteKeyVar, config.ini, Default, CommaPasteKey

        if(CommaPasteKeyVar = "ERROR") {
            CommaPasteKeyVar := DefaultCommaPasteKey
            IniWrite, %CommaPasteKeyVar%, config.ini, Default, CommaPasteKey
        }

        MsgBox 단축키 (%CommaPasteKeyVar%)가 등록되었습니다.`n종료 하시려면 우측 하단의 초록색 (H) 트레이 아이콘을 클릭하세요.
        
        CommaPasteKeyVar := RegExReplace(CommaPasteKeyVar, "\s", "")
        CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Ctrl", "^")
        CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Alt", "!")
        CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Shift", "+")
        CommaPasteKeyVar := StrReplace(CommaPasteKeyVar, "Win", "#")

        Hotkey, $%CommaPasteKeyVar%, Paste
    } catch e {
        MsgBox, [config.ini]`n`n존재하지 않는 키입니다.`n단축키는 기본 값 (Ctrl + Shift + V) 으로 설정됩니다.
        Hotkey, $^+v, Paste
    }
}

; 문자열 치환 ('123', '456')
QuoteJoin(str)
{
    str := RegExReplace(str, "(\s)+", "`n") ; 공백문자 치환
    str := RegExReplace(str, "^`n|`n$", "") ; 맨 처음과 끝 빈 줄 제거
    return "('" . StrReplace(str, "`n", "', '") . "')"    
}

; 문자열 치환 123, 456
CommaJoin(str)
{
    str := RegExReplace(str, "(\s)+", "`n") ; 공백문자 치환
    str := RegExReplace(str, "^`n|`n$", "") ; 맨 처음과 끝 빈 줄 제거
    return StrReplace(str, "`n", ", ") 
}

; 문자열 처리 후 붙여넣기
Paste() {
    global JoinStyle

    TempClip = %Clipboard%
    Clipboard := (JoinStyle = "Quote")? QuoteJoin(Clipboard) : CommaJoin(Clipboard)
    SendInput ^v
    Sleep 100 ; 클립보드 꼬임 방지
    Clipboard = %TempClip%
    return
}