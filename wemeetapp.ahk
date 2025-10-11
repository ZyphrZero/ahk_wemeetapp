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

    ; 查找并隐藏所有浮动窗口
    if WinExist("ahk_exe WeMeetApp.exe") {
        ids := WinGetList("ahk_exe WeMeetApp.exe")
        hideCount := 0

        for this_id in ids {
            try {
                WinGetPos(&x, &y, &w, &h, "ahk_id " this_id)

                ; 浮动窗口通常较小且置顶
                if (w < 300 || h < 150) {
                    ExStyle := WinGetExStyle("ahk_id " this_id)
                    if (ExStyle & 0x8) {  ; WS_EX_TOPMOST
                        style := WinGetStyle("ahk_id " this_id)
                        if (style & 0x10000000) {  ; WS_VISIBLE
                            WinHide("ahk_id " this_id)
                            FloatWindowIDs.Push(this_id)
                            hideCount++
                        }
                    }
                }
            }
        }

        if (hideCount > 0) {
            ToolTip("已隐藏所有WeMeetApp置顶浮窗")
        }
        else {
            ToolTip("未找到WeMeetApp置顶浮窗，请检查WeMeetApp是否开启！")
        }
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
