function smoothScheduleScreen() as object
    
    constants = {
        SCREEN_HEADER : "SmoothStreams ROKU App",
        BREADCRUMB_1 : "Main Menu"
        BREADCRUMB_2 : "Schedule"
    }
    
    screen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")
       
    return {
        constants: constants,
        list: GetGlobalAA().scheduleService.refresh().schedule,
        categories: GetGlobalAA().scheduleService.scheduleCategories,
        screen: screen,
        port: port,
        setup: smoothScheduleScreen_setup,
        show: smoothScheduleScreen_show,
        eventLoop: smoothScheduleScreen_eventLoop       
    }
        
end function


function smoothScheduleScreen_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetBreadcrumbText(m.constants.BREADCRUMB_1, m.constants.BREADCRUMB_2)
    m.screen.SetListNames(m.categories)
    m.screen.SetContentList(m.list[m.categories[0]])
    m.screen.SetListStyle("flat-episodic")
    m.screen.SetListDisplayMode("scale-to-fit")
    return m
end function

function smoothScheduleScreen_show()
    m.screen.show()
    return m
end function

function smoothScheduleScreen_eventLoop() as void
    currList=m.categories[0]
    while(true)
        msg = wait(0, m.port)
       if (type(msg) = "roPosterScreenEvent")
         If msg.isScreenClosed() Then
            return
         Else If msg.isListItemSelected()
            videoScreen = smoothVideoScreen().setup(m.list[currList][msg.GetIndex()])
            videoScreen.show().eventLoop()
         Else If msg.isListFocused()
            currList=m.categories[msg.GetIndex()]
            m.screen.SetContentList(m.list[currList])
            m.screen.SetFocusedListItem(0)
         End If 
        endif
    end while
end function
