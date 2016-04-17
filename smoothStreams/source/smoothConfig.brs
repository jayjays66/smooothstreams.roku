function smoothConfig(smoothservice_) as object
    
    constants = {
        INVALID_SITE_ERROR_MSG: "The site you have selected is not valid, please select an alternative",
        INVALID_SERVER_ERROR_MSG: "The location you have selected is not valid, please select an alternative"
    } 
    
    
    return{
        constants: constants,
        location: {GET: smoothConfig_getLocation, SET: smoothConfig_setLocation},
        username: {GET: smoothConfig_getUsername, SET: smoothConfig_setUsername},
        password: {GET: smoothConfig_getPassword, SET: smoothConfig_setPassword},
        service: {GET: smoothConfig_getService, SET: smoothConfig_setService},
        quality: {GET: smoothConfig_getQuality, SET: smoothConfig_setQuality}
        site: smoothConfig_getSite,
        server: smoothConfig_getServer,
        validate : smoothConfig_validate,
        configErrors: [],
        smoothService_: smoothService_  
    }
    
end function
    
    
function smoothConfig_getLocation() as string
    return RegRead("Server Location")
end function
    
function smoothConfig_setLocation(location as string)
    RegWrite("Server Location", location)
    return m
end function
    
function smoothConfig_getUsername() as string
    return RegRead("Username")
end function
    
function smoothConfig_setUsername(username as string)
    RegWrite("Username", username)
    return m
end function
    
function smoothConfig_getPassword() as string
    return RegRead("Password")
end function

function smoothConfig_setPassword(password as string)
    RegWrite("Password", password)
    return m
end function

function smoothConfig_getService() as string
    return RegRead("Service")
end function

function smoothConfig_setService(service as string)
    RegWrite("Service", service)
    return m
end function

function smoothConfig_getSite()
    if m.smoothService_.sites.DoesExist(m.service.GET()) then
        return m.smoothservice_.sites[m.service.GET()]
    else
        return {name:""}
    end if  
end function

function smoothConfig_getServer()
    if m.smoothService_.servers.DoesExist(m.location.GET()) then
        return m.smoothservice_.servers[m.location.GET()]
    else
        return {name:""}
    end if  
end function

function smoothConfig_getQuality() as string
    if RegRead("Quality") = invalid then
        smoothConfig_setQuality("q1")
    end if
    return RegRead("Quality")
        
end function
    
function smoothConfig_setQuality(quality as string)
    RegWrite("Quality", quality)
    return m
end function

function smoothConfig_validate()
    m.configErrors.Clear()
    if not m.smoothService_.sites.DoesExist(m.service.GET()) then
        m.configErrors.push({error: m.constants.INVALID_SITE_ERROR_MSG})
    end if  
    if not m.smoothService_.servers.DoesExist(m.location.GET()) then
        m.configErrors.push({error: m.constants.INVALID_SERVER_ERROR_MSG})
    end if  
end function
    

