REM This file has no dependencies on other common files.
REM
REM Functions in this file:
REM     GetDeviceVersion
REM     GetDeviceESN
REM     IsHD
REM

'******************************************************
'Get our device version
'******************************************************
Function GetDeviceVersion()
    if m.softwareVersion = invalid OR m.softwareVersion = "" then
        m.softwareVersion = CreateObject("roDeviceInfo").GetVersion()
    end if
    return m.softwareVersion
End Function


'******************************************************
'Get our serial number
'******************************************************
Function GetDeviceESN()
    if m.serialNumber = invalid OR m.serialNumber = "" then
        m.serialNumber = CreateObject("roDeviceInfo").GetDeviceUniqueId()
    end if
    return m.serialNumber
End Function


'******************************************************
'Get our hardware model number
'******************************************************
Function GetHardwareModel()
    if m.hardwareModel = invalid OR m.hModel = "" then
        m.hardwareModel = CreateObject("roDeviceInfo").GetModel()
    end if
    return m.hardwareModel
End Function

'******************************************************
'Get Video Mode
'******************************************************
Function GetVideoMode()
    if m.VideoMode = invalid OR m.VideoMode = "" then
        m.VideoMode = CreateObject("roDeviceInfo").GetVideoMode()
    end if
    print "VideoMode ::::: " ; m.VideoMode
    return m.VideoMode
End Function


'******************************************************
'Determine if the UI is displayed in SD or HD mode
'******************************************************
Function IsHD()
    di=CreateObject("roDeviceInfo")
    if di.GetDisplayMode() = "720p" then return true
    return false
End Function

'******************************************************
' @returns The maximum between a and b. Both inputs
'          should be the same type for this comparison
'          to work.
'******************************************************
Function max(a As Dynamic, b As Dynamic) As Dynamic
    if b > a then return b
    return a
End Function

'******************************************************
' @return The MD5 hash of the specified text
'******************************************************
Function getMD5Hash(text As String) As String
    digest = CreateObject("roEVPDigest")
    digest.Setup("md5")
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(text)
    digest.Update(ba)
    return LCase(digest.Final())
End Function


'******************************************************
' @return The time in seconds since the epoch (1/1 1970).
'******************************************************
Function nowSecs() As Integer
    now = m.globalClock
    if now=invalid
        now = CreateObject("roDateTime")
        m.globalClock = now
    end if
    now.mark()
    return now.asSeconds()
End Function

'******************************************************
'Get our hardware model number
'******************************************************
function GetModelNumber()
    strModel = GetHardwareModel()
    strLength = len(strModel)
    strModel = left (strModel,strLength-1)
    modelNum = strtoi(strModel)    
    m.ModelNumber = modelNum
    return modelNum    
end function 



'******************************************************
' Convert AA to JSON string
'******************************************************
Function AAToJSON(aa As Object) As String
    return AAToJSONHelper(aa, 0)
End Function

Function AAToJSONHelper(aa As Object, indent As Integer) As String
    result = ""
    if (aa <> invalid)
        result = result + chr(10)
        for index = 1 to indent step 1
            result = result + chr(9)    ' tab
        end for

        result = result + "{"
        leadingComma = false
        for each e in aa
            if (leadingComma)
                result = result + "," + chr(10)
                for index = 1 to indent step 1
                    result = result + chr(9)    ' tab
                end for
            else
                leadingComma = true
            end if

            REM - chr(34) = "
            result = result + chr(34) + e + chr(34) + ":"
            x = aa[e]
            if (x = invalid)
	        result = result + "null"
            else if (type(x) = "roAssociativeArray")
                result = result + AAToJSONHelper(x, indent + 1)
            else if (isint(x))
                result = result + itostr(x)
            else if (isfloat(x))
                result = result + Str(x).Trim()
            else if (isstr(x))
                result = result + chr(34) + x + chr(34)
            else if (type(x) = "roArray")
                result = result + "["
                leadingArrayComma = false
                for each item in x
                    if (leadingArrayComma)
                        result = result + "," + chr(10)
                        for index = 1 to indent step 1
                            result = result + chr(9)    ' tab
                        end for
                    else
                        leadingArrayComma = true
                    end if
                    result = result + AAToJSONHelper(item, indent + 1)
                end for
                result = result + "]"
            else if (type(x) = "roBoolean")
                if (x)
                    result = result + "true"
                else
                    result = result + "false"
                end if
            else
                result = result + "invalid type"
            end if
        next
        result = result + "}"
    end if

    return result
End Function

function ClearPort(port)
     msg = port.GetMessage()
     while (msg <> invalid)
        msg = port.GetMessage()
     end while
end function