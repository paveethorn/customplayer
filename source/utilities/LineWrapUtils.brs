function CreateLineWrapTextObj (textObj)
        textArray = LineWrapText(textObj.Text,textObj.TargetRect.w,textObj.Font)   
        maxWidth = textObj.TargetRect.w
        'print textObj.Font
        needElipsis = false
        numLines = textArray.Count()
        if numLines > textObj.MaxLine 
            numLines = textObj.MaxLine
            needElipsis = true
        end if
        
        rectY = textObj.TargetRect.y
        if textObj.IsCenterPosition
            totalHeight = (textObj.Font.GetOneLineHeight() + textObj.LineSpacing)  * numLines - textObj.LineSpacing
            rectY = rectY - int(totalHeight/2)
        end if
        
        
        allTextObj = CreateObject("roArray",numLines,true)
        lineHeight = 0
        
        
       for i = 0 to numLines-1               
            TargetRect = CreateObject("roAssociativeArray")
            TargetRect = { x: textObj.TargetRect.x
                           y: rectY + lineHeight
                           w: textObj.TargetRect.w
                           h: textObj.TargetRect.h                                      
            }            
            
            'print "Generate Wrapped Text"
            allTextObj[i] = InitTextObject(textArray[i],TargetRect,"",false,textObj.Font)            
            allTextObj[i].Color = textObj.Color
            
            
            obj = allTextObj[i]
            lineHeight = lineHeight + textObj.Font.GetOneLineHeight() + textObj.LineSpacing  
       end for 
       
       if (allTextObj.Count() > 0) and (textObj.IsNeedElipsis)
           charIndex = 0
           lastTextObj = allTextObj[allTextObj.Count()-1]           
           txtLength = len(lastTextObj.Text)
           while (needElipsis)
                lineStr = left (lastTextObj.Text,txtLength -charIndex)
                lineStr = lineStr + "..."
                
                if (lastTextObj.Font.GetOneLineWidth(lineStr,maxWidth+1) <= maxWidth)
                    needElipsis = false
                    lastTextObj.Text = lineStr
                end if 
                
                
                charIndex = charIndex + 1 
           end while
       end if
       
       return allTextObj
end function 





function LineWrapText (text,maxWidth,font)    
    textStr = CreateObject ("roString")
    if (text = invalid)
        text = ""
    end if
    textStr.SetString(text)
    tokenizeStr = " " 
    strList = CreateObject("roList")
    textStr = strReplace(textStr,chr(10)," ")
    strList = textStr.Tokenize(" ")
    
    strList.Reset()
    lineWidth = 0
    lineIndex = 0
    allStrLine= CreateObject ("roArray",0,true)
    wordIndex = 0
    
    if strList.Count() > 0 
        tempW = font.GetOneLineWidth (strList[0],1280)
        if tempW > maxWidth
            strt = strList[0]
            while (font.GetOneLineWidth (strt,1280)>maxWidth)
                strt = left(strt,len(strt) - 2)    
            end while
            allStrLine.Push(strt)        
            
        else
            while (strList.IsNext())
                strt = strList.Next()   
                strc = strt
               wordWidth=0
                      
                if (wordIndex > 0)
                    strc = " " + strt
                    wordWidth = font.GetOneLineWidth(strc,maxWidth)            
                    lineWidth = lineWidth + font.GetOneLineWidth(strc,wordWidth)   
                else    
                    wordWidth = font.GetOneLineWidth(strc,maxWidth)
                    lineWidth = lineWidth + font.GetOneLineWidth(strc,wordWidth)   
                end if       
                wordIndex = wordIndex + 1   
                
                
                if (lineWidth >= maxWidth)
                   lineWidth = wordWidth
                   lineIndex = lineIndex+1
                   allStrLine.Push(strt)   
                else
                    if allStrLine[lineIndex] = invalid
                        allStrLine.Push(strt)
                    else
                        allStrLine[lineIndex] = allStrLine[lineIndex] + " " + strt
                    end if
                   
                end if 
            end while
        end if
    end if
    
    return allStrLine
End Function