SUBROUTINE REDO.LETTER.ISSUE.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.LETTER.ISSUE.AUTORTN
* ODR NO : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Routine for REDO.LETTER.ISSUE to
* default the value for the TELLER application from REDO.LETTER.ISSUE
* It is AUTOM NEW CONTENT routine



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE WHO REFERENCE DESCRIPTION
*18.03.2010 H GANESH ODR-2009-10-0838 INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER


    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.LETTER.ID'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LETTER.ID=LOC.REF.POS<1,1>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.L.LETTER.ID=FIELD(Y.DATA,"*",2)
    Y.CHARGE.AMT=FIELD(Y.DATA,"*",3)
    Y.CURRENCY=FIELD(Y.DATA,"*",4)
    IF Y.CURRENCY NE LCCY THEN
        CCY.MKT='1'
        SELL.AMT=''
        CALL EXCHRATE(CCY.MKT,LCCY,SELL.AMT,Y.CURRENCY,Y.CHARGE.AMT,'','','','',RETURN.CODE)
        Y.CHARGE.AMT= SELL.AMT
    END
    R.NEW(TT.TE.AMOUNT.LOCAL.1)=Y.CHARGE.AMT
    R.NEW(TT.TE.LOCAL.REF)<1,POS.L.LETTER.ID>=Y.L.LETTER.ID
RETURN

END
