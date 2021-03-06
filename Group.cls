VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Group"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' not MAKE VALUE AS DEFAULT PROPERTY, changed in version 9

Dim VarRef As String
Dim FuncRef As String
Public oldFuncRef As String
Dim LocalRef As String  ' used only for classes
Dim OwnSoros As mStiva
Dim mName As String
Dim mFloatGroupName As String
Dim FloatGroup As Boolean
Dim bank As mArray
Dim mTeam As Boolean
Dim LinkToGroup As Object
Dim mTag As String
Public IamGlobal As Boolean, IamRef As Boolean
Public HasValue As Boolean, HasSet As Boolean, HasStrValue As Boolean, HasParameters As Boolean
Public HasParametersSet As Boolean
Public SuperClassList As Object
Public IamSuperClass As Boolean
Public Function PrepareSoros(ByRef v(), ByVal topname$) As mStiva
Dim i As Long, AllSoros As New mStiva, s As String, vv As mStiva
For i = 1 To OwnSoros.Total
s = OwnSoros.StackItem(i)
'Debug.Print s, topname$, GroupName

If Left$(s$, 1) = "*" Then
AllSoros.DataStr "*" + topname$ + GroupName + Mid$(s, 2)
 If Not IsObject(v(val(Split(s)(1)))) Then Set v(val(Split(s)(1))) = New Group
 If here$ <> "" Then
 Set vv = v(val(Split(s)(1))).PrepareSoros(v(), here$ + "." + GroupName)
 Else
 Set vv = v(val(Split(s)(1))).PrepareSoros(v(), GroupName)
 End If
 
AllSoros.MergeBottom vv
Else
If val(Split(s)(1)) = 0 Then
AllSoros.DataStr s
Else
AllSoros.DataStr topname$ + GroupName + s
End If
End If
Next
Set PrepareSoros = AllSoros

End Function
Public Function PrepareSoros1(ByRef v(), ByVal topname$) As mStiva
Dim i As Long, AllSoros As New mStiva, s As String, vv As mStiva
For i = 1 To OwnSoros.Total
s = OwnSoros.StackItem(i)
If Left$(s$, 1) = "*" Then
AllSoros.DataStr "*" + topname$ + "." + Split(Mid$(s, 2))(0)

 Set vv = v(val(Split(s)(1))).PrepareSoros1(v(), GroupName)
 
AllSoros.MergeBottom vv
Else
AllSoros.DataStr GroupName + Split(s)(0)
End If
Next
Dim a() As String
If FuncRef$ <> "" Then
a() = Split(Replace(FuncRef$, Chr$(3), Chr$(2)), Chr$(2))
If UBound(a()) > 0 Then
For i = 1 To UBound(a())
AllSoros.DataStr topname$ + "." + Split(a(i))(0)
Next i
End If
End If
Set PrepareSoros1 = AllSoros

End Function
Public Function PrepareSorosToCompare(ByRef v()) As mStiva
Dim i As Long, AllSoros As New mStiva, s As String, vv As mStiva
For i = 1 To OwnSoros.Total
s = OwnSoros.StackItem(i)
'Debug.Print s, topname$, GroupName

If Left$(s$, 1) = "*" Then
AllSoros.DataStr "*" + Split(Mid$(s, 2))(0)
 If Not IsObject(v(val(Split(s)(1)))) Then Set v(val(Split(s)(1))) = New Group
 
 Set vv = v(val(Split(s)(1))).PrepareSoros1(v(), "")
 
 
 
AllSoros.MergeBottom vv
Else

AllSoros.DataStr (Split(s)(0))

End If
Next
Dim a() As String
If FuncRef$ <> "" Then
a() = Split(Replace(FuncRef$, Chr$(3), Chr$(2)), Chr$(2))
If UBound(a()) > 0 Then
For i = 1 To UBound(a())
AllSoros.DataStr (Split(a(i))(0))
Next i
End If
End If
Set PrepareSorosToCompare = AllSoros

End Function
Public Function types() As String
Dim i As Long, s$
i = OwnSoros.Total
On Error Resume Next
While i > 0
If InStr(OwnSoros.StackItem(i), "( ") > 0 Then
s$ = "A" + s$
Else
s$ = "V" + s$
End If

i = i - 1

Wend
types = s$
End Function
Public Sub PeekItem(cursor As Long, item)
'' used in the float mode
Dim JJ As Variant

If IsObject(bank.item(cursor)) Then
Set item = bank.item(cursor)
Else
If mTeam Then
        If cursor = bank.item(1) * 2 + 3 Then
            ' we need common definitions for functions and modules all elements
                
                
                LinkToGroup.PeekItem 1, JJ
               ' If JJ = 0 Then Exit Sub
                LinkToGroup.PeekItem JJ * 2 + 3, item
                        Exit Sub
            ElseIf cursor = bank.item(1) * 2 + 2 Then
                    
                    LinkToGroup.PeekItem 1, JJ
                  '  If JJ = 0 Then Exit Sub
                    LinkToGroup.PeekItem JJ * 2 + 2, item
                          Exit Sub
            End If
End If

item = bank.item(cursor)
End If

End Sub
Public Sub PokeItem(cursor As Long, item)
' used in the float mode
If IsObject(item) Then
Set bank.item(cursor) = item
Else
' always last two items are for local vars and functions
If mTeam And cursor >= bank.item(1) * 2 + 2 Then

'' do nothing
Else
 bank.item(cursor) = item
 End If
End If
End Sub

Public Sub BeginFloat(Total As Long)
FloatGroup = True
Set bank = New mArray
flitems = Total
bank.PushDim Total * 2
bank.PushEnd
End Sub

Public Sub BeginFloat2(Total As Long)
FloatGroup = True
flitems = Total
bank.PushDim Total * 2
bank.PushEnd
End Sub
Public Property Get IamFloatGroup()
IamFloatGroup = FloatGroup
End Property
Public Property Get IamTeam()
IamTeam = mTeam
End Property
Public Sub EndFloat()
If FloatGroup Then bank.SerialItem (0), 0, 7
FloatGroup = False
Set bank = Nothing
End Sub
Public Property Set LinkRef(a As Object)
If FloatGroup Then
If Typename(a) <> "Group" Then
Exit Property
End If
mTeam = False
Set LinkToGroup = a
If a Is Nothing Then Exit Property
'erase functions,,,
 bank.item(bank.item(1) * 2 + 3) = vbNullString
mTeam = True
Else
' only when is in an array as Float Group
End If
End Property
Public Property Get Link() As Object
Set Link = LinkToGroup
End Property
Public Property Set Sorosref(a As mStiva)
If FloatGroup Then
' we can't do anything with stored values
Else
Set OwnSoros = a
End If
End Property
Public Property Get soros() As mStiva
Set soros = OwnSoros
End Property

Public Property Let Varlist(ByVal vNewValue As String)
VarRef$ = vNewValue
End Property
Public Property Get Varlist() As String
Varlist = VarRef$
End Property


Public Property Get FuncList() As String
FuncList = FuncRef$
End Property
Public Property Let FuncList(ByVal vNewValue As String)
FuncRef$ = vNewValue
End Property
Public Function ArrlistTotal(v(), skip As Boolean) As String
    Dim i As Long, s As String, Sm As String
    For i = 1 To OwnSoros.Total
    s = OwnSoros.StackItem(i)
    If Left$(s, 1) = "*" Then
    If Not IsObject(v(val(Split(s)(1)))) Then Set v(val(Split(s)(1))) = New Group
    Sm = Sm + v(val(Split(s)(1))).ArrlistTotal(v(), 0)
    End If
    Next
    If skip Then
    ArrlistTotal = ArrRef + Sm$
    Else
    ArrlistTotal = Replace(ArrRef + Sm$, Chr$(13) + "__", Chr$(13) + "__" + mName)
    End If
End Function

Public Property Get LocalList() As String
LocalList = LocalRef$
End Property

Public Property Let LocalList(ByVal vNewValue As String)
LocalRef$ = vNewValue
End Property

Public Property Get FloatGroupName() As Variant
FloatGroupName = mFloatGroupName
End Property

Public Property Let FloatGroupName(ByVal vNewValue As Variant)
mFloatGroupName = vNewValue
End Property

Public Property Get GroupName() As Variant
GroupName = mName
End Property

Public Property Let GroupName(ByVal vNewValue As Variant)
mName = vNewValue
End Property


Private Sub Class_Initialize()
Set OwnSoros = New mStiva
End Sub

Private Sub Class_Terminate()
Set SuperClassList = Nothing
If IamFloatGroup Then EndFloat
Set LinkToGroup = Nothing
End Sub

Public Property Get edittag() As String
If mTeam Then
edittag = LinkToGroup.edittag
Else
edittag = mTag
End If
End Property

Public Property Let edittag(ByVal vNewValue As String)
If Not mTeam Then mTag = vNewValue
End Property

Public Sub ResetGroup()
Set SuperClassList = Nothing
If IamFloatGroup Then EndFloat
Set LinkToGroup = Nothing
Set OwnSoros = New mStiva
HasValue = False
HasSet = fasle
HasStrValue = False
HasParameters = False
IamSuperClass = False
FuncRef = vbNullString
LocalRef = vbNullString
VarRef = vbNullString
End Sub
