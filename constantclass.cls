VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Constant"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Dim mValue As Variant
Public Property Get Value() As Variant
Attribute Value.VB_UserMemId = 0
Value = mValue
End Property
Public Property Let Value(RHS As Variant)
MyEr "Constant value", "������� ����"
Err.Raise 20
End Property
Public Sub DefineOnce(RHS As Variant)
If Typename(mValye) = "Empty" Then mValue = RHS
End Sub
