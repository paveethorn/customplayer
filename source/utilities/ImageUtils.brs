
function GetImageFromUrl(url,port = invalid) as object

    m.TextureManager =  CreateObject("roTextureManager")
    if (port <> invalid)
        m.TextureManager.SetMessagePort(port)
    end if
    
    request = CreateTextureRequest(url)
    
    m.TextureManager.RequestTexture(request)
    m.Request = request
    return request.GetID()

end function

function GetLocalTexture(url, sized = invalid)
    mgr =  CreateObject("roTextureManager")
    port = CreateObject("roMessagePort")
    mgr.SetMessagePort(port)
    
    request = CreateObject("roTextureRequest", url)
    request.SetAsync(True)
    request.SetScaleMode(1)

    if sized <> invalid
        request.SetSize(sized.w, sized.h)
    end if

    mgr.RequestTexture(request)   

    msg=wait(0, port)
    if type(msg)="roTextureRequestEvent" then
        state = msg.GetState()
        if state = 3 then            
            bitmap = msg.GetBitmap()
            if type(bitmap)<>"roBitmap" then
                print "Unable to create robitmap : "; url
            end if
            return bitmap       
        end if
    end if
    return invalid
end function

function GetScalableBitmap(bitmap)
    if (type(bitmap) = "roBitmap")
     region =CreateObject("roRegion", bitmap, 0, 0,bitmap.GetWidth(), bitmap.GetHeight()) 
     region.SetScaleMode(1)
    
     return region
    end if
    return invalid
end function 



function GetRemoteTexture(url,width = 280,height = 157)
    mgr =  CreateObject("roTextureManager")
    port = CreateObject("roMessagePort")
    mgr.SetMessagePort(port)
    

    request = CreateObject("roTextureRequest",url)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.InitClientCertificates()
    
    request.SetAsync(false)
    request.SetScaleMode(1)
    request.SetSize(width,height)
    'request.GetID()
    mgr.RequestTexture(request)   

    print "LoadBitmap"
        msg=wait(0, port)
        if type(msg)="roTextureRequestEvent" then

            state = msg.GetState()
            if state = 3 then            
                bitmap = msg.GetBitmap()
                print "GetBitmap : "; type(bitmap)
                if type(bitmap)<>"roBitmap" then
                    print "Unable to create robitmap : "; url                    
                end if
                return bitmap       
            end if
        end if
        return invalid
end function 


function CreateTextureRequest(url)
    request = CreateObject("roTextureRequest",url)
    request.SetAsync(true)
    
    header = m.base_auth_header + m.public_token
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Authorization", header)
    request.InitClientCertificates()
    return request
end function 

function CreateTextureManager(port)
    mgr =  CreateObject("roTextureManager")
    mgr.SetMessagePort(port)
    
end function

function CreateLocalTextureRequest(url,sized = invalid)
    request = CreateObject("roTextureRequest",url)
    request.SetAsync(true)
    request.SetScaleMode(1)   

    if sized <> invalid      
        request.SetSize(sized.w, sized.h)
    end if
   
    return request
end function


function GetImageFileName(fileName)
    path = strTokenize(fileName,"/")
    return path[path.Count()-1]
    
end function

Function AsyncGetImageFile(url,fileName,port)
    
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(port)
    request.SetUrl(url)
    header = m.base_auth_header + m.public_token
    
    'print header;
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Authorization", header)
    request.InitClientCertificates()
    
    request.AsyncGetToFile(filename)
    
    return request
    
End function

Function AsyncGetImage(url,port)
    
    request = CreateObject("roUrlTransfer")
    request.SetMessagePort(port)
    request.SetUrl(url)
    header = m.base_auth_header + m.public_token
    
    'print header;
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Authorization", header)
    request.InitClientCertificates()
    
    request.AsyncGetToString()
    
    return request
    
End function
