#Include .\WebView2\WebView2.ahk

main := Gui() ; Tạo đối tượng Gui
main.OnEvent('Close', (*) => (wvc := wv := 0))
main.Title := "BDOCODEX" ; Thay đổi tiêu đề cửa sổ
main.Show(Format('w{} h{}', 1600, 900)) ; Thay đổi kích thước thành 1600 x 900

wvc := WebView2.CreateControllerAsync(main.Hwnd).await2()
wv := wvc.CoreWebView2

wv.Navigate('https://bdocodex.com/us/')
wv.AddHostObjectToScript('ahk', {str:'Black Desert codex', func: MsgBox})
