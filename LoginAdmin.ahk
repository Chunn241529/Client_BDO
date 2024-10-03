#Include .\WebView2\WebView2.ahk

main := Gui() ; Tạo đối tượng Gui
main.OnEvent('Close', (*) => (wvc := wv := 0))
main.Title := "Black Desert - Server Trung đẹp trai" ; Thay đổi tiêu đề cửa sổ
main.Show(Format('w{} h{}', 1600, 900)) ; Thay đổi kích thước thành 1600 x 900

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2
wv.Navigate('http://26.129.122.29/login')
wv.AddHostObjectToScript('exe', {str:'Black Desert', func: MsgBox})
