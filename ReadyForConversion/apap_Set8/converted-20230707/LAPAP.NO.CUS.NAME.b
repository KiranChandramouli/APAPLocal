SUBROUTINE LAPAP.NO.CUS.NAME
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER

    Y.CUS.NAME      = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",@FM)
    Y.CUS.NAME            = Y.DATA<3>

    O.DATA                = Y.CUS.NAME

RETURN

END
