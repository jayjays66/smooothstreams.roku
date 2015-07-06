Sub Main()
    ' Line for testing new user
    'CreateObject("roRegistry").Delete("Default")
    m.service = smoothService()
    m.config = smoothConfig(m.service)
    m.scheduleService = smoothScheduleService(m.service, m.config)
    InitTheme()
    facade = CreateObject("roParagraphScreen")
    facade.Show()
    
    loginMainMenu()
        
End Sub

function loginMainMenu()
    ' Attempt show config screen until login is succesfull
    loginScreen = smoothLoginScreen()
    regSection = CreateObject("roRegistrySection", "Default")
    while (NOT loginScreen.setup().show().loginResult)
        if regSection.Exists("Username")
            errorDialog = smoothErrorDialog()
            errorDialog.errors = loginScreen.errors
            errorDialog.setup().show().eventLoop()
        end if
        smoothConfigScreen().setup().show().eventLoop() 
    end while
    smoothMainMenu().setup().show().eventLoop()
end function

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