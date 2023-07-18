*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.NO.CUS.IDEN.TIPE
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.ST.LAPAP.OCC.CUSTOMER

    Y.IDEN.TYPE     = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",FM)
    Y.IDEN.TYPE           = Y.DATA<1>

    O.DATA                = Y.IDEN.TYPE

    RETURN

END
