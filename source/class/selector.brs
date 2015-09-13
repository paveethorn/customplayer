function DrawSelector(targetRect,screen)
    bMargin = -3
    size = 3
    color = &hfdb131ff
    screen.DrawRect (targetRect.x,targetRect.y,targetRect.w,targetRect.h,&hfdb13122)
    
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y-size-bMargin,targetRect.w + 2*(size+bMargin),size,color) ' Draw Top Border
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y + targetRect.h + bMargin,targetRect.w + 2*(size + bMargin),size,color) ' Draw Bottom Border
    
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y-bMargin,size,targetRect.h+ 2*bMargin,color) ' Draw Left Border
    screen.DrawRect(targetRect.x+targetRect.w+bMargin,targetRect.y - bMargin,size,targetRect.h + 2*bMargin,color)  
    
end function