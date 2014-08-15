
'******************************************************
'** Display the config screen and wait for events from 
'** the screen.
'******************************************************
Function showConfigScreen(s=invalid) As void
    m.menuFunctions = [
        selectLocation,
        enterUsername,
        enterPassword,
        selectService,
        enableHD,
        mainMenu
    ]
    if s<>invalid m.mainScreen=s
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetHeader("SmoothStreams Roku App")
    screen.SetBreadcrumbText("Menu","Settings")
    contentList = InitContentList()
    screen.SetContent(contentList)
    m.screen=screen
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                m.menuFunctions[msg.GetIndex()]()
                contentList = InitContentList()
                m.screen.SetContent(contentList)
                m.screen.SetFocusedListItem(msg.GetIndex())
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while

End Function

Function selectLocation() as void
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetHeader("SmoothStreams Roku App")
    screen.SetBreadcrumbText("Settings"," Server Location")
    locationList = InitLocationList()
    for each l in locationList
        screen.AddContent({Title: l})   
    end for
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                RegWrite("Server Location",locationList[msg.GetIndex()])
                return
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while        
End Function

Function enterUsername() as void
     screen = CreateObject("roKeyboardScreen")
     port = CreateObject("roMessagePort") 
     screen.SetMessagePort(port)
     screen.SetTitle("Enter Username")
     screen.SetText(RegRead("Username"))
     screen.SetDisplayText("enter your username")
     screen.setSecureText(false)
     screen.AddButton(1, "ok")
     screen.Show() 
     while true
         msg = wait(0, screen.GetMessagePort()) 
         'print "message received"
         if type(msg) = "roKeyboardScreenEvent" 
             if msg.isButtonPressed() then
                 'print "Evt:"; msg.GetMessage ();" idx:"; msg.GetIndex()
                 if msg.GetIndex() = 1
                     RegWrite("Username",screen.getText())
                     return
                 endif
             else if msg.isScreenClosed() then
                     return
             endif
         endif
     end while           
End Function

Function enterPassword() as void
     screen = CreateObject("roKeyboardScreen")
     port = CreateObject("roMessagePort") 
     screen.SetMessagePort(port)
     screen.SetTitle("Enter Password")
     screen.SetDisplayText("enter your password")
     screen.setSecureText(true)
     screen.AddButton(1, "ok")
     screen.Show() 
     while true
         msg = wait(0, screen.GetMessagePort()) 
         'print "message received"
         if type(msg) = "roKeyboardScreenEvent" 
             if msg.isButtonPressed() then
                 'print "Evt:"; msg.GetMessage ();" idx:"; msg.GetIndex()
                 if msg.GetIndex() = 1
                     RegWrite("Password",screen.getText()) 
                     return
                 endif
             else if msg.isScreenClosed() then
                    return
             endif
         endif
     end while           
End Function

Function selectService() as void
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetHeader("SmoothStreams Roku App")
    screen.SetBreadcrumbText("Settings","Service")
    serviceList = InitServiceList()
    for each s in serviceList
        screen.AddContent({Title: s})   
    end for
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                RegWrite("Service",serviceList[msg.GetIndex()])
                return
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while        
End Function

Function enableHD() as void
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetHeader("SmoothStreams Roku App")
    screen.SetBreadcrumbText("Settings","Enable HD")
    screen.AddContent({Title: "Yes"})
    screen.AddContent({Title: "No"})  
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                if msg.GetIndex()=0 then
                    RegWrite("Enable HD","Yes")
                else
                    RegWrite("Enable HD","No")
                endif
                return
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while        
End Function

Function InitContentList() as object
    contentList = [
        {
            Title: "Server Location",
            ID: "1",           
            ShortDescriptionLine1: "Select the Server Location",
            ShortDescriptionLine2: RegRead("Server Location")
        },
        {
            Title: "Username",
            ID: "2",           
            ShortDescriptionLine1: "Set your username",
            ShortDescriptionLine2: RegRead("Username")
        },
        {
            Title: "Password",
            ID: "3",           
            ShortDescriptionLine1: "Set your password"
        },
        {
            Title: "Service",
            ID: "4",           
            ShortDescriptionLine1: "Select your service",
            ShortDescriptionLine2: RegRead("Service")
        '},
        '{
         '   Title: "Enable HD",
         '   ID: "5",           
         '   ShortDescriptionLine1: "Enable/Disable HD streams",
         '   ShortDescriptionLine2: RegRead("Enable HD")
        }
    ]
    return contentList
End Function

Function InitLocationList() as object
    contentList=["EU Random","EU Amsterdam","EU London","US East","US West","US All","Asia"]
    return contentList
End Function

Function InitServiceList() as object
    contentList=["MyStreams & uSport","Live247","StarStreams","MMA-TV / MyShout"]
    return contentList
End Function

Function mainMenu() as void
    if m.mainScreen<>invalid then
        return
    else
        m.screen.close()
        showHomeScreen()
    endif
End Function