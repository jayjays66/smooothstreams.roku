'**********************************************************
'**  Video Player Example Application - General Utilities 
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

'******************************************************
'Registry Helper Functions
'******************************************************
Sub Sort(A as Object, key=invalid as dynamic)
    ''print "sorting by "; key
    'print type(A)
    if type(A)<>"roArray" then return

    if (key=invalid) then
        'print "key invalid"
        for i = 1 to A.Count()-1
            value = A[i]
            j = i-1
            while j>= 0 and A[j] > value
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next

    else
        if type(key)<>"Function" then
            'print "key not function"
            return
        endif
        'print A.Count()
        for i = 1 to A.Count()-1
            valuekey = key(A[i])
            'print valuekey
            value = A[i]
            j = i-1
            while j>= 0 and key(A[j]) > valuekey
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next

    end if

End Sub
Function RegRead(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key) then return sec.Read(key)
    return ""
End Function

Function RegWrite(key, val, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush() 'commit it
End Function

Function RegDelete(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
End Function

Function checkConfig() as Boolean
    configItems=["Server Location","Username","Password","Service"]
    check=true
    for each ci in configItems
        if RegRead(ci)="" check=false   
    End For
    return check
End Function

Function AnyToString(any As Dynamic) As dynamic
    if any = invalid return "invalid"
    if isstr(any) return any
    if isint(any) return itostr(any)
    if isbool(any)
        if any = true return "true"
        return "false"
    endif
    if isfloat(any) return Str(any)
    if type(any) = "roTimespan" return itostr(any.TotalMilliseconds()) + "ms"
    return invalid
End Function
'******************************************************
'islist
'
'Determine if the given object supports the ifList interface
'******************************************************
Function islist(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifArray") = invalid return false
    return true
End Function


'******************************************************
'isint
'
'Determine if the given object supports the ifInt interface
'******************************************************
Function isint(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifInt") = invalid return false
    return true
End Function

'******************************************************
' validstr
'
' always return a valid string. if the argument is
' invalid or not a string, return an empty string
'******************************************************
Function validstr(obj As Dynamic) As String
    if isnonemptystr(obj) return obj
    return ""
End Function


'******************************************************
'isstr
'
'Determine if the given object supports the ifString interface
'******************************************************
Function isstr(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifString") = invalid return false
    return true
End Function


'******************************************************
'isnonemptystr
'
'Determine if the given object supports the ifString interface
'and returns a string of non zero length
'******************************************************
Function isnonemptystr(obj)
    if isnullorempty(obj) return false
    return true
End Function


'******************************************************
'isnullorempty
'
'Determine if the given object is invalid or supports
'the ifString interface and returns a string of non zero length
'******************************************************
Function isnullorempty(obj)
    if obj = invalid return true
    if not isstr(obj) return true
    if Len(obj) = 0 return true
    return false
End Function


'******************************************************
'isbool
'
'Determine if the given object supports the ifBoolean interface
'******************************************************
Function isbool(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifBoolean") = invalid return false
    return true
End Function


'******************************************************
'isfloat
'
'Determine if the given object supports the ifFloat interface
'******************************************************
Function isfloat(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifFloat") = invalid return false
    return true
End Function


'******************************************************
'strtobool
'
'Convert string to boolean safely. Don't crash
'Looks for certain string values
'******************************************************
Function strtobool(obj As dynamic) As Boolean
    if obj = invalid return false
    if type(obj) <> "roString" return false
    o = strTrim(obj)
    o = Lcase(o)
    if o = "true" return true
    if o = "t" return true
    if o = "y" return true
    if o = "1" return true
    return false
End Function


'******************************************************
'itostr
'
'Convert int to string. This is necessary because
'the builtin Stri(x) prepends whitespace
'******************************************************
Function itostr(i As Integer) As String
    str = Stri(i)
    return strTrim(str)
End Function

'******************************************************
'Trim a string
'******************************************************
Function strTrim(str As String) As String
    st=CreateObject("roString")
    st.SetString(str)
    return st.Trim()
End Function

Function padNumber(i) as string
    if strToI(i)<10 then
        return "0" + AnyToString(i)
    else
        return AnyToString(i)
    end if
End Function
Function padTime(i) as string
    if i<10 then
        return "0" + itostr(i)
    else
        return itostr(i)
    end if
end function
'*************************************************************
'** Returns date as seconds given an associative array, used for sortng
'*************************************************************
Function returnDate(a) as integer
    dt=CreateObject("roDateTime")
    dt.fromISO8601String(a.time)
    ''print "return datetime is "; dt
    return dt.asSeconds()
End Function

Function returnId(a) as integer
    return strToI(a.Id)
End Function

Function returnTitle(a) as string
    return a.title
End Function
'*************************************************************
'** Converts date/time string from json to local date/time string
'*************************************************************
function convertDate(dateString) as string
    dt=CreateObject("roDateTime")
    dt.fromISO8601String(dateString)
    dt.fromSeconds(dt.asSeconds() + (60 * 60 * 4))
    dt.toLocalTime()
    ''print "convert datetime is "; dt.asDateStringNoParam()
    return dt.asDateStringNoParam() + " " + padTime(dt.getHours()) + ":" + padTime(dt.getMinutes())
end function

function convertDateSeconds(dateString) as integer
    dt=CreateObject("roDateTime")
    dt.fromISO8601String(dateString)
    dt.fromSeconds(dt.asSeconds() + (60 * 60 * 4))
    dt.toLocalTime()
    ''print "convert datetime is "; dt.asDateStringNoParam()
    return dt.asSeconds()
end function

function convertDateStringToISO8601(dateString) as string

    years = left(dateString,4)
    month = mid(dateString,5,2)
    day = mid(datestring,7,2)
    hours = mid(dateString,9,2)
    minutes = mid(dateString,11,2)
    seconds = mid(dateString,13,2)
    
    return years + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds

end function