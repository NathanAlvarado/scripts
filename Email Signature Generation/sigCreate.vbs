on error resume next
strTemplate = "\\server\location\sigTemplate.dotx"

Set objWord = CreateObject("Word.Application")
Set objDoc = objWord.Documents.Add(strTemplate)

Set objSysInfo = CreateObject("ADSystemInfo")
strUser = objSysInfo.UserName
Set objUser = GetObject("LDAP://" & strUser)

With objDoc.Bookmarks
	If (objUser.Title) Then
		.Item("FullName").Range.Text = objUser.FullName & ","
		.Item("Title").Range.Text = objUser.Title
	Else
		.Item("FullName").Range.Text = objUser.FullName
		.Item("Title").Range.Delete()
	End If
	.Item("Address").Range.Text = objUser.streetaddress
	.Item("OfficeNumber").Range.Text = "Phone: " & objUser.telephoneNumber
	If (objUser.mobile) Then 
		.Item("MobileNumber").Range.Text = "| Cell: " & objUser.mobile
	Else 
		.Item("MobileNumber").Range.Delete()
	End If
    .Item("City").Range.Text = objUser.l
    .Item("State").Range.Text = objUser.st
    .Item("ZIP").Range.Text = objUser.PostalCode
End With

Set selection = objDoc.Range()
With objWord.EmailOptions.EmailSignature
	.EmailSignatureEntries.Add "Signature", selection
	.NewMessageSignature = "Signature"
	.ReplyMessageSignature = "Signature"
End With

objDoc.Saved = True
objWord.Quit