function CreateTextObject(text,targetRect = invalid,font = invalid,color = &hffffffff)
    this  = {}
    this.TargetRect = targetRect
    if (this.TargetRect = invalid)
        this.TargetRect = {}    
    end if
    this.Text = text
    this.Font = font
    if (font = invalid)
        this.Font = m.FontList.DefaultFont  
    end if  
    this.Color = color
    this.IsVisible = true    
    this.IsFocus = false
    this.IsAllPassword = false
    this.IsPassword = false
    this.PasswordChar = "*"
    this.IsElipses = false
    ' Property for Line Wrapping
    this.MaxLine = 3
    this.IsMultiLine = false
    this.IsLimitWidth = false
    this.LineMargin = 3
    this.TotalLineCount = 0
    
    this.LineDraw = 0
    this.Draw = function (screen)
        if (m.IsVisible)
            if (m.IsAllPassword)
                text = String(len(m.Text), m.PasswordChar)        
            else if (m.IsPassword)
                text = String(len(m.Text)-1, m.PasswordChar)
                text = text +  Right(m.Text,1)
            else
                text = m.text
            end if
            
            if (m.IsMultiLine ) and (m.Targetrect.Lookupci("w") <> invalid)   
               textArray = LineWrapText (text,m.TargetRect.w,m.font)
               m.TotalLineCount = textArray.Count()
               ypoint = m.TargetRect.y
               lineCount = textArray.Count() 
               
               putElipses = m.IsElipses
               
               if (m.MaxLine < textArray.Count() )
                    lineCount = m.MaxLine
               else 
                    putElipses = false     
               end if
               m.LineDraw = lineCount
                            
               for i = 0 to lineCount-1
                    text = textArray[i]
                    if (i = lineCount - 1) and (putElipses)
                        originalText = text
                        text = originalText + " ..."
                        while (m.Font.GetOneLineWidth(text,m.targetRect.w + 1) > m.targetRect.w)
                            originalText = Left(originalText,len(originalText) - 1)
                            text = originalText + " ..."  
                        end while
                    end if
                    screen.DrawText(text,m.TargetRect.x,ypoint,m.Color,m.Font)
                    ypoint = ypoint + m.GetHeight() + m.LineMargin
               end for
               
            else if (m.IsLimitWidth)
                textToDraw = ""            
                if (m.Font.GetOneLineWidth(text,1280) <= m.targetRect.w )
                    textToDraw = text
                else
                    for i = len(text) to 0 step -1
                       textToDraw = right(text,i)
                       if (m.Font.GetOneLineWidth(textToDraw,1280) <= m.targetRect.w )
                            exit for     
                       end if          
                    end for            
                end if           
                screen.DrawText(textToDraw,m.TargetRect.x,m.TargetRect.y,m.Color,m.Font) 
            else 
               ' screen.DrawText(Text,m.TargetRect.x,m.TargetRect.y+2,m.Color,m.Font) ' Font Din Medium
               
            
                screen.DrawText(Text,m.TargetRect.x,m.TargetRect.y,m.Color,m.Font) ' Font DinPro-Medium '
            end if
        end if
    end function
    
    this.GetStringPasswordChar = function()
        pwdChar = ""
        for i = 0 to len(m.Text) - 1
            pwdChar = pwdChar + m.PasswordChar
        end for
        return pwdChar
        
    end function
    
    this.SetFocus = function (status)
        m.IsFocus = status
    end function
    
    this.GetWidth = function()
        width = 1280
        if (m.TargetRect.Lookupci("w") <> invalid)
            width = m.TargetRect.w
        end if
        if (m.IsPassword)
            text = String(len(m.Text), m.PasswordChar)
        else
            text = m.text
        end if
        return m.font.GetOneLineWidth(text,width)
    end function
    
    this.GetHeight = function ()
        return m.Font.GetOneLineHeight()
    end function 
    
    this.AdjustCenterX = function (p1 = 0 ,p2 = 1280)
        if (p1>p2)
            p3 = p2
            p2 = p1
            p1 = p3
        end if    
        m.TargetRect.x = p1 + ((p2-p1) - m.GetWidth())/2
    end function
    
    this.AdjustCenterY = function (p1 = 0 ,p2 = 720)
        if (p1>p2)
            p3 = p2
            p2 = p1
            p1 = p3
        end if
        m.TargetRect.y = p1 + ((p2-p1) - m.GetHeight())/2
        if (m.IsPassword)
        
        end if
    end function
    
    this.GetTotalLineCount = function ()
        return m.TotalLineCount
    end function
    
    return this 
end function