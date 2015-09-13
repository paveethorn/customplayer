function DrawLogo(screen)    
    screen.DrawScaledObject(100,60,1,1, m.Logo)
end function

function DrawBorder(screen,targetRect,size = 3,color = &h00adefff)
    bMargin = 3
    'Draw Blue border'
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y-size-bMargin,targetRect.w + 2*(size+bMargin),size,color) ' Draw Top Border
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y + targetRect.h + bMargin,targetRect.w + 2*(size + bMargin),size,color) ' Draw Bottom Border
    
    screen.DrawRect(targetRect.x-size-bMargin,targetRect.y-bMargin,size,targetRect.h+ 2*bMargin,color) ' Draw Left Border
    screen.DrawRect(targetRect.x+targetRect.w+bMargin,targetRect.y - bMargin,size,targetRect.h + 2*bMargin,color)
    
    insideColor = &h000000ff
    'Draw Back Border in side the Blue border'    
    screen.DrawRect(targetRect.x-bMargin,targetRect.y-bMargin,targetRect.w + 2*(bMargin),bMargin,insideColor) ' Draw Top Border
    screen.DrawRect(targetRect.x-bMargin,targetRect.y + targetRect.h,targetRect.w + 2*(bMargin),bMargin,insideColor) ' Draw Bottom Border
    
    screen.DrawRect(targetRect.x-bMargin,targetRect.y-bMargin,bMargin,targetRect.h+ 2*bMargin,insideColor) ' Draw Left Border
    screen.DrawRect(targetRect.x+targetRect.w,targetRect.y - bMargin,bMargin,targetRect.h + 2*bMargin,insideColor)
    
    
    
end function