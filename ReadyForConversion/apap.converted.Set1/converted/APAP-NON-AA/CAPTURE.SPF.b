PROGRAM CAPTURE.SPF

    $INSERT I_COMMON
    $INSERT I_EQUATE

    SEL.CMD = "LIST F.SPF"
    OPEN "TAM.BP" TO F.TAM THEN
        K.VAR = 1
    END

    EXECUTE SEL.CMD CAPTURING SEL.RET

    WRITE SEL.RET TO F.TAM,"CURRENT.SPF" ON ERROR
        K.VAR = -1
    END

END
