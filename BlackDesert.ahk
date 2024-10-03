Gui, +Border +Resize
Gui, Color, 0x2E2E2E ; Đặt màu nền

; Kích thước của GUI
Gui, Show, w1600 h900, Black Desert

; Đường dẫn tới hình nền
gifPath := A_ScriptDir . "\Img\1.png" ; Đường dẫn tới file hình ảnh

; Thêm tiêu đề và slogan sau khi thêm hình nền
Gui, Font, s50 Bold, Arial
Gui, Add, Text, x925 y220 w500 Center BackgroundTrans cWhite, Black Desert

Gui, Font, s20, Arial
Gui, Add, Text, x925 y300 w500 Center BackgroundTrans cWhite, "Thiếu thì báo tôi add thêm :))"

; Thêm hình nền full GUI
Gui, Add, Picture, x0 y0 w1600 h900, %gifPath%

; Thêm trường nhập Username (không có placeholder)
Gui, Font, s12, Arial
Gui, Add, Edit, vUsername x1000 y400 w350 h35 -VScroll cBlack, ; Trường nhập tài khoản

; Thêm khoảng cách giữa Username và Password
Gui, Add, Edit, vPassword Password x1000 y470 w350 h35 -VScroll cBlack, ; Trường nhập mật khẩu (sử dụng tham số Password)

; Thêm checkbox Nhớ tài khoản với màu nền trong suốt
Gui, Add, Checkbox, vRememberUsername x1000 y540 w200 h40 cWhite BackgroundTrans, Nhớ mật khẩu?

Gui, Add, Button, x1000 y620 w150 h50 gRegister BackgroundTrans, Đăng ký

; Thêm nút Login
Gui, Add, Button, x1200 y620 w150 h50 gLogin BackgroundTrans, Đăng nhập

; Thêm nút Update game
Gui, Add, Button, x1000 y680 w1050 h50 gUpdateGame BackgroundTrans, Cập nhật game

; Thêm Progress Bar để theo dõi tiến trình
Gui, Add, Progress, vProgressBar x1000 y740 w350 h20 cGreen BackgroundTrans, 0

; Đọc thông tin đăng nhập từ file
FileRead, loginData, ./Log/Remember_Login.txt
if (ErrorLevel)
{
    ; Nếu file không tồn tại, không làm gì cả
}
else if (loginData != "")
{
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

; Xử lý nhấn phím Enter
~Enter::
    GoSub, Login ; Gọi hàm đăng nhập
Return

Login:
    Gui, Submit, NoHide ; Lấy giá trị từ giao diện

    ; Đường dẫn tới file .bat có sẵn
    filePath := "Login.bat"

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
    if (RememberUsername)
    {
        FileDelete, ./Log/Remember_Login.txt ; Xóa file login.txt cũ nếu có
        FileAppend, %Username%`n%Password%, ./Log/Remember_Login.txt ; Lưu tài khoản và mật khẩu vào file
    }
    else
    {
        FileDelete, login.txt ; Xóa file login.txt nếu không được chọn
    }

    ; Chạy file .bat
    Run, %filePath%

; Tắt AutoHotkey sau khi đăng nhập
ExitApp
Return

UpdateGame:
    ; Thiết lập Progress Bar
    GuiControl, , ProgressBar, 0 ; Đặt giá trị tiến trình về 0
    Gui, Show

    ; Thực hiện git pull từ thư mục riêng
    gitPullPath := ".\Client_BDO\bdo_setting\" ; Đường dẫn tới thư mục git
    Run, %ComSpec% /C "cd /d %gitPullPath% && git pull", , Hide

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 50 ; Cập nhật tiến trình (ví dụ 50%)
    Sleep, 1000 ; Thời gian chờ để dễ thấy

    ; Sao chép tệp vào thư mục chính của game
    gamePath := ".\Client_BDO\" ; Đường dẫn tới thư mục game chính
    FileCopy, %gitPullPath%\*.*, %gamePath%, 1 ; 1 để ghi đè tệp

    ; Cập nhật Progress Bar
    GuiControl, , ProgressBar, 100 ; Cập nhật tiến trình đến 100%
    Sleep, 1000 ; Thời gian chờ để dễ thấy

    ; Reload lại UI
    Gui, Destroy ; Hủy GUI hiện tại
    GoSub, ShowGUI ; Gọi lại hàm tạo lại giao diện
Return

ShowGUI:
    Run, .\BlackDesert.exe
Return

GuiClose:
ExitApp
