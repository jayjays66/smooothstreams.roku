function smoothMainMenu() as object
    
    constants = {
        SCREEN_HEADER : "SmoothStreams ROKU App",
        BREADCRUMB_1 : "Main Menu"
        BREADCRUMB_2 : ""
    }
    
    posterScreen = CreateObject("roPosterScreen")
    msgPort = CreateObject("roMessagePort")
       
    return {
        constants: constants,
        list: smoothMainMenu_list(),
        screen: posterScreen,
        port: msgPort,
        setup: smoothMainMenu_setup,
        show: smoothMainMenu_show,
        eventLoop: smoothMainMenu_eventLoop       
    }
        
end function

function smoothMainMenu_list() as object
    return [
        {
            Title: "Settings",
            ID: "1",           
            ShortDescriptionLine1: "Settings",
            ShortDescriptionLine2: "Configure the App",
            SDPosterUrl:"pkg:/images/File.png",
            HDPosterUrl:"pkg:/images/File.png",
            action: smoothMainMenu_configScreen
        },
        {
            Title: "Channels",
            ID: "2",           
            ShortDescriptionLine1: "Channels Menu",
            ShortDescriptionLine2: "Watch smoothstreams channels"
            SDPosterUrl:"pkg:/images/TV.png",
            HDPosterUrl:"pkg:/images/TV.png",
            action: smoothMainMenu_channelList
        },
        {
            Title: "Schedule",
            ID: "3",           
            ShortDescriptionLine1: "Sports Schedule",
            ShortDescriptionLine2: "View future event schedule"
            SDPosterUrl:"pkg:/images/Calendar.png",
            HDPosterUrl:"pkg:/images/Calendar.png",
            action: smoothMainMenu_scheduleScreen
        }
    ]
end function

function smoothMainMenu_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetBreadcrumbText(m.constants.BREADCRUMB_1, m.constants.BREADCRUMB_2)
    m.screen.SetContentList(m.list)
    m.screen.SetListDisplayMode("scale-to-fit")
    m.screen.SetListStyle("flat-category")
    m.screen.SetFocusedListItem(1)
    return m
end function

function smoothMainMenu_show()
    m.screen.show()
    return m
end function

function smoothMainMenu_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListItemSelected()
                m.list[msg.GetIndex()].action()
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while
end function

function smoothMainMenu_configScreen()
    smoothConfigScreen().setup().show().eventLoop()
end function

function smoothMainMenu_channelList()
    smoothChannelList().setup().show().eventLoop()
end function

function smoothMainMenu_scheduleScreen()
    smoothScheduleScreen().setup().show().eventLoop()
end function
