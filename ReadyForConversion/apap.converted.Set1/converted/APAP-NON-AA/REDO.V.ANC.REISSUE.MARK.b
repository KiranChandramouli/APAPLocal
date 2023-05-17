SUBROUTINE REDO.V.ANC.REISSUE.MARK
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: KAVITHA
* PROGRAM NAME: REDO.V.ANC.REISSUE.MARK
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is authorisation routine to update LATAM CARD ORDER
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10 JUN 2011   KAVITHA       PACS00079591       FIX
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.LATAM.CARD.ORDER


    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)



    GET.CARD.STATUS = R.NEW(CARD.IS.CARD.STATUS)
    OLD.CARD.STATUS = R.OLD(CARD.IS.CARD.STATUS)

    IF GET.CARD.STATUS EQ 90 AND OLD.CARD.STATUS EQ 92 THEN
        R.NEW(CARD.IS.ISSUE.NUMBER) = ''
        R.NEW(CARD.IS.ISSUE.INDICATOR) = ''
    END

RETURN
END
