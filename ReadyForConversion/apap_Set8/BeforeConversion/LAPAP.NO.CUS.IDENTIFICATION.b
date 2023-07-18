*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.NO.CUS.IDENTIFICATION
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.ST.LAPAP.OCC.CUSTOMER

    Y.IDEN.ID     = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",FM)
    Y.IDEN.ID           = Y.DATA<2>

    O.DATA                = Y.IDEN.ID

    RETURN

END
