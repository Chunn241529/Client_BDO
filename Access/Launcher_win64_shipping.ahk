﻿Gui, +Border +Resize
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
    FileAppend, cd bin64`n, %filePath%

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
    clonePath := "..\bdo_setting\" ; Đường dẫn tới thư mục đích
    ; Đường dẫn tới tệp zip
    zipFilePath := "..\bdo_setting\Client_BDO.zip" ; Đường dẫn tới tệp zip
    targetPath := "..\Client_BDO.zip" ; Đường dẫn tới nơi lưu tệp zip

    ; Kiểm tra xem thư mục bdo_setting có tồn tại không
    if (FileExist(clonePath)) {
        ; Nếu thư mục tồn tại, thực hiện git pull
        Run, %ComSpec% /C "cd /d %clonePath% && git pull", , Hide
        Sleep, 2000 ; Chờ một chút để đảm bảo git pull hoàn tất
    } else {
        ; Nếu thư mục không tồn tại, thực hiện git clone
        Run, %ComSpec% /C "git clone https://github.com/Chunn241529/Client_BDO.git %clonePath%", , Hide
        Sleep, 8000 ; Chờ một chút để đảm bảo git clone hoàn tất
    }

    ; Kiểm tra xem tệp zip có tồn tại không
    if !FileExist(zipFilePath) {
        MsgBox, Tệp zip không tồn tại: %zipFilePath%
        Return
    }

    ; Sao chép tệp zip đến thư mục đích
    FileCopy, %zipFilePath%, %targetPath%, 1 ; 1 để ghi đè tệp nếu đã tồn tại

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 25 ; Cập nhật tiến trình (25%)
    Sleep, 1000 ; Thời gian chờ để dễ thấy

    ; Giải nén tệp zip vào thư mục Client_BDO
    Run, %ComSpec% /C "powershell -command ""Expand-Archive -Path '%targetPath%' -DestinationPath '..\' -Force""", , Hide

    ; Giải nén không trả về kết quả ngay lập tức, cần chờ cho đến khi hoàn tất
    Loop {
        Sleep, 500 ; Chờ nửa giây để kiểm tra
        ; Kiểm tra nếu thư mục đã có các tệp mới
        if (FileExist("..\*.*")) {
            break ; Nếu tệp tồn tại, thoát vòng lặp
        }
    }

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 100 ; Cập nhật tiến trình (100%)
    Sleep, 1000 ; Chờ thêm một chút trước khi đóng GUI
    Gui, Hide ; Ẩn GUI sau khi hoàn thành
    MsgBox, Cập nhật game hoàn tất! ; Hiển thị thông báo hoàn thành
    FileDelete, %targetPath%

    Run, Launcher_win64_shipping.exe
Return

; Xử lý khi đóng GUI
GuiClose:
ExitApp
Return
