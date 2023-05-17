SUBROUTINE REDO.APAP.FX.BRN.POSN.VALIDATE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: .VALIDATE routine
*------------
*DESCRIPTION:
*------------
* This is the .VALIDATE routine to avaoid the duplication of values entered at the
* field level
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 16-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.FX.BRN.POSN

    Y.TODAY = TODAY
    Y.BRN.LIMIT.DATE = R.NEW(REDO.BRN.POSN.BRN.LIM.VALID.DATE)

    AF = REDO.BRN.POSN.MAIL.ID
    CALL DUP

    AF = REDO.BRN.POSN.BRN.LIM.VALID.DATE
    IF Y.BRN.LIMIT.DATE LT Y.TODAY THEN
        ETEXT = 'EB-DATE.NOTLT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN
*---------------------------------------------------------------------------
END
