@echo off
chcp 65001 >nul

REM Kiểm tra xem thư mục AutoHotkey có tồn tại không
IF NOT EXIST "C:\Program Files\AutoHotkey" (
    echo AutoHotkey không được cài đặt. Bây giờ sẽ cài đặt từ file setup có sẵn...

    start AutoHotkeySetup.exe
	
    timeout /t 5
	
	start Launcher.ahk
	
    exit
)

start Launcher.ahk
exit