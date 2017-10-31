#Include "windows.bi"

Dim As MSG msg     ' Message variable (stores massages)
Dim As HWND hWnd, stc1  ' Window variable and object variables

' Create window
hWnd = CreateWindowEx( 0, "#32770", "Hello", WS_OVERLAPPEDWINDOW Or WS_VISIBLE, 100, 100, 500, 300, 0, 0, 0, 0 )
' Create static box
stc1 = CreateWindowEx( 0, "STATIC", "Hello, World!", WS_VISIBLE Or WS_CHILD, 0, 0, 300, 30, hWnd, 0, 0, 0 )

While GetMessage( @msg, 0, 0, 0 )    ' Get message from window
  TranslateMessage( @msg )
  DispatchMessage( @msg )

  Select Case msg.hwnd
    Case hWnd        ' If msg is window hwnd: get messages from window
      Select Case msg.message
        Case 273
        End
    End Select
  End Select
Wend