function smoothScheduleService(smoothservice_, smoothConfig_) as object
    
    scheduleJson = {}
    
    return{
        service: smoothservice_,
        scheduleJson: scheduleJson,
        channels: [],
        scheduleCategories: [],
        schedule: {},
        parseChannels: smoothScheduleService_channels,
        parseSchedule: smoothScheduleService_schedule,
        refresh: smoothScheduleService_refresh,
        buildChannelUrl: smoothScheduleService_buildChannelUrl,
        getIconUrl: smoothScheduleService_getIconUrl,
        config: smoothConfig_
    }
    
end function
    
    
function smoothScheduleService_channels() as object
    channels = []
    'stop
    for each channelKey in m.scheduleJson
        channel = m.scheduleJson[channelKey]
        channels.push({
            StreamBitrates : ["0"],
            StreamUrls : [m.buildChannelUrl(channel.channel_id)],
            StreamQualities : ["HD"],
            StreamFormat : "hls",
            Title : channel.name,
            HDPosterUrl : m.getIconUrl(channel.channel_id,""),
            SDPosterURL : m.getIconUrl(channel.channel_id,""),
            isHD : true,
            live : true,
            Id : channel.channel_id
        })   
    end for
    Sort(channels, returnId)
    return channels
end function

function smoothScheduleService_schedule()

    scheduleArray = {}
    
    ' Get current time as seconds for comparison with show times
    currTimeObject=CreateObject("roDateTime")
    currTimeObject.toLocalTime()
    currTime=currTimeObject.asSeconds()
    
    for each channelKey in m.scheduleJson
        channel = m.scheduleJson[channelKey]
        if channel.items <> invalid then
            for each programme in channel.items
                
                ' Convert show times to seconds
                showEndTime = convertDateSeconds(programme.end_time)
                showStartTime = convertDateSeconds(programme.time)
                 
                if currTime<showEndTime then
                    'Now showing
                    if currTime>showStartTime
                        m.channels[strToI(programme.channel)].shortDescriptionLine1 = "Now Showing"
                        m.channels[strToI(programme.channel)].shortDescriptionLine2 = programme.name
                    endif
                    ' Programme Associative Array    
                    programmeAA = {
                        StreamBitrates : ["0"],
                        StreamUrls : [m.buildChannelUrl(programme.channel)],
                        StreamQualities : ["HD"],
                        StreamFormat : "hls",
                        Title : programme.name,
                        Categories: programme.category,
                        Description: programme.description,
                        ShortDescriptionLine1: programme.name,
                        ShortDescriptionLine2: convertDate(programme.time),
                        HDPosterUrl : m.getIconUrl(programme.channel,programme.network),
                        SDPosterURL : m.getIconUrl(programme.channel,programme.network),
                        isHD : true,
                        live : true,
                        time: programme.time
                    }
                    
                    ' nested programmes under categories.
                    if NOT scheduleArray.DoesExist(programme.category) then
                       scheduleArray.AddReplace(programme.category,[programmeAA]) 
                    else
                        scheduleArray[programme.category].push(programmeAA)      
                    end if 
                end if 
            end for
        end if  
    end for
    
    ' Sort
    m.scheduleCategories.Clear()
    for each category in scheduleArray
        m.scheduleCategories.push(category)
        Sort(scheduleArray[category],returnDate)
    end for
    Sort(m.scheduleCategories)
    
    return scheduleArray
    
end function

function smoothScheduleService_buildChannelUrl(channelNumber) as string
    channelNumber = padNumber(channelNumber)
    ' some servers have port override
    if m.config.server().port <> invalid then
        port = m.config.server().port
    else
        port = m.config.site().port
    end if
    
    return "http://" + m.config.server().url + ":" + port + "/" + m.config.site().service + "/ch" + channelNumber + ".smil/playlist.m3u8?wmsAuthSign=" + m.service.loginResult.hash   
end function

function smoothScheduleService_refresh()
    m.scheduleJson = m.service.schedule()
    m.channels = m.parseChannels()
    m.schedule = m.parseSchedule()
    return m
end function
    
function smoothScheduleService_getIconUrl(channelNumber, network)
    POSTER_URL_PREFIX = "http://www.lyngsat-logo.com/logo/tv/"
    if network <> "" AND m.service.logos.DoesExist(network)
         return POSTER_URL_PREFIX + m.service.logos[network]
    else
         return POSTER_URL_PREFIX + m.service.logos["c" + channelNumber]   
    endif  
end function

    