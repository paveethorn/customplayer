function DrawSeekBar(startTime,endTime,position,screen,playPosition,playDuration,isSeeking)
    
    cursor = CreateRectObject({x:200,y:584,w:5,h:5},&hffffffff)
    
    dateTime = CreateObject("roDateTime")
    dateTime.FromISO8601String("2015-09-13 11:00:00")
    dateSec = dateTime.AsSeconds()
    dateSec = dateSec + playPosition
    
    dateTime.fromSeconds(dateSec)
    
    min = dateTime.GetMinutes()
    if min < 10
        minText = "0" + min.tostr()
    else
        minText = min.tostr()  
    end if
    dateStr = dateTime.GetHours().tostr() + ":" + minText
        
    start = CreateTextObject(startTime,{x:129,y:575},m.FontList.DescriptionFont,&hbababaff)    
    start.Draw(screen)
    
    endText = CreateTextObject(endTime,{x:1102,y:575},m.FontList.DescriptionFont,&hbababaff)    
    endText.Draw(screen)
    
    x = 200
    y = 584
    width = 891
    height = 5
    barMargin = 5
    split = 4
    cursorX = x
    if playDuration <> 0         
        cursorX = int(x + (playPosition / playDuration * width))
        if (isSeeking)
            dateTextObj = CreateTextObject(dateStr,{y:560,w:500},m.FontList.SmallText,&hffffffff)
            dateTextObj.TargetRect.x = cursorX - int(dateTextObj.GetWidth()/2)
            dateTextObj.Draw(screen)
        end if
    end if
    cursor.TargetRect.x = cursorX
    
    barWidth = (width-(split-1)*barMargin) / split
    
    widthAccu = 0
    for i = 1 to split
        screen.DrawRect(x,y,barWidth,height,&h2e3f49ff)
        x = x + barWidth + barMargin
    end for 
    x = 200
    for i = 1 to split
        if (cursorX-x > barWidth)
            screen.DrawRect(x,y,barWidth,height,&hffa300ff)
        else if cursorX-x > 0
            newBarwidth = cursorX-x
            screen.DrawRect(x,y,newBarwidth,height,&hffa300ff)
        end if
            
        x = x + barWidth + barMargin
    end for
    
    
    cursor.Draw(screen)
    
end function    