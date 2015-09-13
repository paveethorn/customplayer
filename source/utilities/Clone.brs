
function Clone(v as object) as object
        v = box(v)
        vType = type(v)
        if     vType = "roArray"
                n = CreateObject(vType, v.count(), true)
                for each sv in v
                        n.push(Clone(sv))
                end for
        else if vType = "roList"
                n = CreateObject(vType)
                for each sv in v
                        n.push(Clone(sv))
                end for
        else if vType = "roAssociativeArray"
                n = CreateObject(vType)
                for each k in v
                        n[k] = Clone(v[k])
                end for
        else if vType = "roByteArray"
                n = CreateObject(vType)
                n.fromHexString( v.toHexString() )
        else if vType = "roXMLElement"
                n = CreateObject(vType)
                n.parse( v.genXML(true) )
        else if vType = "roInt" or vType = "roFloat" or vType = "roString" or vType = "roBoolean" or vType = "roFunction" or vType = "roInvalid"
                n = v
        else
                'print "skipping deep copy of component type "+vType
                n = invalid
                'n = v
        end if
        return n
end function