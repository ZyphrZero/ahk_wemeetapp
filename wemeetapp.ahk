; 隐藏腾讯会议浮动窗口脚本
; 按 Ctrl+Alt+H 隐藏/显示所有腾讯会议浮动窗口

#Persistent

; 全局变量：存储所有浮动窗口的ID
global FloatWindowIDs := []

; 热键: Ctrl+Alt+H 切换隐藏/显示所有浮动窗口
^!h::
SetTitleMatchMode, 2

; 先尝试显示之前隐藏的窗口
if (FloatWindowIDs.Length() > 0) {
    hiddenCount := 0
    for index, win_id in FloatWindowIDs {
        ; 检查窗口是否仍然存在
        IfWinExist, ahk_id %win_id%
        {
            WinShow, ahk_id %win_id%
            hiddenCount++
        }
    }

    if (hiddenCount > 0) {
        ToolTip, 已显示 %hiddenCount% 个腾讯会议浮动窗口
        SetTimer, RemoveToolTip, 2000
        ; 清空列表
        FloatWindowIDs := []
        return
    }
    else {
        ; 如果没有显示成功，清空列表继续查找要隐藏的窗口
        FloatWindowIDs := []
    }
}

; 查找并隐藏所有浮动窗口
IfWinExist, ahk_exe WeMeetApp.exe
{
    WinGet, id, List, ahk_exe WeMeetApp.exe
    hideCount := 0

    loop, %id%{
        this_id := id%A_Index%
        WinGetPos, x, y, w, h, ahk_id %this_id%

        ; 浮动窗口通常较小且置顶
        if (w < 300 or h < 150) {
            WinGet, ExStyle, ExStyle, ahk_id %this_id%
            if (ExStyle & 0x8)  ; WS_EX_TOPMOST = 0x8
            {
                ; 检查窗口是否可见
                WinGet, style, Style, ahk_id %this_id%
                if (style & 0x10000000)  ; WS_VISIBLE
                {
                    WinHide, ahk_id %this_id%
                    FloatWindowIDs.Push(this_id)
                    hideCount++
                }
            }
        }
    }

    if (hideCount > 0) {
        ToolTip, 已隐藏 %hideCount% 个腾讯会议浮动窗口
        SetTimer, RemoveToolTip, 2000
    }
    else {
        ToolTip, 未找到可见的腾讯会议浮动窗口
        SetTimer, RemoveToolTip, 2000
    }
}
else {
    ToolTip, 腾讯会议未运行
    SetTimer, RemoveToolTip, 2000
}
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return

    ; 按 Ctrl+Alt+Q 退出脚本
    ^!q::
    ; 退出前显示所有隐藏的窗口
    for index, win_id in FloatWindowIDs {
        IfWinExist, ahk_id %win_id%
        {
            WinShow, ahk_id %win_id%
        }
    }
    ExitApp
    return
