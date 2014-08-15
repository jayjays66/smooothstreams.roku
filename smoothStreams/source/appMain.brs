' ********************************************************************
' **  Sample PlayVideo App
' **  Copyright (c) 2009 Roku Inc. All Rights Reserved.
' ********************************************************************

Sub Main()
    facade = CreateObject("roParagraphScreen")
    facade.AddParagraph("please wait...")
    facade.Show()
    loggedIn=false
    while not loggedIn
        loggedIn=showHomeScreen()
    end while   
    facade.Close()    
End Sub

'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'*************************************************************

Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangPrimaryLogoOffsetSD_X = "72"
    theme.OverhangPrimaryLogoOffsetSD_Y = "15"
    theme.OverhangSliceSD = "pkg:/images/Overhang_BackgroundSlice_SD43.png"
    theme.OverhangPrimaryLogoSD  = "pkg:/images/Logo_Overhang_Smooth_SD43.png"

    theme.OverhangPrimaryLogoOffsetHD_X = "123"
    theme.OverhangPrimaryLogoOffsetHD_Y = "20"
    theme.OverhangSliceHD = "pkg:/images/Overhang_BackgroundSlice_HD.png"
    theme.OverhangPrimaryLogoHD  = "pkg:/images/Logo_Overhang_Smooth_HD.png"
    background = "#FDFDFD"
    titleText = "#000000"
    normalText = "#BFBFBF"
    detailText = "#BFBFBF"
    subtleText = "#000000"
    highlightText="#FFFFFF"

    theme.BackgroundColor = background
    
    theme.CounterTextLeft = titleText
    theme.CounterSeparator = normalText
    theme.CounterTextRight = normalText

    theme.ListScreenHeaderText = titleText
    theme.ListItemText = normalText
    theme.ListItemHighlightText = highlightText
    theme.ListScreenDescriptionText = normalText

    theme.ParagraphHeaderText = titleText
    theme.ParagraphBodyText = normalText

    theme.ButtonNormalColor = normalText
    ' Default for ButtonHighlightColor seems OK...

    theme.RegistrationCodeColor = "#FFA500"
    theme.RegistrationFocalColor = normalText

    theme.SearchHeaderText = titleText
    theme.ButtonMenuHighlightText = titleText
    theme.ButtonMenuNormalText = titleText

    theme.PosterScreenLine1Text = titleText
    theme.PosterScreenLine2Text = normalText
    theme.FilterBannerActiveColor=highlightText
    app.SetTheme(theme)

End Sub

Function showHomeScreen() as boolean
    m.mainmenuFunctions = [
        showConfigScreen,
        showChannelList,
        showScheduleScreen
    ]
    screen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    InitTheme()
    screen.SetBreadcrumbText("Menu","")
    contentList = InitMainList()
    screen.SetContentList(contentList)
    screen.SetListDisplayMode("scale-to-fit")
    screen.SetListStyle("flat-category")
    screen.SetFocusedListItem(1)
    screen.show()
    ' Check for config and see if first run.
    if NOT checkConfig() then
        showConfigScreen()
        return false
    else   
        'Try to Connect to service.
        loadChannelLogos()
        m.response=login()
        print m.response
        if m.response.error<>invalid then
            'show configuration screen
            showConfigScreen()
            return false
        else
            'else show home screen
            while true
                msg = wait(0, screen.GetMessagePort())
                print msg
                if (type(msg) = "roPosterScreenEvent")
                    if (msg.isListItemSelected())
                        m.mainmenuFunctions[msg.GetIndex()]()
                    else if msg.isScreenClosed() then
                        return true
                    endif      
                endif
            end while
        endif
    endif
End Function

Function InitMainList() as object
    contentList = [
        {
            Title: "Settings",
            ID: "1",           
            ShortDescriptionLine1: "Settings",
            ShortDescriptionLine2: "Configure the App",
            SDPosterUrl:"pkg:/images/File.png",
            HDPosterUrl:"pkg:/images/File.png"
        },
        {
            Title: "Channels",
            ID: "2",           
            ShortDescriptionLine1: "Channels Menu",
            ShortDescriptionLine2: "Watch smoothstreams channels"
            SDPosterUrl:"pkg:/images/TV.png",
            HDPosterUrl:"pkg:/images/TV.png"
        },
        {
            Title: "Schedule",
            ID: "3",           
            ShortDescriptionLine1: "Sports Schedule",
            ShortDescriptionLine2: "View future event schedule"
            SDPosterUrl:"pkg:/images/Calendar.png",
            HDPosterUrl:"pkg:/images/Calendar.png"
        }
    ]
    return contentList
End Function


