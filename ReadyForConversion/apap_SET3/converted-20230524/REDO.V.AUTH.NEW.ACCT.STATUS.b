SUBROUTINE REDO.V.AUTH.NEW.ACCT.STATUS
*-------------------------------------------------------------------------------------------
*This is auth routine to update ACTIVE status in new account creation
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By     : Jayasurya H
*Program   Name    : REDO.V.AUTH.NEW.ACCT.STATUS
*---------------------------------------------------------------------------------
* LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    ACCOUNT.ID = ID.NEW

    STATUS.SEQ = 'ACTIVE'

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.L.AC.STATUS.POS = LREF.POS<1,1>
    R.NEW(AC.LOCAL.REF)<1,Y.L.AC.STATUS.POS> = 'AC'

    CALL REDO.UPD.ACCOUNT.STATUS.DATE(ACCOUNT.ID,STATUS.SEQ)          ;*  To update new account active status

RETURN
END
