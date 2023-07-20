*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.NO.CUS.NAME
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.ST.LAPAP.OCC.CUSTOMER

    Y.CUS.NAME      = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",FM)
    Y.CUS.NAME            = Y.DATA<3>

    O.DATA                = Y.CUS.NAME

    RETURN

END
