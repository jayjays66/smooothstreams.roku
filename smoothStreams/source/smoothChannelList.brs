function smoothChannelList() as object
    
    constants = {
        SCREEN_HEADER : "SmoothStreams ROKU App",
        BREADCRUMB_1 : "Main Menu"
        BREADCRUMB_2 : "Channels"
    }
    
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
       
    return {
        constants: constants,
        list: GetGlobalAA().scheduleService.refresh().channels,
        screen: screen,
        port: port,
        setup: smoothChannelList_setup,
        show: smoothChannelList_show,
        eventLoop: smoothChannelList_eventLoop       
    }
        
end function


function smoothChannelList_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetBreadcrumbText(m.constants.BREADCRUMB_1, m.constants.BREADCRUMB_2)
    m.screen.SetContent(m.list)
    return m
end function

function smoothChannelList_show()
    m.screen.show()
    return m
end function

function smoothChannelList_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
       if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                videoScreen = smoothVideoScreen().setup(GetGlobalAA().scheduleService.channels[msg.GetIndex()])
                videoScreen.show().eventLoop()
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while
end function
