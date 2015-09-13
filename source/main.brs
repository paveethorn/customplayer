Library "v30/bslCore.brs" 

sub main()
    Initialize()
    realScreen = CreateObject("roScreen",true)
    port = CreateObject("roMessagePort")
    realScreen.setAlphaEnable(true)
    realScreen.SetMessagePort(port)
    deviceInfo = CreateObject("roDeviceInfo")
    displaySize = deviceInfo.GetDisplaySize()
    realScreen.Clear(&h00000000)
    screen = CreateObject("roBitmap",{width: 1280,height:720, AlphaEnable : true })
    screen.Clear(&h00000000)
    realscreen.swapbuffers()
    player = CreateObject("roVideoPlayer")
    player.setMessagePort (port)
    
    playerSize = {
        x : 0
        y: 0
        width : 0
        height : 0
    }
      
    player.setDestinationRect(playerSize)
    player.SetPositionNotificationPeriod(1)
    codes = bslUniversalControlEventCodes()
    ' set guide index
    
    needRedraw = true
    
    player.setContentList(m.data)
    player.setNext(m.dataSelectedIndex)
    player.play()
    
    'Main ToolBar'
    toolBar = CreateRectObject({x:0,y:443,w:displaySize.w,h:displaySize.h},&h000000ee)
    isShowToolbar = false
    isShowGuide = false
    
    btnY = 612
    playbarSelectedIndex = 2
    playBarButtons = []
    stopButton = CreateImageObject("",{x:407,y: btnY,w:50,h:50})
    stopButton.Image = CreateRegionFromPath("pkg:/images/icon/stop.png")
    stopButton.ImagePress = CreateRegionFromPath("pkg:/images/iconpress/stop.png")
    
    rewindButton = CreateImageObject("",{x:512,y: btnY,w:50,h:50})
    rewindButton.Image = CreateRegionFromPath("pkg:/images/icon/rewind.png")
    rewindButton.ImagePress = CreateRegionFromPath("pkg:/images/iconpress/rewind.png")
    
    playPausePlaceHolder = CreateImageObject("",{x:615,y: btnY,w:50,h:50})
    
    pauseButton = CreateImageObject("",{x:615,y: btnY,w:50,h:50})
    pauseButton.Image = CreateRegionFromPath("pkg:/images/icon/pause.png")
    pauseButton.ImagePress = CreateRegionFromPath("pkg:/images/iconpress/pause.png")
    
    
    playButton = CreateImageObject("",{x:615,y: btnY,w:50,h:50})
    playButton.Image = CreateRegionFromPath("pkg:/images/icon/play.png")
    playButton.ImagePress = CreateRegionFromPath("pkg:/images/iconpress/play.png")
    
    ffButton = CreateImageObject("",{x:721,y: btnY,w:50,h:50})
    ffButton.Image = CreateRegionFromPath("pkg:/images/icon/FF.png")
    ffButton.ImagePress = CreateRegionFromPath("pkg:/images/iconpress/FF.png")
      
    playBarButtons.Push(stopButton)
    playBarButtons.Push(rewindButton)
    playBarButtons.Push(playPausePlaceHolder)
    playBarButtons.Push(ffButton)
    
    
    isCCEnable = false
    ccButton = CreateImageObject("",{x:860,y:btnY,w:50,h:50})
    ccButton.Image = CreateRegionFromPath("pkg:/images/icon/cc.png")
    
    ccButtonEnable = CreateImageObject("",{x:860,y:btnY,w:50,h:50})
    ccButtonEnable.Image = CreateRegionFromPath("pkg:/images/icon/ccEnable.png")
    
    playBarButtons.Push(ccButton)
    
    infoIcon = CreateImageObject("",{x:922,y:btnY,w:50,h:50})
    infoIcon.Image = CreateRegionFromPath("pkg:/images/icon/i.png") 
    playBarButtons.Push(infoIcon)
    
    ratingIcon = CreateImageObject("",{y:508,w:20,h:18})
    ratingIcon.Image = CreateRegionFromPath("pkg:/images/icon/rating.png")
    tomotoIcon = CreateImageObject("",{y:508,w:18,h:16})
    tomotoIcon.Image = CreateRegionFromPath("pkg:/images/icon/tomatoes.png")
    flixsterIcon = CreateImageObject("",{y:508,w:15,h:20})
    flixsterIcon.Image = CreateRegionFromPath("pkg:/images/icon/flixster.png")
    
    ratingIconSide = CreateImageObject("",{y:107,w:20,h:18})
    ratingIconSide.Image = CreateRegionFromPath("pkg:/images/icon/rating.png")
    tomotoIconSide = CreateImageObject("",{y:107,w:18,h:16})
    tomotoIconSide.Image = CreateRegionFromPath("pkg:/images/icon/tomatoes.png")
    flixsterIconSide = CreateImageObject("",{y:107,w:15,h:20})
    flixsterIconSide.Image = CreateRegionFromPath("pkg:/images/icon/flixster.png")
    
    isPress = false
    
    menuArrow = CreateTextObject("<",{x:129 ,y:629},m.FontList.Arrow,&h0091e5ff)
    menuText = CreateTextObject("Menu",{x:148 ,y:633},m.FontList.Regular,&hffffffff)
    
    guideArrow = CreateTextObject(">",{x:1129 ,y:629},m.FontList.Arrow,&h0091e5ff)
    guideText = CreateTextObject("Guide",{x:1080 ,y:633},m.FontList.Regular,&hffffffff)
    
    playerStatus = "stop"
    playDuration = 0
    playPosition = 0      
    
    IsSeeking = false
    seekMode = 0 ' -1 Rew, 0 normal, 1 FF 
    seekTimer = CreateObject("roTimeSpan")
    seekInterval = 500 'ms
    seekStep = 100 'sec'
    
    guideBarTimer = CreateObject("roTimeSpan")
    guideSideBar = CreateRectObject({x:703,y:0,w:displaySize.w - 703,h:displaySize.h},&h000000ee)
    timeText = CreateTextObject ("",{x:737,y:213},m.FontList.title,&hffffffff)
    
    onNowText= CreateTextObject ("ON NOW",{x:895,y:222},m.FontList.Regular,&h72829dff)
    
    filterText = CreateTextObject ("Filters",{x:902,y:635},m.FontList.Regular,&hffffffff)
    filterSign = CreateTextObject ("*",{x:959,y:635},m.FontList.Title,&h038fe2ff)
    
    fullGuideText = CreateTextObject ("Full Guide",{x:1042,y:635},m.FontList.Regular,&hffffffff)
    rightArrow = CreateTextObject (">",{x:1131,y:630},m.FontList.Arrow,&h038fe2ff)
    
    dataMenuFocus = 1
    isChannelFocus = true
    
    while (true)
        msg = port.GetMessage()
        if (msg <> invalid)
            if (type(msg) = "roVideoPlayerEvent")
                if (msg.isStreamStarted())
                    playerStatus = "start"
                else if (msg.isPaused())
                    playerStatus = "pause"
                else if (msg.isResumed())
                    playerStatus = "start"
                else if (msg.isFullResult())'                
                'print "Full Result"                    
                else if (msg.isPartialResult())
                    
                else if (msg.isPlaybackPosition())
                    playerStatus = "start"
                    playPosition = msg.GetIndex()
                    playDuration =  player.GetPlaybackDuration()
                                        
                else if (msg.isStatusMessage())
                    message = msg.GetMessage()
                    if (message = "end of stream")
                         playerStatus = "stop"
                    else if (message = "start of play")                        
                        playerStatus = "start"    
                    else if (message = "startup progress")
                        playerStatus = "start" 
                    else if (message = "playback stopped")  
                        playerStatus = "stop"
                    else if (message = "start of play")
                        playerStatus = "start"       
                    end if 
                end if 
                needRedraw = true 
            else if (type(msg) = "roUniversalControlEvent")
                c = msg.GetInt()
                if (c< 100)
                    if (isShowGuide)
                        if (c= codes.button_back_pressed)
                            isShowGuide = false
                        else if (c = codes.button_left_pressed)
                            if isChannelFocus
                                isShowGuide = false
                            else 
                                isChannelFocus = true
                            end if
                        else if (c = codes.button_right_pressed)
                            isChannelFocus = false
                        else if (c = codes.button_up_pressed)
                            if (dataMenuFocus > 0)
                                dataMenuFocus = dataMenuFocus - 1
                            end if
                        else if (c = codes.button_down_pressed)
                            if (dataMenuFocus < m.data.Count() - 1)
                                dataMenuFocus = dataMenuFocus + 1
                            end if
                        end if 
                    else if (isShowToolbar)
                        if (c = codes.button_left_pressed)                            
                            if (playbarSelectedIndex > 0)
                                playBarButtons[playbarSelectedIndex].SetFocus(false)
                                playbarSelectedIndex = playbarSelectedIndex - 1
                                playBarButtons[playbarSelectedIndex].SetFocus(true)
                            end if                            
                        else if (c = codes.button_right_pressed)
                            if (playbarSelectedIndex < playBarButtons.count() - 1)
                                playBarButtons[playbarSelectedIndex].SetFocus(false)
                                playbarSelectedIndex = playbarSelectedIndex + 1
                                playBarButtons[playbarSelectedIndex].SetFocus(true)
                            else if playbarSelectedIndex = playBarButtons.count() - 1
                                isShowGuide = true
                            end if
                        else if (c=codes.button_select_pressed)
                            playBarButtons[playbarSelectedIndex].SetPress(true)
                            m.cursor.SetPress(true)   
                            if playbarSelectedIndex = 0
                                player.stop()
                                playPosition = 0
                            else if playbarSelectedIndex = 1
                                if playerStatus = "start"
                                    player.Pause()
                                    isSeeking = true
                                    seekMode = -1 
                                    seekTimer.Mark()
                                end if
                            else if playbarSelectedIndex = 2
                                if playerStatus = "pause"
                                    player.Resume()
                                else if playerStatus = "stop"
                                    player.play()
                                else if playerStatus = "start"
                                    player.Pause()
                                end if
                            else if playbarSelectedIndex = 3
                                if playerStatus = "start"
                                    player.Pause()
                                    isSeeking = true
                                    seekMode = 1
                                    seekTimer.Mark()
                                end if
                            else if playbarSelectedIndex = 4
                                if isCCEnable = false
                                    isCCEnable = true
                                    playBarButtons[4] =  ccButtonEnable
                                else
                                   isCCEnable = false
                                    playBarButtons[4] =  ccButton
                                end if
                                
                            end if
                        else if (c=codes.button_rewind_pressed)
                                if playerStatus = "start"
                                    player.Pause()
                                    isSeeking = true
                                    seekMode = -1 
                                    seekTimer.Mark()
                                    playBarButtons[1].setFocus(true)
                                    playBarButtons[1].setPress(true)
                                    if playbarSelectedIndex = 1
                                        m.cursor.setFocus(true)
                                        m.cursor.setPress(true)
                                    end if
                                end if
                        else if (c=codes.button_fast_forward_pressed)
                                if playerStatus = "start"
                                    player.Pause()
                                    isSeeking = true
                                    seekMode = 1
                                    seekTimer.Mark()
                                    playBarButtons[3].setFocus(true)
                                    playBarButtons[3].setPress(true)
                                    if playbarSelectedIndex = 3
                                        m.cursor.setFocus(true)
                                        m.cursor.setPress(true)
                                    end if
                                end if
                        else if (c=codes.button_back_pressed)
                            isShowToolbar = false
                        end if           
                    else if (not isShowToolbar)
                        if (c = codes.button_back_pressed)                            
                            exit while
                        else
                            isShowToolbar = true    
                        end if 
                    end if                        
                else
                    'Release'
                    if (isShowGuide)
                    
                    else if (isShowToolbar)
                        if (c=codes.button_select_released)
                            playBarButtons[playbarSelectedIndex].SetPress(false)
                            m.cursor.SetPress(false)    
                            if (playbarSelectedIndex = 3) or (playbarSelectedIndex = 1)
                                if isSeeking
                                    isSeeking = false
                                    player.seek(PlayPosition * 1000)
                                end if
                            end if
                        else if (c=codes.button_rewind_released)
                            if isSeeking
                                isSeeking = false
                                player.seek(PlayPosition * 1000)
                                playBarButtons[1].setFocus(false)
                                playBarButtons[1].setPress(false)
                                if playbarSelectedIndex = 1
                                    m.cursor.setFocus(false)
                                    m.cursor.setPress(false)
                                end if
                            end if
                        else if (c=codes.button_fast_forward_released)
                            if isSeeking
                                isSeeking = false
                                player.seek(PlayPosition * 1000)
                                playBarButtons[3].setFocus(false)
                                playBarButtons[3].setPress(false)
                                if playbarSelectedIndex = 3
                                    m.cursor.setFocus(false)
                                    m.cursor.setPress(false)
                                end if
                            end if
                        end if     
                    end if
                end if      
                needRedraw = true          
            end if            
        end if
        
        if (isSeeking)
            if (seekTimer.TotalMilliSeconds() > seekInterval)
                seekTimer.Mark()
                playPosition = playPosition + (seekStep * seekMode)
                if playPosition < 0
                    playPosition = 0
                else if playPosition > playDuration
                    playPosition = playDuration    
                end if
                needRedraw = true
            end if            
        end if
        if isShowGuide
            if guideBarTimer.TotalSeconds() >=30
                guideBarTimer.Mark()
                needRedraw = true
            end if
        end if
        
        
        if (needRedraw)
            ' DrawObject
            screen.Clear(&h00000000)
            if isShowGuide
                guideSideBar.Draw(screen)
                now = CreateObject("roDateTime")
                now.toLocalTime()
                mins = now.getMinutes()
                minsText = "00"
                if mins < 10
                    minsText = "0" + mins.ToStr()
                else
                    minsText = mins.ToStr()
                end if
                
                timeText.Text = now.GetHours().tostr() + ":" + minsText
                timeText.Draw(screen)
                
                onNowText.Draw(screen)
                
                yMargin = 84
                xMargin = 10
                yLine = 251
                line = m.data.Count()
                
                firstColumnWidth = 149
                firstColumnTargetRect = {x:704,w:150,h:85}
                secondColumnTargetRect = {x:guideSideBar.targetRect.x + 150 + xMargin,w:417, h:85}
                for i = 0 to line
                    screen.DrawLine(guideSideBar.targetRect.x + 1,yLine,853,yLine,&h05293dff)
                    screen.DrawLine(guideSideBar.targetRect.x + 150 + xMargin,yLine,1280,yLine,&h05293dff)                                        
                    if i < m.data.Count()
                        
                        data = m.data[i]                        
                        if dataMenuFocus = i
                            if isChannelFocus
                                firstColumnTargetRect.y = yLine
                                DrawSelector(firstColumnTargetRect,screen)
                                largeLogo = CreateImageObject("", { w:data.Channel.Image.GetWidth() *2,h:data.Channel.Image.GetHeight() * 2})
                                largeLogo.Image = data.Channel.Image
                                largeLogo.AdjustCenterY(0,212)
                                largeLogo.TargetRect.x = 853 - largeLogo.TargetRect.w - 20
                                largeLogo.Draw(screen)
                                
                                sidedescriptionText = CreateTextObject(data.channel.description,{x:853,y:65,w:320},m.FontList.normal,&hffffffff)
                                sidedescriptionText.isMultiLine = true
                                sidedescriptionText.draw(screen)
                                
                            else
                                secondColumnTargetRect.y = yLine
                                DrawSelector(secondColumnTargetRect,screen)
                                
                                startX = 768
                                selectedData = data
                                seriesTitle = CreateTextObject(selectedData.SerieTitle,{x:startX,y:70},m.Fontlist.Title,&hffffffff)                            
                                seriesTitle.Draw(screen)
                                                                
                                episodeTitle = CreateTextObject(selectedData.Title ,{x:startX,y:106},m.Fontlist.Normal,&hffffffff)
                                episodeTitle.draw(screen)   
                                
                                startX = startX + episodeTitle.GetWidth() + 10
                            
                                
                                ratingIconSide.targetRect.x = startX         
                                ratingIconSide.draw(screen)       
                                startX = startX + ratingIcon.TargetRect.w + 5
                                
                                ratingText = CreateTextObject(selectedData.rating.name,{x:startX,y:106},m.Fontlist.DescriptionFont,&hbababaff)
                                ratingText.draw(screen)                
                                
                                startX = startX + ratingText.GetWidth() + 10
                                tomotoIconSide.targetRect.x = startX
                                tomotoIconSide.draw(screen)
                                
                                startX = startX + tomotoIcon.TargetRect.w + 5
                                
                                tomotoText = CreateTextObject(selectedData.rating.tomato.tostr() + "%",{x:startX,y:106},m.Fontlist.DescriptionFont,&hbababaff)
                                tomotoText.draw(screen)    
                                
                                startX = startX + tomotoText.GetWidth() + 10
                                
                                flixsterIconSide.targetRect.x = startX
                                flixsterIconSide.draw(screen)
                                
                                startX = startX + flixsterIcon.TargetRect.w + 5
                                
                                flixsterText = CreateTextObject(selectedData.rating.flixster.tostr() + "%",{x:startX,y:106},m.Fontlist.DescriptionFont,&hbababaff)
                                flixsterText.draw(screen)    
                                
                                descriptionText = CreateTextObject(selectedData.description,{x:768,y:132,w:400},m.Fontlist.DescriptionFont,&h8891a7ff)
                                descriptionText.isMultiline = true
                                descriptionText.draw(screen)
                              
                            end if
                        end if
                          
                        dataLogo = CreateImageObject("",{w: data.Channel.Image.GetWidth(),h: data.Channel.Image.GetHeight()})
                        dataLogo.Image = data.Channel.Image
                        dataLogo.AdjustCenterX (704,843)
                        dataLogo.AdjustCenterY (yLine + 1,yLine + yMargin)
                        dataLogo.Draw(screen)
                        startX = 895
                        textX = startX
                        if data.IsNew                            
                            newText = CreateTextObject("NEW",{x:startX,y:yLine + 18},m.Fontlist.Normal,&h0491eeff)
                            newText.draw(screen)
                            textX = textX + newText.GetWidth() + 10
                        end if
                        seriesListText = CreateTextObject(data.SerieTitle,{x:textX,y:yLine + 18},m.Fontlist.Normal,&hffffffff)
                        seriesListText.draw(screen)
                        
                        sideTimeStart = CreateTextObject(data.time.start + " - " + data.time.finish,{x:startX + 3,y:seriesListText.TargetRect.y + seriesListText.GetHeight() + 3},m.Fontlist.Normal,&h9a9aa0ff)
                        sideTimeStart.Draw(screen)
                        
                        if data.channel.IsFavorite <> invalid
                            favImage = CreateImageObject("",{x:811})
                            if data.channel.IsFavorite
                                favImage.Image = m.favImage.favorite
                            else
                                favImage.Image = m.favImage.unfavorite
                            end if
                            
                            favImage.targetrect.w = favImage.Image.getWidth()
                            favImage.targetrect.h = favImage.Image.getHeight() 
                            favImage.AdjustcenterY(yLine + 1, yLine+yMargin)
                            favImage.draw(screen)
                        end if
                    end if                    
                    yLine = yLine + yMargin
                end for 
                
                filterText.draw(screen)
                filterSign.draw(screen)
                fullGuideText.draw(screen)
                rightArrow.draw(screen)
                
            else if isShowToolbar
                toolBar.draw(screen)
                index = 0
                selectedData = m.data[m.dataSelectedIndex]
                
                seriesTitle = CreateTextObject(selectedData.SerieTitle,{x:129,y:471},m.Fontlist.Title,&hffffffff)
                seriesTitle.Draw(screen)
                
                startX = 130
                if selectedData.IsNew
                    newText = CreateTextObject("NEW",{x:startX,y:505},m.Fontlist.Normal,&h0491eeff)
                    newText.draw(screen)
                    startX = startX + newText.GetWidth() + 10
                end if
                
                episodeTitle = CreateTextObject(selectedData.Title + " " + "(S" + selectedData.seasonNumber.tostr() + " E" + selectedData.episodeNumber.tostr()  + ")",{x:startX,y:505},m.Fontlist.Normal,&hffffffff)
                episodeTitle.draw(screen)   
                
                startX = startX + episodeTitle.GetWidth() + 10
                country = CreateTextObject(selectedData.country,{x:startX,y:505},m.Fontlist.Regular,&hbababaff)
                country.draw(screen)
                
                startX = startX + country.GetWidth() + 20
                
                ratingIcon.targetRect.x = startX         
                ratingIcon.draw(screen)       
                startX = startX + ratingIcon.TargetRect.w + 5
                
                ratingText = CreateTextObject(selectedData.rating.name,{x:startX,y:505},m.Fontlist.DescriptionFont,&hbababaff)
                ratingText.draw(screen)                
                
                startX = startX + ratingText.GetWidth() + 10
                tomotoIcon.targetRect.x = startX
                tomotoIcon.draw(screen)
                
                startX = startX + tomotoIcon.TargetRect.w + 5
                
                tomotoText = CreateTextObject(selectedData.rating.tomato.tostr() + "%",{x:startX,y:505},m.Fontlist.DescriptionFont,&hbababaff)
                tomotoText.draw(screen)    
                
                startX = startX + tomotoText.GetWidth() + 10
                
                flixsterIcon.targetRect.x = startX
                flixsterIcon.draw(screen)
                
                startX = startX + flixsterIcon.TargetRect.w + 5
                
                flixsterText = CreateTextObject(selectedData.rating.flixster.tostr() + "%",{x:startX,y:505},m.Fontlist.DescriptionFont,&hbababaff)
                flixsterText.draw(screen)    
                
                descriptionText = CreateTextObject(selectedData.description,{x:129,y:532},m.Fontlist.DescriptionFont,&h8891a7ff)
                descriptionText.draw(screen)    
                
                menuArrow.draw(screen)
                MenuText.draw(screen)
                
                guideArrow.draw(screen)
                guideText.draw(screen)
                                
                DrawSeekBar(selectedData.time.start,selectedData.time.finish,0,screen,playPosition,playDuration,isSeeking)   
                
                if playerStatus = "start"
                    pauseButton.SetPress(playPausePlaceHolder.isPress)
                    pauseButton.SetFocus(playPausePlaceHolder.isFocus)
                    playPausePlaceHolder.image = pauseButton.Image
                    playPausePlaceHolder.imagepress = pauseButton.ImagePress
                    playButton.setFocus(false)
                    playButton.setPress(false)
                          
                else
                    playButton.SetPress(playPausePlaceHolder.isPress)
                    playButton.SetFocus(playPausePlaceHolder.isFocus)
                    playPausePlaceHolder.image = playButton.Image
                    playPausePlaceHolder.imagepress = playButton.ImagePress
                    pauseButton.setFocus(false)
                    pauseButton.setPress(false)
                end if
                     
                for each btn in playBarButtons
                    btn.draw(screen)
                    if playbarSelectedIndex = index
                        m.cursor.targetRect.x = btn.targetRect.x 
                        m.cursor.targetRect.y = btn.targetRect.y
                        m.cursor.draw(screen)
                    end if
                    index = index + 1 
                end for
            end if
            realScreen.Clear(&h00000000)
            realscreen.DrawScaledObject(0,0,displaySize.w/screen.GetWidth(),displaySize.h/screen.getHeight(),screen)
            
            
            realscreen.swapbuffers()
            needRedraw = false
        end if
        
    end while
    
    print " End "
end sub

function Initialize()
    print "App initialize"
    
    m.cursor = CreateImageObject("",{w:50,h:50})
    m.cursor.Image = CreateRegionFromPath("pkg:/images/cursor/normal.png")
    m.cursor.ImagePress = CreateRegionFromPath("pkg:/images/cursor/press.png")
    m.cursor.IsFocus = true
    
    m.FontList = {}
    m.FontRegistry = CreateObject("roFontRegistry")
    m.fontRegistry.Register("pkg:/font/DINPro-Regular.ttf")
    m.fontRegistry.Register("pkg:/font/DINPro-Light.ttf")
    m.fontRegistry.Register("pkg:/font/DIN Medium.ttf")
    m.fontRegistry.Register("pkg:/font/DINPro-Medium.ttf")
    
    m.favImage ={
        favorite: CreateRegionFromPath("pkg:/images/icon/favourite.png")
        unfavorite: CreateRegionFromPath("pkg:/images/icon/unfavourite.png")
    }
    
    defaultFontName = "DINPro-Medium"
    regularFontName = "DINPro-Regular"
    mediumFontName = "DINPro-Medium"
    boldFontName = "DIN-Bold"
    
    m.FontList.Title = m.FontRegistry.GetFont(defaultFontName,25,false,false)
    m.FontList.Normal = m.FontRegistry.GetFont(defaultFontName,18,false,false)
    m.FontList.DescriptionFont = m.FontRegistry.GetFont(regularFontName,16,false,false)
    
    m.Fontlist.Regular = m.FontRegistry.GetFont(regularFontName,18,false,false)
    m.Fontlist.Arrow = m.FontRegistry.GetFont(regularFontName,22,false,false)
    m.Fontlist.SmallText = m.FontRegistry.GetFont(regularFontName,14,false,false)
    
    
    m.data = ParseJson(ReadAsciiFile("pkg:/data/guide.json"))
    m.dataSelectedIndex = 1
    for each d in m.data
        d.Channel.Image = CreateRegionFromPath(d.Channel.Logo)
    end for 
        
end function

