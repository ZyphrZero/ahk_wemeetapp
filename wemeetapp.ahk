; 隐藏WeMeetApp浮动窗口脚本 (AutoHotkey v2)
; 按 Ctrl+Alt+[ 切换隐藏/显示所有WeMeetApp置顶浮窗
; 按 Ctrl+Alt+] 退出程序并显示所有已隐藏的WeMeetApp浮窗

FloatWindowIDs := []

^![:: {
    global FloatWindowIDs
    SetTitleMatchMode(2)

    ; 先尝试显示之前隐藏的窗口
    if (FloatWindowIDs.Length > 0) {
        for win_id in FloatWindowIDs {
            try {
                WinShow("ahk_id " win_id)
            }
        }
        FloatWindowIDs := []
        ToolTip("已显示所有WeMeetApp置顶浮窗")
        SetTimer(() => ToolTip(), -2000)
        return
    }

    ; 查找并隐藏指定类名的浮动窗口
    targetWinID := WinGetID("ahk_class Qt680QWindowToolSaveBits ahk_exe wemeetapp.exe")

    if (targetWinID) {
        try {
            WinHide("ahk_id " targetWinID)
            FloatWindowIDs.Push(targetWinID)
            ToolTip("已隐藏WeMeetApp置顶浮窗")
        }
        catch {
            ToolTip("隐藏窗口失败！")
        }
        SetTimer(() => ToolTip(), -2000)
    }
    else {
        ToolTip("未找到指定窗口类，请检查腾讯会议是否开启！")
        SetTimer(() => ToolTip(), -2000)
    }
}

; 按 Ctrl+Alt+] 退出脚本
^!]:: {
    global FloatWindowIDs
    for win_id in FloatWindowIDs {
        try {
            WinShow("ahk_id " win_id)
        }
    }
    ExitApp()
}
