function smoothSettingSelect() as object
    
    
    listScreen = CreateObject("roListScreen")
    msgPort = CreateObject("roMessagePort")
       
    return {
        breadcrumb1:"",
        breadcrumb2:"",
        list: [],
        screen: listScreen,
        port: msgPort,
        setup: smoothSettingSelect_setup,
        show: smoothSettingSelect_show,
        eventLoop: smoothSettingSelect_eventLoop ,
        selectedIndex:-1
    }
        
end function

function smoothSettingSelect_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetBreadcrumbText(m.breadcrumb1, m.breadcrumb2)
    m.screen.SetContent(m.list)
    return m
end function

function smoothSettingSelect_show()
    m.screen.show()
    return m
end function

function smoothSettingSelect_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
        if type(msg) = "roListScreenEvent" then
            if msg.isListItemSelected()
                m.selectedIndex = msg.GetIndex()
                m.screen.close()
                return
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while
end function
