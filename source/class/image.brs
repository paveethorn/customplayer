function CreateRegionFromPath(path)
    bitmap = CreateObject("roBitmap",path)
    if bitmap <> invalid
        region = CreateObject("roRegion",bitmap,0,0,bitmap.GetWidth(),bitmap.GetHeight())
        region.SetScaleMode(1)
        return region
    end if
    return invalid    
end function

function CreateImageObject(url,targetRect)
    this = {}
    this.TargetRect = targetRect
    this.ImageUrl = url
    this.Image = invalid
    this.ImagePress = invalid
    this.ImageFocus= invalid
    this.IsVisible = true
    this.IsFocus = false
    this.IsPress = false    
    this.GetWidth = function ()
        return m.TargetRect.w
    end function
    
    this.GetHeight = function ()
        return m.TargetRect.h
    end function    
    
    this.SetFocus = function (status)
        m.IsFocus = status        
    end function
    
    this.SetPress = function(status)
        m.IsPress = status
    end function
    
    this.ResetSize = function ()
        if (m.Image <> invalid)
            m.TargetRect.w = m.Image.GetWidth() 
            m.TargetRect.h = m.Image.GetHeight()
        end if
    end function
    
    this.RenderFocus = invalid
    
    this.Draw = function (screen)
         if (m.IsVisible)
            image = m.Image 
            if m.IsFocus
                if m.IsPress and m.ImagePress <> invalid 
                    image = m.ImagePress
                else if m.ImageFocus <> invalid
                    image = m.ImageFocus
                end if
            end if
            if (image <> invalid)            
                scaleX = m.TargetRect.w/image.GetWidth()
                scaleY = m.TargetRect.h/image.GetHeight()
                screen.DrawScaledObject(m.TargetRect.x,m.TargetRect.y,scaleX,scaleY,image)
                if (m.RenderFocus <> invalid)
                    m.RenderFocus(screen)
                end if      
                return true   
            end if
         end if       
         return false    
    end function
    
    
    
    this.AdjustCenterX = adjust_center_x
    
    this.AdjustCenterY = adjust_center_y
        
    
    
    return this
end function

function adjust_center_x(p1 = 0 ,p2 = 1280)
        if (p1>p2)
            p3 = p2
            p2 = p1
            p1 = p3
        end if    
        m.TargetRect.x = p1 + ((p2-p1) - m.TargetRect.w)/2
    
end function

function adjust_center_y(p1 = 0 ,p2 = 720)     
    if (p1>p2)
        p3 = p2
        p2 = p1
        p1 = p3
    end if
    m.TargetRect.y = p1 + ((p2-p1) - m.TargetRect.h)/2
end function