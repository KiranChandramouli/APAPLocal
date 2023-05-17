SUBROUTINE REDO.INP.CHECK.STATUS
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.INP.CHECK.STATUS
*-------------------------------------------------------------------------
* Description: This routine is attached as input routine to the versions REDO.CLEARING.INWARD, REFER
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter :
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
* DATE             WHO               REFERENCE           DESCRIPTION
* 21-09-10         Ganesh R          ODR-2010-09-0148     Initial Creation
* 03-10-2011       JEEVA T           PACS00131732          sub process
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB PROCESS
    GOSUB SUB.PROCESS

RETURN

PROCESS:

    VAR.OLD.STATUS = R.OLD(CLEAR.CHQ.STATUS)
    VAR.CURR.STATUS = R.NEW(CLEAR.CHQ.STATUS)
    IF VAR.CURR.STATUS EQ 'REFERRED' AND VAR.OLD.STATUS EQ 'REJECTED' THEN
        ETEXT = "EB-REDO.REJECT.CHECK"
        CALL STORE.END.ERROR
    END
RETURN

*----------------------
SUB.PROCESS:
*----------------------
    Y.STATUS.PAID = ''
    Y.STATUS.PAID = R.NEW(CLEAR.CHQ.STATUS)
    IF Y.STATUS.PAID EQ 'PAID' THEN
        R.NEW(CLEAR.CHQ.REASON) = ''
    END

RETURN

END
