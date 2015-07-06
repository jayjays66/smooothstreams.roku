function smoothLoginScreen() as object
    
    screen = CreateObject("roOneLineDialog")
    port = CreateObject("roMessagePort")
    loginResult = false
       
    return {
        screen: screen,
        port: port,
        service: GetGlobalAA().service,
        config: GetGlobalAA().config,
        setup: smoothLoginScreen_setup,
        show: smoothLoginScreen_show,
        loginResult:  loginResult,
        errors:[]   
    }
        
end function

function smoothLoginScreen_setup()
    m.screen.SetMessagePort(m.port)
    m.screen.SetTitle("Logging in to " + m.config.site().name)
    m.screen.ShowBusyAnimation()
    return m
end function

function smoothLoginScreen_show()
    m.errors.Clear()
    m.screen.show()
    ' check valid server and site first
    m.config.validate()
    
    if m.config.configErrors.Count() > 0 then
        m.loginResult = false
        m.errors.Append(m.config.configErrors)
        return m
    end if
    m.service.login(m.config.username.GET(),m.config.password.GET(),m.config.site().service)
    if m.service.loginResult = invalid or m.service.loginResult.error <> invalid then
        'error logging in
        m.loginResult = false
        m.errors.Push(m.service.loginResult)
        return m
    end if
    m.loginResult = true
    m.screen.close()
    return m
end function