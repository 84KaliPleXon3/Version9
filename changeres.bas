Attribute VB_Name = "Module6"
Option Explicit
Private Const CCDEVICENAME = 32
Private Const CCFORMNAME = 32
Private Const DM_BITSPERPEL = &H40000
Private Const DM_PELSWIDTH = &H80000
Private Const DM_PELSHEIGHT = &H100000
Private Const CDS_UPDATEREGISTRY = &H1
Private Const CDS_TEST = &H4
Private Const DISP_CHANGE_SUCCESSFUL = 0
Private Const DISP_CHANGE_RESTART = 1
Private Const BITSPIXEL = 12
Private Type DEVMODE
dmDeviceName As String * CCDEVICENAME
dmSpecVersion As Integer
dmDriverVersion As Integer
dmSize As Integer
dmDriverExtra As Integer
dmFields As Long
dmOrientation As Integer
dmPaperSize As Integer
dmPaperLength As Integer
dmPaperWidth As Integer
dmScale As Integer
dmCopies As Integer
dmDefaultSource As Integer
dmPrintQuality As Integer
dmColor As Integer
dmDuplex As Integer
dmYResolution As Integer
dmTTOption As Integer
dmCollate As Integer
dmFormName As String * CCFORMNAME
dmUnusedPadding As Integer
dmBitsPerPel As Integer
dmPelsWidth As Long
dmPelsHeight As Long
dmDisplayFlags As Long
dmDisplayFrequency As Long
End Type
Private Declare Function EnumDisplaySettings Lib "User32" Alias "EnumDisplaySettingsA" (ByVal lpszDeviceName As Long, ByVal iModeNum As Long, lpDevMode As Any) As Boolean
Private Declare Function ChangeDisplaySettings Lib "User32" Alias "ChangeDisplaySettingsA" (lpDevMode As Any, ByVal dwFlags As Long) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Declare Function CreateDC Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, ByVal lpDeviceName As String, ByVal lpOutput As String, ByVal lpInitData As Any) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private oldx As Long, oldy As Long
Private Const MAX_PATH As Long = 260
Private Const MAX_PATH_UNICODE As Long = 260 * 2 - 1

Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type

Private Type WIN32_FIND_DATA
dwFileAttributes As Long
ftCreationTime As FILETIME
ftLastAccessTime As FILETIME
ftLastWriteTime As FILETIME
nFileSizeHigh As Long
nFileSizeLow As Long
dwReserved0 As Long
dwReserved1 As Long
cFileName(MAX_PATH * 2 - 1) As Byte
cAlternate(14 * 2 - 1) As Byte
End Type
Private Declare Function FindFirstFile Lib "KERNEL32" Alias "FindFirstFileW" (ByVal lpFileName As Long, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindClose Lib "kernel32.dll" (ByVal hFindFile As Long) As Long

Private Declare Function GetWindowLong Lib "User32" Alias "GetWindowLongA" (ByVal hWND As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "User32" Alias "SetWindowLongA" (ByVal hWND As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function CallWindowProc Lib "User32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWND As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'
Private Const GWL_WNDPROC = (-4)
Private Const WM_MOUSEWHEEL = &H20A
Private Const WM_MOUSELAST = &H20A
Private Const WM_MOUSEHWHEEL = &H20E
Public defWndProc As Long, defWndProc2 As Long
Public LastGlist As gList, LastGlist2 As gList
Public defWndProc3 As Long
Public LastGlist3 As gList

Public HOOKTEST As Long

Public Sub Hook3(hWND As Long, a As gList)
' work in IDE but for development and a fear...of a crash...

If m_bInIDE Then Exit Sub

   If defWndProc3 = 0 Then

      defWndProc3 = SetWindowLong(hWND, _
                                 GWL_WNDPROC, _
                                 AddressOf WindowProc3)
                                 MyDoEvents
         If defWndProc3 = 0 Then Set LastGlist3 = Nothing
    End If
           Set LastGlist3 = a
End Sub
Public Sub UnHook3(hWND As Long)

If m_bInIDE Then Exit Sub
    If defWndProc3 > 0 Then
    
      Call SetWindowLong(hWND, GWL_WNDPROC, defWndProc3)
      defWndProc3 = 0
   End If
  
End Sub
Public Sub Hook2(hWND As Long, a As gList)
' work in IDE but for development and a fear...of a crash...

If m_bInIDE Then Exit Sub

   If defWndProc2 = 0 Then

      defWndProc2 = SetWindowLong(hWND, _
                                 GWL_WNDPROC, _
                                 AddressOf WindowProc2)
                                 MyDoEvents
         If defWndProc2 = 0 Then Set LastGlist2 = Nothing
    End If
           Set LastGlist2 = a
End Sub
Public Sub UnHook2(hWND As Long)

If m_bInIDE Then Exit Sub
    If defWndProc2 > 0 Then
    
      Call SetWindowLong(hWND, GWL_WNDPROC, defWndProc2)
      defWndProc2 = 0
   End If
  
End Sub

Public Sub Hook(hWND As Long, a As gList, Optional NoEvents As Boolean = False)
' work in IDE but for development and a fear...of a crash...

If HOOKTEST <> 0 Then
'Debug.Print "unhook now"
UnHook HOOKTEST
End If
If HOOKTEST <> 0 Then
'Debug.Print "Can't hook now..exit"
Exit Sub
End If
'debug.Print "New Hook @" + CStr(hWnd)
HOOKTEST = hWND
If m_bInIDE Then Exit Sub

   If defWndProc = 0 Then

      defWndProc = SetWindowLong(hWND, _
                                 GWL_WNDPROC, _
                                 AddressOf WindowProc)
                             If Not NoEvents Then MyDoEvents
         If defWndProc = 0 Then Set LastGlist = Nothing
         
    End If
           Set LastGlist = a
End Sub
Public Sub UnHook(hWND As Long)

If HOOKTEST <> hWND Then
'Debug.Print "Can't delete hook hWnd isn't mine, exit now"
Exit Sub
End If
HOOKTEST = 0
'Debug.Print "Delete Hook @" + CStr(hWnd)
If m_bInIDE Then Exit Sub
    If defWndProc > 0 Then
    
      Call SetWindowLong(hWND, GWL_WNDPROC, defWndProc)
      defWndProc = 0
   End If
    
End Sub
Public Function WindowProc3(ByVal hWND As Long, _
                           ByVal uMsg As Long, _
                           ByVal wParam As Long, _
                           ByVal lParam As Long) As Long
On Error GoTo there3:
   Select Case uMsg
         Case WM_MOUSEWHEEL
        Select Case Sgn(wParam)
        Case 1:

        If Not LastGlist3 Is Nothing Then
        
        With LastGlist3
        If .Spinner Then
        .Value = .Value - .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageUp, 0
        .CalcAndShowBar
        End If

        End With
        End If
        
        Case -1:
      
          If Not LastGlist3 Is Nothing Then
        With LastGlist3
        If .Spinner Then
        .Value = .Value + .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageDown, 0
        .CalcAndShowBar
        End If

        End With
        End If
        End Select
      Case Else
there3:
         WindowProc3 = CallWindowProc(defWndProc3, _
                                     hWND, _
                                     uMsg, _
                                     wParam, _
                                     lParam)
   End Select
    
End Function

Public Function WindowProc2(ByVal hWND As Long, _
                           ByVal uMsg As Long, _
                           ByVal wParam As Long, _
                           ByVal lParam As Long) As Long
On Error GoTo there2:
   Select Case uMsg
         Case WM_MOUSEWHEEL
        Select Case Sgn(wParam)
        Case 1:

        If Not LastGlist2 Is Nothing Then
        
        With LastGlist2
        If .Spinner Then
        .Value = .Value - .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageUp, 0
        .CalcAndShowBar
        End If

        End With
        End If
        
        Case -1:
      
          If Not LastGlist2 Is Nothing Then
        With LastGlist2
        If .Spinner Then
        .Value = .Value + .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageDown, 0
        .CalcAndShowBar
        End If

        End With
        End If
        End Select
      Case Else
there2:
         WindowProc2 = CallWindowProc(defWndProc2, _
                                     hWND, _
                                     uMsg, _
                                     wParam, _
                                     lParam)
   End Select
    
End Function
Public Function WindowProc(ByVal hWND As Long, _
                           ByVal uMsg As Long, _
                           ByVal wParam As Long, _
                           ByVal lParam As Long) As Long

   Select Case uMsg
         Case WM_MOUSEWHEEL
        Select Case Sgn(wParam)
        Case 1:

        If Not LastGlist Is Nothing Then
        
        With LastGlist
        If .Spinner Then
        .Value = .Value - .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageUp, 0
        .CalcAndShowBar
        End If

        End With
        End If
        
        Case -1:
      
          If Not LastGlist Is Nothing Then
        With LastGlist
        If .Spinner Then
        .Value = .Value + .smallchange
        Else
        .LargeBar1KeyDown vbKeyPageDown, 0
        .CalcAndShowBar
        End If

        End With
        End If
        End Select
      Case Else
      
         WindowProc = CallWindowProc(defWndProc, _
                                     hWND, _
                                     uMsg, _
                                     wParam, _
                                     lParam)
   End Select
    
End Function
Public Function ExistFileT(a$, TIMESTAMP As Double) As Boolean
Dim wfd As WIN32_FIND_DATA
On Error GoTo there2
Dim fhandle As Long
fhandle = FindFirstFile(StrPtr(a$), wfd)
ExistFileT = (fhandle > 0)
If ExistFileT Then FindClose fhandle: TIMESTAMP = uintnew(wfd.ftLastAccessTime.dwLowDateTime)
Exit Function
there2:
End Function
Public Sub ChangeScreenRes(x As Long, y As Long)
' this is a modified version that i found in internet
Static once As Boolean

Dim DevM As DEVMODE, erg As Long, BITS As Long, nDc As Long
On Error GoTo abort
If VirtualScreenWidth() = ScrX() And VirtualScreenHeight() = ScrY() Then

If Not once Then
oldx = ScrX() / Screen.TwipsPerPixelX
oldy = ScrY() / Screen.TwipsPerPixelY
once = True
End If
nDc = CreateDC("DISPLAY", vbNullString, vbNullString, ByVal 0&)
BITS = GetDeviceCaps(nDc, BITSPIXEL)
erg = EnumDisplaySettings(0&, 0&, DevM)
DevM.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
DevM.dmPelsWidth = x
DevM.dmPelsHeight = y
DevM.dmBitsPerPel = BITS
erg = ChangeDisplaySettings(DevM, CDS_TEST)
DeleteDC nDc
End If
abort:
End Sub
Sub StartingRes()
oldx = ScrX() / Screen.TwipsPerPixelX
oldy = ScrY() / Screen.TwipsPerPixelY
End Sub
Sub ScreenRestore()
Dim DevM As DEVMODE, erg As Long, BITS As Long, nDc As Long
If oldx * oldy = 0 Then Exit Sub
On Error GoTo abort
nDc = CreateDC("DISPLAY", vbNullString, vbNullString, ByVal 0&)
BITS = GetDeviceCaps(nDc, BITSPIXEL)
erg = EnumDisplaySettings(0&, 0&, DevM)
DevM.dmFields = DM_PELSWIDTH Or DM_PELSHEIGHT Or DM_BITSPERPEL
DevM.dmPelsWidth = oldx
DevM.dmPelsHeight = oldy
DevM.dmBitsPerPel = BITS
erg = ChangeDisplaySettings(DevM, CDS_TEST)
DeleteDC nDc
abort:
End Sub



