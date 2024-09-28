; Tiếp tục nếu AutoHotkey đã được cài đặt
Gui, +AlwaysOnTop +Border +Resize
Gui, Color, 0x000000 ; Đặt màu nền là màu đen (để giống với giao diện game)

; Kích thước của GUI
Gui, Show, w800 h400, SERVER BDO CHUN

; Thêm một hình nền
Gui, Add, Picture, x0 y0 w400 h400 vBackground, ./Img/IMG_1787.JPG ; Thay thế bằng đường dẫn tới hình nền của bạn

; Thêm tiêu đề
Gui, Font, s20 Bold, Verdana
Gui, Add, Text, x420 y40 w300 Center cWhite, Đăng nhập BDO

; Thêm trường nhập Username
Gui, Font, s12, Verdana
Gui, Add, Text, x420 y100 w100 h30 cWhite, Username:
Gui, Add, Edit, vUsername x520 y100 w220 h30 -VScroll

; Thêm trường nhập Password
Gui, Add, Text, x420 y140 w100 h30 cWhite, Password:
Gui, Add, Edit, vPassword Password x520 y140 w220 h30 -VScroll

; Thêm nút Login
Gui, Font, s12, Verdana
Gui, Add, Button, x470 y200 w100 h40 gLogin BackgroundTrans, Login

; Thêm nút Register
Gui, Add, Button, x590 y200 w100 h40 gRegister BackgroundTrans, Register

; Hiển thị giao diện
Gui, Show
Return

Register:
    Run, http://26.144.115.149/register ; Điều hướng đến trang đăng ký
Return

Login:
    Gui, Submit, NoHide ; Lấy giá trị từ giao diện

    ; Đường dẫn tới file .bat có sẵn
    filePath := "launcher.bat"

    ; Đọc nội dung file .bat
    FileRead, fileContent, %filePath%

    ; Thay thế username và password
    StringReplace, fileContent, fileContent, SET account=abc, SET account=%Username%, All
    StringReplace, fileContent, fileContent, SET password=abc, SET password=%Password%, All

    ; Ghi lại nội dung mới vào file .bat
    FileDelete, %filePath% ; Xóa file .bat cũ
    FileAppend, %fileContent%, %filePath% ; Ghi nội dung mới vào file .bat

    ; Chạy file .bat
    Run, %filePath%

    ; Tắt AutoHotkey sau khi đăng nhập
    ExitApp
Return

GuiClose:
    ExitApp
