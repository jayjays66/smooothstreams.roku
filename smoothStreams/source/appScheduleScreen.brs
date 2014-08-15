Function showScheduleScreen() as void
     port = CreateObject("roMessagePort")
     poster = CreateObject("roPosterScreen")
     poster.SetBreadcrumbText ("Main Menu", "Schedule")
     poster.SetMessagePort(port)
     poster.SetListNames(m.categoryArray)
     poster.SetContentList(m.categoryAsArray[m.categoryArray[0]])
     poster.SetListStyle("flat-episodic")
     poster.SetListDisplayMode("scale-to-fit")
     poster.Show() 
     While True
         msg = wait(0, port)
         If msg.isScreenClosed() Then
             return
         Else If msg.isListItemSelected()
             'print "msg: ";msg.GetMessage();"idx: ";msg.GetIndex()
             showVideo(m.categoryAsArray[currList][msg.GetIndex()])
         Else If msg.isListFocused()
             'print "msg: ";msg.GetMessage();"idx: ";msg.GetIndex()
             currList=m.categoryArray[msg.GetIndex()]
             'print currList
             'print m.categoryAsArray[currList]
             poster.SetContentList(m.categoryAsArray[currList])
             poster.SetFocusedListItem(0)
         End If
     End While
End Function