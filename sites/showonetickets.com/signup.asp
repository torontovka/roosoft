<%
dim message : message = "You've been successfully signed up for a VIP Membership. Our representative will contact you in the near future."

function SendMail(sFrom, sFromName, toAddress, toSubj, toBody, toReplyTo, toAddBcc)
	
    err.clear
    'Session.CodePage=1251
    'on error resume next
    Dim objMail
    Set objMail = Server.CreateObject("Persits.MailSender")
    if err.number <>0 then
        response.write "<HR>"& err.source &"<BR>"& err.description &"<HR>"
        exit function
    end if
    objMail.Host = "178.238.92.158"   '"38.99.140.138" ' valid SMTP server
    'objMail.Username = "rtd_mail" 
    'objMail.Password = "sendRTDmail" 
    objMail.From = sFrom ' sender's email address
    'objMail.FromName = sFromName ' sender's name
    'debug "sFromName",sFromName
    objMail.FromName = objMail.EncodeHeader(sFromName, "Windows-1251")
    objMail.AddAddress toAddress
    objMail.AddReplyTo toReplyTo
    if (Len(toAddBcc) <> 0) Then
     objMail.AddBCC toAddBcc
    end if
	
    objMail.Charset = "Windows-1251"
    'objMail.Charset = "koi8-r"
	
    'objMail.Subject = toSubj
    objMail.Subject = objMail.EncodeHeader(toSubj, "Windows-1251")
    objMail.Body = toBody
	'objMail.IsHTML = True 
	
    'objMail.ContentTransferEncoding = "8bit"
    objMail.ContentTransferEncoding = "Quoted-Printable"
	
    On Error Resume Next
    objMail.Send
	
	If Err <> 0 Then
		Sendmail = Err.Description
	Else
		SendMail = message
	End If
	
    objMail.Close
    Set objMail = Nothing
	
    'DEBUG "Body-After",objMail.Body
    'Session.CodePage=1251
	
end function

dim strMsgBody, sFrom, sFromName, toAddress, toSubj, toBody, toReplyTo, toAddBcc
strMsgBody = vbCrLf & "Name: " & request( "name" ) & vbCrLf
strMsgBody = strMsgBody & "Email: " & request( "email" ) & vbCrLf & vbCrLf

if ( not request( "email" ) <> "" ) then
	toReplyTo	= "daniil.gromov@gmail.com"
	sFrom		= "daniil.gromov@gmail.com"
else
	toReplyTo	= request( "email" )
	sFrom		= request( "email" )
end if

sFromName	= request( "name" )
toAddress	= "daniil.gromov@gmail.com"
toAddBcc	= ""
toSubj		= "[S1T] Membership Request"
toBody		= strMsgBody 

dim msg
on error resume next
msg = SendMail( sFrom, sFromName, toAddress, toSubj, toBody, toReplyTo, toAddBcc )

response.write msg
%>