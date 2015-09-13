function CreateRectObject(targetRect = invalid,color = &hffffffff)
    this  = {}
    this.TargetRect = targetRect
    if (this.TargetRect = invalid)
        this.TargetRect = {}    
    end if   
    this.Color = color
    this.IsVisible = true    
    this.IsFocus = false
    this.Draw = function (screen)
        screen.DrawRect(m.TargetRect.x,m.TargetRect.y,m.TargetRect.w,m.TargetRect.h,m.Color)
    end function
    
    this.SetFocus = function (status)
        m.IsFocus = status
    end function
    
    this.GetWidth = function()
        return m.TargetRect.w
    end function
    
    this.GetHeight = function ()
        return m.TargetRect.h
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
    end function   
    
    return this 
end function