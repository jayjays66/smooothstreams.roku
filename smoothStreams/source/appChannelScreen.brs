Function showChannelList() as void
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetBreadcrumbText("Menu","Channels")
    screen.SetContent(m.channelArray)
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemSelected())
                showVideo(m.channelArray[msg.GetIndex()])
            else if msg.isScreenClosed() then
                return
            endif      
        endif
    end while
End Function

Function showVideo(channel) as void
    'print "Displaying video: "
    'print channel.StreamUrls
    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)
    video.SetContent(channel)
    video.show()
    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                'print "Closing video screen"
                exit while
            else if msg.isPlaybackPosition() then
            else if msg.isRequestFailed()
                'print "play failed: "; msg.GetMessage()
            else
                'print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while
end function
