SUBROUTINE LAPAP.NO.CUS.TIME
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER

    Y.HORA          = ""
    Y.MINUTOS       = ""
    Y.TIME          = ""
    Y.DATA          = O.DATA

    Y.HORA1          = Y.DATA[7,8]
    Y.HORA          = Y.HORA1[1,2]
    Y.MINUTOS       = Y.DATA[9,10]

    Y.TIME          = Y.HORA:":":Y.MINUTOS

    O.DATA          = Y.TIME

RETURN
END
