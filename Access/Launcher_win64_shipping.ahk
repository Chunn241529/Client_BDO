Gui, +Border +Resize
Gui, Color, 0x2E2E2E ; Đặt màu nền

; Kích thước của GUI
Gui, Show, w1500 h767, Black Desert ; Giảm kích thước

; Đường dẫn tới hình nền
gifPath := A_ScriptDir . ".\image\f57ca3f9_3f8b_4c58_8bec_bd86a15c694a_by_douglass707_di67ir8-pre.jpg" ; Đường dẫn tới file hình ảnh

; Thêm tiêu đề và slogan sau khi thêm hình nền
Gui, Font, s50 Bold, Arial
Gui, Add, Text, x925 y120 w500 Center BackgroundTrans cWhite, Black Desert ; Nhích xuống 20 pixel

Gui, Font, s20, Arial
Gui, Add, Text, x925 y200 w500 Center BackgroundTrans cWhite, "Thiếu thì báo tôi add thêm :))" ; Nhích xuống 20 pixel

; Thêm hình nền full GUI
Gui, Add, Picture, x0 y0 w1500 h800, %gifPath% ; Đảm bảo kích thước hình nền khớp với kích thước GUI

; Thêm trường nhập Username (không có placeholder)
Gui, Font, s12, Arial
Gui, Add, Edit, vUsername x1000 y280 w350 h35 -VScroll cBlack, ; Trường nhập tài khoản (nhích xuống 20 pixel)

; Thêm khoảng cách giữa Username và Password
Gui, Add, Edit, vPassword Password x1000 y360 w350 h35 -VScroll cBlack, ; Trường nhập mật khẩu (sử dụng tham số Password, nhích xuống 20 pixel)

; Thêm checkbox Nhớ tài khoản với màu nền trong suốt
Gui, Add, Checkbox, vRememberUsername x1000 y440 w200 h40 cWhite BackgroundTrans, Nhớ mật khẩu? ; Nhích xuống 20 pixel

; Thêm nút Login
Gui, Add, Button, x1000 y520 w350 h50 gLogin BackgroundTrans, Đăng nhập ; Nhích xuống 20 pixel

; Thêm nút Update game
Gui, Add, Button, x100 y640 w150 h50 gUpdateGame BackgroundTrans, Cập nhật game ; Nhích xuống 20 pixel

; Thêm nút Website
Gui, Add, Button, x300 y640 w150 h50 gWebsite BackgroundTrans, Trang web ; Nhích xuống 20 pixel

; Thêm nút Danh sách item
Gui, Add, Button, x500 y640 w250 h50 gListItem BackgroundTrans, Danh sách item ; Nhích xuống 20 pixel

; Thêm Edit Control để hiển thị danh sách item
Gui, Add, Edit, vItemList x100 y120 w850 h500 +VScroll ReadOnly BackgroundTrans cWhite ; Thêm điều khiển Edit (nhích xuống 20 pixel)

; Thêm Progress Bar
Gui, Add, Progress, vProgressBar x0 y760 w1500 h20 Range0-100 ; Thêm thanh tiến trình

; Đọc dữ liệu từ file GM.txt và thêm vào Edit
FileRead, listData, .\other\GM.txt
if (ErrorLevel) {
    MsgBox, Lỗi khi đọc file GM.txt
} else if (listData != "") {
    ; Hiển thị dữ liệu trong Edit Control
    GuiControl,, ItemList, %listData% ; Thêm dữ liệu vào điều khiển Edit
}

; Đọc thông tin đăng nhập từ file
FileRead, loginData, ./log/Remember_Login.txt
if (ErrorLevel) {
    ; Nếu file không tồn tại, không làm gì cả
} else if (loginData != "") {
    ; Tách username và password
    StringSplit, loginInfo, loginData, `n
    GuiControl,, Username, %loginInfo1%
    GuiControl,, Password, %loginInfo2%
    GuiControl,, RememberUsername, 1 ; Đánh dấu checkbox nếu có thông tin
}

; Hiển thị giao diện
Gui, Show
Return

; Điều hướng đến trang đăng ký khi nhấn vào label hyperlink
Register:
    Run, http://26.129.122.29/register ; Điều hướng đến trang đăng ký
Return

Website:
    Run, .\Loginadmin.ahk
Return

ListItem:
    Run, .\BDOCODEX.ahk
Return

Login:
    Gui, Submit, NoHide ; Lấy giá trị từ giao diện

    ; Đường dẫn tới file .bat có sẵn
    filePath := ".\Login.bat"

    ; Xóa file .bat cũ nếu có
    FileDelete, %filePath%

    ; Ghi nội dung mới vào file .bat với giá trị từ Username và Password
    FileAppend, @echo off`n, %filePath%
    FileAppend, REM <EDIT YOUR LOGIN INFORMATION HERE>`n, %filePath%
    FileAppend, SET account=%Username%`n, %filePath%
    FileAppend, SET password=%Password%`n, %filePath%
    FileAppend, REM <EDIT YOUR LOGIN INFORMATION HERE>`n, %filePath%
    FileAppend, cd ..\bin64`n, %filePath%

    ; Đảm bảo rằng dòng lệnh start được ghi đúng
    startCommand := "start BlackDesert64.exe " . Username . "," . Password
    FileAppend, %startCommand%`n, %filePath% ; Ghi dòng start vào file

    ; Lưu tài khoản và mật khẩu vào file nếu checkbox được chọn
    if (RememberUsername) {
        FileDelete, .\Log\Remember_Login.txt ; Xóa file login.txt cũ nếu có
        FileAppend, %Username%`n%Password%, .\Log\Remember_Login.txt ; Lưu tài khoản và mật khẩu vào file
    } else {
        FileDelete, .\Log\Remember_Login.txt ; Xóa file login.txt nếu không được chọn
    }

    ; Chạy file .bat
    Run, %filePath%

Return

UpdateGame:
    ; Thiết lập Progress Bar
    GuiControl, , ProgressBar, 0 ; Đặt giá trị tiến trình về 0
    Gui, Show

    ; Đường dẫn tới thư mục nơi git clone hoặc git pull sẽ diễn ra
    FilePathCurrent := "..\Client_BDO\" ; Đường dẫn tới thư mục nguồn
    targetPath := "..\" ; Đường dẫn tới nơi lưu (nơi bạn muốn sao chép tệp)

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 10 ; Cập nhật tiến trình (10%)
    Sleep, 500

    ; Nếu thư mục không tồn tại, thực hiện git clone
    if !FileExist(FilePathCurrent) {
        RunWait, %ComSpec% /C "git clone https://github.com/Chunn241529/Client_BDO.git %FilePathCurrent%", , Hide
        GuiControl, , ProgressBar, 60 ; Cập nhật tiến trình (60%)
        Sleep, 8000
    }

    ; Kiểm tra nếu thư mục nguồn tồn tại
    if (FileExist(FilePathCurrent)) {
        ; Sao chép tất cả các tệp và thư mục con từ FilePathCurrent ra ngoài targetPath
        Loop, Files, %FilePathCurrent%\*.*, R ; Duyệt qua tất cả tệp và thư mục con
        {
            ; Tạo lại đường dẫn thư mục nếu cần thiết
            IfInString, A_LoopFileAttrib, D ; Kiểm tra nếu là thư mục
            {
                FileCreateDir, %targetPath%%A_LoopFileFullPath%\ ; Tạo thư mục mới
            }
            else
            {
                ; Sao chép từng tệp
                FileMove, %A_LoopFileFullPath%, %targetPath%%A_LoopFileFullPath%
            }
        }

        ; Xóa thư mục nguồn sau khi sao chép xong
        FileRemoveDir, %FilePathCurrent%, 1 ; Tham số "1" để xóa cả nội dung bên trong
    } else {
        MsgBox, Cập nhật thất bại.
        Return
    }

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 100 ; Cập nhật tiến trình (100%)
    Sleep, 500

    ; Tạo shortcut tại thư mục ngoài (targetPath) với tên và icon từ file target
    shortcutTarget := ".\Launcher_win64_shipping.exe" ; Đường dẫn đến tệp .exe
    shortcutPath := targetPath . "Black Desert.exe" ; Đường dẫn của shortcut

    ; Tạo file shortcut và đặt icon giống với file .exe
    FileCreateShortcut, %shortcutTarget%, %shortcutPath%, , , , , %shortcutTarget%, 0

    ; Ẩn GUI sau khi hoàn thành
    Gui, Hide
    MsgBox, Cập nhật game hoàn tất!

    ; Chạy game sau khi cập nhật
    Run, %shortcutTarget%

Return

; Xử lý khi đóng GUI
GuiClose:
ExitApp
Return
