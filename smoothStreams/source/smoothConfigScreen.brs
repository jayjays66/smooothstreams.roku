function smoothConfigScreen() as object

 constants = {
        SCREEN_HEADER : "SmoothStreams ROKU App",
        BREADCRUMB_1 : "Main Menu"
        BREADCRUMB_2 : "Settings"
    }
    
    listScreen = CreateObject("roListScreen")
    msgPort = CreateObject("roMessagePort")
       
    return {
        constants: constants,
        list: smoothConfigScreen_list(),
        screen: listScreen,
        port: msgPort,
        setup: smoothConfigScreen_setup,
        show: smoothConfigScreen_show,
        eventLoop: smoothConfigScreen_eventLoop  
    }
        
end function

function smoothConfigScreen_list() as object
    return [
        {
            Title: "Server Location",
            ID: "1",           
            ShortDescriptionLine1: "Select the Server Location",
            ShortDescriptionLine2: m.config.server().name,
            action: smoothConfigScreen_selectLocation
        },
        {
            Title: "Username",
            ID: "2",           
            ShortDescriptionLine1: "Set your username",
            ShortDescriptionLine2: m.config.username.GET(),
            action: smoothConfigScreen_enterUsername
        },
        {
            Title: "Password",
            ID: "3",           
            ShortDescriptionLine1: "Set your password",
            action: smoothConfigScreen_enterPassword
        },
        {
            Title: "Service",
            ID: "4",           
            ShortDescriptionLine1: "Select your service",
            ShortDescriptionLine2: m.config.site().name,
            action: smoothConfigScreen_selectService
        },
        {
            Title:  "Quality",
            ID: "5",
            ShortDescriptionLine1: "Select Quality",
            ShortDescriptionLine2: m.config.Quality.GET(),
            action: smoothConfigScreen_selectQuality
        },
        {
            Title: "Login and back to menu",
            ID: "6",           
            ShortDescriptionLine1: "Attempt to login",
            action: smoothConfigScreen_mainMenu
        }
    ]
end function

function smoothConfigScreen_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetBreadcrumbText(m.constants.BREADCRUMB_1, m.constants.BREADCRUMB_2)
    m.screen.SetContent(m.list)
    return m
end function

function smoothConfigScreen_show()
    m.screen.show()
    return m
end function

function smoothConfigScreen_eventLoop() as void
    while(true)
        msg = wait(0, m.port)
        if type(msg) = "roListScreenEvent" then
            if msg.isListItemSelected()
                if msg.GetIndex()=5 then
                    m.screen.close()
                    loginMainMenu()
                end if
                m.list[msg.GetIndex()].action()
                m.screen.SetContent(smoothConfigScreen_list())
                m.screen.SetFocusedListItem(msg.GetIndex())
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while
end function

function smoothConfigScreen_selectLocation()
    settingSelect = smoothSettingSelect()
    settingselect.breadcrumb1 = "Settings"
    settingSelect.breadcrumb2 = "Server Location"
    serverList = GetGlobalAA().service.servers
    serverItems = []
    for each server in serverList
        serverItems.push({Title:serverList[server].name,value:server})
    end for
    Sort(serverItems,returnTitle)
    settingSelect.list = serverItems
    settingSelect.setup().show().eventLoop()
    if (settingSelect.selectedIndex>=0)
        selectedItem = serverItems[settingSelect.selectedIndex].value
        config = GetGlobalAA().config
        config.location.SET(selectedItem)
    end if
end function

function smoothConfigScreen_enterUsername()
    enterUsername = smoothEnterScreen()
    enterUsername.displaytext = "enter your username"
    enterUsername.setup(false).show().eventLoop()
    if (enterUsername.enteredText <> "") then
        config = GetGlobalAA().config
        config.username.SET(enterUsername.enteredText)
    end if
end function

function smoothConfigScreen_enterPassword()
    enterPassword = smoothEnterScreen()
    enterPassword.displaytext = "enter your password"
    enterPassword.setup(true).show().eventLoop()
    if (enterPassword.enteredText <> "") then
        config = GetGlobalAA().config
        config.password.SET(enterPassword.enteredText)
    end if
end function

function smoothConfigScreen_selectQuality()
    settingSelect = smoothSettingSelect()
    settingselect.breadcrumb1 = "Settings"
    settingSelect.breadcrumb2 = "Set Quality"
    qualityItems = []
    qualityItems.push({Title:"HD",value:"q1"})
    qualityItems.Push({Title:"SD",value:"q2"})
    settingSelect.list = qualityItems
    settingSelect.setup().show().eventLoop()
    if (settingSelect.selectedIndex>=0) then
        selectedItem = qualityItems[settingSelect.selectedIndex].value
        config = GetGlobalAA().config
        config.Quality.SET(selectedItem)
    end if
end function

function smoothConfigScreen_selectService()
    settingSelect = smoothSettingSelect()
    settingselect.breadcrumb1 = "Settings"
    settingSelect.breadcrumb2 = "Set Service"
    siteList = GetGlobalAA().service.sites
    siteItems = []
    for each site in siteList
        siteItems.push({Title:siteList[site].name,value:site})
    end for
    Sort(siteItems,returnTitle)
    settingSelect.list = siteItems
    settingSelect.setup().show().eventLoop()
    if (settingSelect.selectedIndex>=0) then
        selectedItem = siteItems[settingSelect.selectedIndex].value
        config = GetGlobalAA().config
        config.service.SET(selectedItem)
    end if
    
end function

function smoothConfigScreen_mainMenu() as void
    return
end function