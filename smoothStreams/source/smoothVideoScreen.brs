function smoothVideoScreen() as object
    
    
    screen = CreateObject("roVideoScreen")
    port = CreateObject("roMessagePort")
       
    return {
        screen: screen,
        port: port,
        setup: smoothVideoScreen_setup,
        show: smoothVideoScreen_show,
        eventLoop: smoothVideoScreen_eventLoop       
    }
        
end function


function smoothVideoScreen_setup(content)
    m.screen.SetMessagePort(m.port)
    m.screen.SetContent(content)
    return m
end function

function smoothVideoScreen_show()
    m.screen.show()
    return m
end function

function smoothVideoScreen_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                'print "Closing video screen"
                exit while
            else if msg.isRequestFailed()
                print "play failed: "; msg.GetMessage()
            else
                'print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while
end function
