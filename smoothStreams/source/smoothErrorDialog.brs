function smoothErrorDialog() as object
    
    screen = CreateObject("roMessageDialog")
    port = CreateObject("roMessagePort")
       
    return {
        screen: screen,
        port: port,
        service: GetGlobalAA().service,
        config: GetGlobalAA().config,
        setup: smoothErrorDialog_setup,
        show: smoothErrorDialog_show,
        eventLoop: smoothErrorDialog_eventLoop,
        errors:[]   
    }
        
end function

function smoothErrorDialog_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetTitle("Error with " + m.config.site().name)
    for each error in m.errors
      m.screen.AddStaticText(error.error) 
    end for
    m.screen.AddButton(0,"Settings") 
    return m
end function

function smoothErrorDialog_show()
    m.screen.show()
    return m
end function

function smoothErrorDialog_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
        if (type(msg) = "roMessageDialogEvent")
            if (msg.isButtonPressed())
                m.screen.close()
                return
            endif
        endif      
    end while
end function