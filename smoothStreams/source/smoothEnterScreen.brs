function smoothEnterScreen() as object
    
    
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort") 
       
    return {
        screenTitle:"",
        displayText: "",
        screen: screen,
        port: port,
        setup: smoothEnterScreen_setup,
        show: smoothEnterScreen_show,
        eventLoop: smoothEnterScreen_eventLoop ,
        enteredText:""
    }
        
end function

function smoothEnterScreen_setup(isSecure as boolean)
    m.screen.SetMessagePort(m.port)
    m.screen.SetTitle(m.screenTitle)
    m.screen.SetDisplayText(m.displayText)
    m.screen.setSecureText(isSecure)
    m.screen.AddButton(1, "ok")
    return m
end function

function smoothEnterScreen_show()
    m.screen.show()
    return m
end function

function smoothEnterScreen_eventLoop() as void
    while(true)
        msg = wait(0, m.port) 
        if type(msg) = "roKeyboardScreenEvent" 
        if msg.isButtonPressed() then
            if msg.GetIndex() = 1
                m.enteredText = m.screen.getText()
               return
            endif
            else if msg.isScreenClosed() then
               return
            endif
        endif
    end while
end function
