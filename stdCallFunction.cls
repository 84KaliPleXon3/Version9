VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "stdCallFunction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Dim mLib As String
Dim mFunction As String
Dim mConctruct As String
Dim RetType2Stack As Long   ' 0 is long, 1 is string without zeros
Dim mCallType As Long
Dim t() As Long
Dim paramnum As Long
Public FreeHere As Boolean

Public Sub CallThis(ByVal vNewValue As String, paramList As String, lang As Long)
Dim l As Long, check$, m As Long
l = InStr(vNewValue, ".")
If l <> 0 Then
mLib = Left$(vNewValue, l - 1)
mFunction = Mid$(vNewValue, l + 1)
Else
mLib = vNewValue
mFunction = vbNullString ' what about that??
End If
mConctruct = paramList
If InStr(vNewValue, ".dll") > 0 Then
mLib = mLib + ".dll"
End If
If mFunction Like "dll.*" Then
mFunction = Mid$(mFunction, 5)
ElseIf mFunction Like "dll*" Then
mFunction = Mid$(mFunction, 4)
End If
Do While paramList <> ""

 If IsLabelSymbolNew(paramList, "������", "LONG", lang) Then
 If FastSymbol(paramList, "&") Then l = 16 Else l = 0
 If IsPureLabel(paramList, check$) = 1 Then
 'OK
 m = 2
 Else
 paramList = "error"
 Exit Sub
 End If
 Else
  If FastSymbol(paramList, "&") Then l = 16 Else l = 0
 m = IsPureLabel(paramList, check$)
 If m = 0 Then
 If FastSymbol(paramList, "...", , 3) Then
 PushType -100  ' Paramarray
 Exit Do
 End If
 End If
 End If
PushType m + l   'above 16 is byref
If IsArrayItem(paramnum) Then
If Not FastSymbol(paramList, ")") Then Exit Do
End If
If Not FastSymbol(paramList, ",") Then Exit Do
If check$ = vbNullString Then Exit Do
If paramnum = 63 Then Exit Do
Loop
paramList = Trim$(paramList)   ' if we have somethig then that is an error
End Sub
Public Property Get LIB() As String
LIB = mLib
End Property

Public Property Get func() As String
func = mFunction
End Property

Public Function ReadType(there As Long) As Long
If there < 0 Then Exit Function
If t(there) < 0 Then
ReadType = t(there)
Else
ReadType = (t(there) And &HF)
End If
End Function

Public Function IsArrayItem(there As Long) As Boolean
IsArrayItem = (t(there) And &HF) > 4
End Function
Public Function CheckType(there As Long, ByVal thistype As Long) As Boolean
Select Case thistype
Case 1, 4, 5, 7
thistype = 1
Case Else
thistype = 2
End Select
Select Case (t(there) And &HF)
Case 1, 4, 5, 7
CheckType = thistype = 1
Case Else
CheckType = thistype = 2
End Select
End Function
Public Function IsByRef(there As Long) As Boolean
IsByRef = (t(there) And &HF0) <> 0
End Function


Private Sub PushType(ParamType As Long)
Dim hlp As Long
If paramnum + 1 >= UBound(t()) - LBound(t()) Then
hlp = UBound(t()) * 2
ReDim Preserve t(hlp)
End If
paramnum = paramnum + 1
t(paramnum) = ParamType


End Sub

Private Sub Class_Initialize()
ReDim t(16) As Long
paramnum = -1
End Sub

Public Property Get Count() As Long
Count = paramnum + 1
End Property

Public Property Get RetType() As Long
RetType = RetType2Stack
End Property

Public Property Let RetType(ByVal vNewValue As Long)
RetType2Stack = vNewValue
End Property

Public Property Get CallType() As Long
CallType = mCallType
End Property

Public Property Let CallType(ByVal vNewValue As Long)
mCallType = vNewValue
End Property

Private Sub Class_Terminate()
If FreeHere Then
If mFunction <> "" Then
RemoveDll mFunction
End If
End If
End Sub
